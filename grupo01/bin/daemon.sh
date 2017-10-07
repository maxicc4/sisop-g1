#!/bin/sh

#TODO: chequear que se haya inicializado previamente el ambiente

#MY_PATH="`dirname \"$0\"`"
#echo "$MY_PATH"

# Deberian venir seteadas de algun lado
DIRABUS="pruebas_daemon/dirabus"
DIRACCEPTED="../files_accepted"
DIRREJECTED="../files_rejected"

STOP="false"
CYCLE=0

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

while [ "$STOP" = "false" ]; do
	CYCLE=$((CYCLE+1))
	echo "------LOG------ Ciclo Numero $CYCLE"
	getFile
	while [ "$FILE" != "" ]; do
		verifyFormatNameFile
		if [ $VERIFIED = "false" ]; then
			echo "------LOG------ Novedad rechazada $FILE: Nombre de archivo invalido"
			mv $FILE $DIRREJECTED
		else
			verifyFormatDate
			if [ $VERIFIED = "false" ]; then
				echo "------LOG------ Novedad rechazada $FILE: Fecha invalida"
				mv $FILE $DIRREJECTED
			else
				verifyDateAgainstCurrentDate
				if [ $VERIFIED = "false" ]; then
					echo "------LOG------ Novedad rechazada $FILE: Fecha adelantada"
					mv $FILE $DIRREJECTED
				else
					verifyEmptyFile
					if [ $VERIFIED = "false" ]; then
						echo "------LOG------ Novedad rechazada $FILE: Archivo vacio"
						mv $FILE $DIRREJECTED
					else
						verifyRegularFile
						if [ $VERIFIED = "false" ]; then
							echo "------LOG------ Novedad rechazada $FILE: Tipo de archivo invalido"
							mv $FILE $DIRREJECTED
						else
							echo "------LOG------ Novedad aceptada $FILE"
							mv $FILE $DIRACCEPTED
						fi
					fi
				fi
			fi
		fi

		getFile
	done

	sleep 3
done
