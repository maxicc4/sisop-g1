#!/bin/sh

STOP=false;
DIRABUS=".";  # Deberian venir seteada de algun lado

while [ "$STOP" = false ]; do
	echo "Ejecuto comando ls cada 2 seg:"
	ls $DIRABUS;
	sleep 2;
done