#!/bin/sh
readonly NOMBRE_ARCHIVO_LOG="PreparadorLog.txt"
#Cargo o guardo el directorio de instalacion
if [ -f "$PWD/directorioInstalacion.txt" ]; then
		DIR_INSTALACION=$(cut -d ':' -f2 "$PWD/directorioInstalacion.txt")	
		export DIR_INSTALACION
	
else
		echo "Error de instalacion. Por favor repare la instalacion."
fi

loggear() {
	fecha_actual=$(date '+%d/%m/%Y %H:%M:%S')
	usuario=$USER
	comando_actual=$1
	tipo_de_log=$2
	mensaje=$3

	echo "$fecha_actual-$usuario-$comando_actual-$tipo_de_log-$mensaje" >> $NOMBRE_ARCHIVO_LOG
}

existe_directorio () {
	if [ -d $1 ]; then
		true
	else
		false
	fi
}

agregar_permisos () {
	directorio=$1
	permiso=$2
	for archivo in $(ls "$directorio"/); do
		chmod +$permiso $directorio/$archivo
		loggear "agregar_permisos" "INFO" "Se agrego el permiso '$permiso' al archivo $archivo"
	done
}

agregar_variable_de_ambiente () {
	nombre_de_variable_en_mayusculas=$(echo $1 | tr [a-z] [A-Z])
	export $nombre_de_variable_en_mayusculas=$2
	loggear "agregar_variable_de_ambiente" "INFO" "Se agregó la variable de ambiente $nombre_de_variable_en_mayusculas"
}

solicitar_directorio_de_busqueda() {
	loggear "solicitar_directorio_de_busqueda" "INFO" "Solicitando directorio de busqueda"

	directorio_invalido=true

	while [ $directorio_invalido = true ]; do
		
		read -p 'Defina el directorio de búsqueda (Ingrese el directorio completo): ' directorio_de_busqueda
		
		if existe_directorio "$directorio_de_busqueda"; then
			directorio_invalido=false
			loggear "solicitar_directorio_de_busqueda" "INFO" "El directorio ingresado por el usuario '$directorio_de_busqueda' es válido"
		else
			echo "ERROR: El directorio ingresado '$directorio_de_busqueda' no es un directorio válido."
			loggear "solicitar_directorio_de_busqueda" "ERROR" "El directorio ingresado por el usuario '$directorio_de_busqueda' no es un directorio válido"
		fi
	done

	agregar_variable_de_ambiente "DIRABUS" $directorio_de_busqueda
}

ejecutar_demonio() {
	. demonio.sh &
	process_id=$!

	loggear "ejecutar_demonio" "INFO" "Ejecutando el demonio. Process ID: $process_id"
	echo "Ejecutando el demonio. Process ID: $process_id"
	
	agregar_variable_de_ambiente "process_id" $process_id
}

stop_demonio() {
	kill $PROCESS_ID
}

verificar_configuracion_de_directorios_necesarios() {
	loggear "verificar_configuracion_de_directorios_necesarios" "INFO" "Verificando la configuración de todos los directorios necesarios"
	while read -r directorio; do
		registro=$(grep "^$directorio.*" $archivo_de_configuracion)
		if [ -z "$registro" ]; then
			echo ERROR: "El directorio '$directorio' no fue configurado"
			loggear "verificar_configuracion_de_directorios_necesarios" "ERROR" "El directorio '$directorio' no fue configurado"
			return 0
		fi
	done < "directorios_necesarios.txt"
	loggear "verificar_configuracion_de_directorios_necesarios" "INFO" "Se verificó la configuración de todos los directorios necesarios con éxito"
	return 1
}

verificar_existencia_de_directorios_configurados() {
	loggear "verificar_existencia_de_directorios_configurados" "INFO" "Verificando la existencia de los directorios configurados"
	archivo_de_configuracion=$1

	while IFS='-' read -r identificador_directorio valor usuario fecha; do
		if existe_directorio "$valor"; then
			agregar_variable_de_ambiente $identificador_directorio $valor
		else
  			echo ERROR: "No se encontró el directorio configurado '$valor' para los archivos '$identificador_directorio'"	
  			loggear "verificar_existencia_de_directorios_configurados" "ERROR" "No se encontró el directorio configurado '$valor' para los archivos '$identificador_directorio'"
  			return 0
		fi
	done < $archivo_de_configuracion
	loggear "verificar_existencia_de_directorios_configurados" "INFO" "Se verificó la existencia de todos los directorios configurados"
	return 1
}

mover_archivo_log() {
	mv $NOMBRE_ARCHIVO_LOG $LOGS/$NOMBRE_ARCHIVO_LOG 
}

main () {
	loggear "main" "INFO" "Inicio del preparador"
	
	archivo_de_configuracion=$DIR_INSTALACION/dirconf/config.config
	loggear "main" "INFO" "El archivo de configuración recibido por parametros es: '$archivo_de_configuracion'"
	
	verificar_configuracion_de_directorios_necesarios
	if [ $? -eq 0 ]; then
		return 0
	fi
	verificar_existencia_de_directorios_configurados $archivo_de_configuracion
	if [ $? -eq 0 ]; then
		return 0
	fi
	agregar_permisos $MAESTROS "r"
	agregar_permisos $EJECUTABLES "x"

	solicitar_directorio_de_busqueda
	ejecutar_demonio

	loggear "main" "INFO" "Fin del preparador"
	mover_archivo_log
	return 1
}

main $1
export stop_demonio
