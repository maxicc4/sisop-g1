#!/bin/sh

# Para pruebas
#export DIRABUS="/home/ixam/sisop/sisop-g1/dirabus"
#export ACEPTADOS="/home/ixam/sisop/sisop-g1/grupo01/files_accepted"
#export RECHAZADOS="/home/ixam/sisop/sisop-g1/grupo01/files_rejected"
#export MAESTROS="/home/ixam/sisop/sisop-g1/grupo01/master_files"
#export LOGS="/home/ixam/sisop/sisop-g1/grupo01/logs"
#export EJECUTABLES="/home/ixam/sisop/sisop-g1/grupo01/bin"
#export VALIDADOS="/home/ixam/sisop/sisop-g1/grupo01/files_validated"

# Chequeo que se haya inicializado el ambiente
if [ -z "$DIRABUS" ]; then
	echo "ERROR - Ambiente no inicializado"
	exit 1
fi
if [ -z "$ACEPTADOS" ]; then
	echo "ERROR - Ambiente no inicializado"
	exit 1
fi
if [ -z "$RECHAZADOS" ]; then
	echo "ERROR - Ambiente no inicializado"
	exit 1
fi
if [ -z "$MAESTROS" ]; then
	echo "ERROR - Ambiente no inicializado"
	exit 1
fi
if [ -z "$LOGS" ]; then
	echo "ERROR - Ambiente no inicializado"
	exit 1
fi
if [ -z "$EJECUTABLES" ]; then
	echo "ERROR - Ambiente no inicializado"
	exit 1
fi

STOP="false"
CYCLE=0
COUNTERTRUNCATELOG=0
BANKENTITIES="$(cut -d';' -f1 "$MAESTROS/bamae")"
VALIDATORID=""

# Se obtiene de a un archivo por vez
getFile()
{
	FILE="$(find $DIRABUS -type f -print -quit)"
}

verifyFormatNameFile()
{
	VERIFIED="$(echo "$FILE" | sed "/[\/ ][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].txt/c\true")"
	if [ "$VERIFIED" != "true" ]; then
		VERIFIED="false"
	fi
}

verifyFormatDate()
{
	VERIFIED="$(echo "$FILE" | sed -r "/[\/ ][0-9][0-9][0-9]_([0][0][0][1-9]|[0][0][1-9][0-9]|[0][1-9][0-9][0-9]|[1-9][0-9][0-9][0-9])((01|03|05|07|08|10|12)([0][1-9]|[12][0-9]|[3][01])|(04|06|09|11)([0][1-9]|[12][0-9]|[3][0])|02([0][1-9]|[12][0-9])).txt/c\true")"
	if [ "$VERIFIED" != "true" ]; then
		VERIFIED="false"
	fi
}

verifyDateAgainstCurrentDate()
{
	DATE="$(echo -n "$FILE" | tail -c -12 | cut -c-8)"
	CURRENTDATE="$(date "+%Y%m%d")"
	RESULT="$(echo "$DATE <= $CURRENTDATE" | bc)"

	if [ "$RESULT" = 1 ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

verifyEmptyFile()
{
	if [ -s "$FILE" ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

verifyRegularFile()
{
	typeFile="$(file -i "$FILE" | cut -d' ' -f2)"
	if [ "$typeFile" = "text/plain;" ]; then
		VERIFIED="true"
	else
		VERIFIED="false"
	fi
}

verifyEntityExistsInMaster()
{
	ENTITY="$(echo -n "$FILE" | tail -c -16 | cut -c-3)"
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
	echo "$CURRENTDATE - $USER - $1 - $2" >> "$LOGS/demonio.log"
}

runValidator()
{
	bash "$EJECUTABLES/validador.sh" &
	VALIDATORID=$!
	writeLog "INFO" "Validador invocado: process id $VALIDATORID"
}

# Basicamente es un contador que se va guardando en un archivo oculto
getDuplicateSequence()
{
	if [ -e "$EJECUTABLES/.dups_$1" ]; then
		SEQUENCEDUP="$(head -n1 "$EJECUTABLES/.dups_$1")"
		echo "$SEQUENCEDUP + 1" | bc > "$EJECUTABLES/.dups_$1"
	else
		SEQUENCEDUP=0
		echo "1" > "$EJECUTABLES/.dups_$1"
	fi
}

rejectFile()
{
	writeLog "INFO" "Novedad rechazada <$FILE>: $1"
	NAMEFILE="$(echo "$FILE" | rev | cut -d'/' -f1 | rev )"
	if [ -e "$RECHAZADOS/$NAMEFILE" ]; then
		if [ ! -d "$RECHAZADOS/dup" ]; then
			mkdir "$RECHAZADOS/dup"
		fi
		getDuplicateSequence "files_rejected"
		mv "$FILE" "$RECHAZADOS/dup/$NAMEFILE.$SEQUENCEDUP"
	else
		mv "$FILE" "$RECHAZADOS"
	fi
}

acceptFile()
{
	writeLog "INFO" "Novedad aceptada <$FILE>"
	NAMEFILE="$(echo "$FILE" | rev | cut -d'/' -f1 | rev )"
	if [ -e "$ACEPTADOS/$NAMEFILE" ]; then
		if [ ! -d "$ACEPTADOS/dup" ]; then
			mkdir "$ACEPTADOS/dup"
		fi
		getDuplicateSequence "files_accepted"
		mv "$FILE" "$ACEPTADOS/dup/$NAMEFILE.$SEQUENCEDUP"
	else
		mv "$FILE" "$ACEPTADOS"
	fi
}

while [ "$STOP" = "false" ]; do
	CYCLE=$((CYCLE+1))
	COUNTERTRUNCATELOG=$((COUNTERTRUNCATELOG+1))
	writeLog "INFO" "Ciclo Numero $CYCLE"
	getFile
	while [ "$FILE" != "" ]; do
		verifyFormatNameFile
		if [ "$VERIFIED" = "false" ]; then
			rejectFile "Nombre de archivo invalido"
		else
			verifyFormatDate
			if [ "$VERIFIED" = "false" ]; then
				rejectFile "Fecha invalida"
			else
				verifyDateAgainstCurrentDate
				if [ "$VERIFIED" = "false" ]; then
					rejectFile "Fecha adelantada"
				else
					verifyEntityExistsInMaster
					if [ "$VERIFIED" = "false" ]; then
						rejectFile "Entidad inexistente"
					else
						verifyEmptyFile
						if [ "$VERIFIED" = "false" ]; then
							rejectFile "Archivo vacio"
						else
							verifyRegularFile
							if [ "$VERIFIED" = "false" ]; then
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

	if [ "$(ls -A $ACEPTADOS)" ]; then
		# La primera vez entra aca
		if [ "$VALIDATORID" = "" ]; then
			runValidator
		else
			# Si el proceso sigue corriendo
			if [ "$(ps -q $VALIDATORID -o comm=)" ]; then
				writeLog "INFO" "Invocacion del Validador pospuesta para el siguiente ciclo"
			else
				runValidator
			fi
		fi
	fi

	if [ $COUNTERTRUNCATELOG -ge 100 ]; then
		tail -n50 "$LOGS/demonio.log" > "$LOGS/demonio2.log"
		mv "$LOGS/demonio2.log" "$LOGS/demonio.log"
		writeLog "INFO" "Log truncado"
		COUNTERTRUNCATELOG=0
	fi

	sleep 5
done
