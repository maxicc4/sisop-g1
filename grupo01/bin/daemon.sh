#!/bin/sh

#TODO: chequear que se haya inicializado previamente el ambiente

STOP=false;
DIRABUS="pruebas_daemon";  # Deberian venir seteada de algun lado

while [ "$STOP" = false ]; do
	echo "Archivos encontrados:"
	find $DIRABUS -name '[0-9][0-9][0-9]_[0-9][0-9][0-9][0-9][01][0-9][0123][0-9].txt'
	sleep 2;
done
