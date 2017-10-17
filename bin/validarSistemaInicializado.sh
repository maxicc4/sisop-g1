estado_sistema=0
	if ! [ -d $EJECUTABLES ]; then
		estado_sistema=1
		echo "No existe la carpeta de ejecutables"
		return $estado_sistema
	fi
	if ! [ -d $MAESTROS ]; then
		estado_sistema=1
		echo "No existe la carpeta maestro"
		return $estado_sistema
	fi
	if ! [ -d $RECHAZADOS ]; then
		estado_sistema=1
		echo "No existe la carpeta de rechazados"
		return $estado_sistema
	fi
	if ! [ -d $VALIDADOS ]; then
		estado_sistema=1
		echo "No existe la carpeta de validados"
		return $estado_sistema
	fi

	if ! [ -d $ACEPTADOS ]; then
		estado_sistema=1
		echo "No existe la carpeta de aceptados"		
		return $estado_sistema
	fi
	if ! [ -d $LOGS ]; then
		estado_sistema=1
		echo "No existe la carpeta de logs"
		return $estado_sistema
	fi

	

return $estado_sistema


