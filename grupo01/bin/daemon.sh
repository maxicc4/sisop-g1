#!/bin/sh

#TODO: chequear que se haya inicializado previamente el ambiente

#MY_PATH="`dirname \"$0\"`"
#echo "$MY_PATH"

STOP="false"
# Deberian venir seteadas de algun lado
DIRABUS="pruebas_daemon/dirabus"
DIRACCEPTED="../files_accepted"
DIRREJECTED="../files_rejected"

# Se obtiene de a un archivo por vez
getFile()
{
	FILE="$(find $DIRABUS -type f -print -quit)"
}

verifyFile()
{
	VERIFIED="false"
	VERIFIED="$(echo $FILE | sed "/[\/ ][0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][01][0-9][0123][0-9].txt/c\true")"
}

while [ "$STOP" = "false" ]; do
	getFile
	while [ "$FILE" != "" ]; do
		verifyFile
		if [ $VERIFIED = "true" ]; then
			echo "Archivo aceptado: $FILE"
			mv $FILE $DIRACCEPTED
		else
			echo "Archivo rechazado: $FILE"
			mv $FILE $DIRREJECTED
		fi
		getFile
	done
	echo "No se encontro ningun archivo"

	sleep 3
done
