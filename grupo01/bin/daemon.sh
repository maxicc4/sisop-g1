#!/bin/sh

#TODO: chequear que se haya inicializado previamente el ambiente

#MY_PATH="`dirname \"$0\"`"
#echo "$MY_PATH"

# Deberian venir seteadas de algun lado
DIRABUS="pruebas_daemon/dirabus"
DIRACCEPTED="../files_accepted"
DIRREJECTED="../files_rejected"
DIRMASTERFILES="../master_files"
DIRLOGS="../logs"

STOP="false"
CYCLE=0
COUNTERTRUNCATELOG=0
BANKENTITIES="$(cut -d';' -f1 "$DIRMASTERFILES/bamae")"
VALIDATORID=""

# Se obtiene de a un archivo por vez
getFile()
{
	FILE="$(find $DIRABUS -type f -print -quit)"
}

verifyFormatNameFile()
{
	VERIFIED="$(echo $FILE | sed "/[\/ ][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].txt/c\true")"
	if [ $VERIFIED != "true" ]; then
		VERIFIED="false"
	fi
}

verifyFormatDate()
{
	VERIFIED="$(echo $FILE | sed -r "/[\/ ][0-9][0-9][0-9]_([0][0][0][1-9]|[0][0][1-9][0-9]|[0][1-9][0-9][0-9]|[1-9][0-9][0-9][0-9])((01|03|05|07|08|10|12)([0][1-9]|[12][0-9]|[3][01])|(04|06|09|11)([0][1-9]|[12][0-9]|[3][0])|02([0][1-9]|[12][0-9])).txt/c\true")"
	if [ $VERIFIED != "true" ]; then
		VERIFIED="false"
	fi
}

verifyDateAgainstCurrentDate()
{
	DATE="$(echo -n $FILE | tail -c -12 | cut -c-8)"
	CURRENTDATE="$(date "+%Y%m%d")"
	RESULT="$(echo "$DATE <= $CURRENTDATE" | bc)"

	if [ $RESULT = 1 ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

verifyEmptyFile()
{
	if [ -s $FILE ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

verifyRegularFile()
{
	typeFile="$(file -i $FILE | cut -d' ' -f2)"
	if [ $typeFile = "text/plain;" ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

verifyEntityExistsInMaster()
{
	ENTITY="$(echo -n $FILE | tail -c -16 | cut -c-3)"
	RESULT="$(echo $BANKENTITIES | grep $ENTITY)"
	if [ "$RESULT" != "" ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

writeLog()
{
	CURRENTDATE="$(date "+%Y/%m/%d %H:%M:%S")"
	echo "$CURRENTDATE - $1" >> "$DIRLOGS/demonio.log"
}

runValidator()
{
	# Cambiar despues por el nombre o ubicacion del validador
	validador &
	VALIDATORID=$!
	writeLog "Validador invocado: process id $VALIDATORID"
}

rejectFile()
{
	writeLog "Novedad rechazada <$FILE>: $1"
	mv $FILE $DIRREJECTED
}

acceptFile()
{
	writeLog "Novedad aceptada <$FILE>"
	mv $FILE $DIRACCEPTED
}

while [ "$STOP" = "false" ]; do
	CYCLE=$((CYCLE+1))
	COUNTERTRUNCATELOG=$((COUNTERTRUNCATELOG+1))
	writeLog "Ciclo Numero $CYCLE"
	getFile
	while [ "$FILE" != "" ]; do
		verifyFormatNameFile
		if [ $VERIFIED = "false" ]; then
			rejectFile "Nombre de archivo invalido"
		else
			verifyFormatDate
			if [ $VERIFIED = "false" ]; then
				rejectFile "Fecha invalida"
			else
				verifyDateAgainstCurrentDate
				if [ $VERIFIED = "false" ]; then
					rejectFile "Fecha adelantada"
				else
					verifyEntityExistsInMaster
					if [ $VERIFIED = "false" ]; then
						rejectFile "Entidad inexistente"
					else
						verifyEmptyFile
						if [ $VERIFIED = "false" ]; then
							rejectFile "Archivo vacio"
						else
							verifyRegularFile
							if [ $VERIFIED = "false" ]; then
								rejectFile "Tipo de archivo invalido"
							else
								acceptFile
							fi
						fi
					fi
				fi
			fi
		fi

		getFile
	done

	: ' Lo comento por ahora hasta que este el validador
	if [ "$(ls -A $DIRACCEPTED)" ]; then
		# La primera vez entra aca
		if [ "$VALIDATORID" = "" ]; then
			runValidator
		else
			# Si el proceso sigue corriendo
			if [ "$(ps -q $VALIDATORID -o comm=)" ]; then
				writeLog "Invocacion del Validador pospuesta para el siguiente ciclo"
			else
				runValidator
			fi
		fi
	fi
	'

	if [ $COUNTERTRUNCATELOG -ge 100 ]; then
		tail -n50 "$DIRLOGS/demonio.log" > "$DIRLOGS/demonio2.log"
		mv "$DIRLOGS/demonio2.log" "$DIRLOGS/demonio.log"
		writeLog "Log truncado"
		COUNTERTRUNCATELOG=0
	fi

	sleep 3
done
