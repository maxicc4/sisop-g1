#!/bin/sh

#TODO: chequear que se haya inicializado previamente el ambiente

#MY_PATH="`dirname \"$0\"`"
#echo "$MY_PATH"

STOP=false
DIRABUS="pruebas_daemon/dirabus"  # Deberian venir seteada de algun lado

while [ "$STOP" = false ]; do
	FILE="$(find $DIRABUS -name '[0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][01][0-9][0123][0-9].txt' -print -quit)"
	if [ "$FILE" != "" ]; then
		echo "Archivo encontrado: $FILE"
		mv $FILE pruebas_daemon/aceptados
	else
		echo "No se encontro ningun archivo"
	fi

	sleep 3
done
