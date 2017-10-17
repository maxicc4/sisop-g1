
#VARIABLES DE INSTALACION
INSTALACION_RAPIDA="";
DIR_EJECUTABLES="ejecutables"
DIR_MAESTROS="maestros"
DIR_ACEPTADOS="aceptados"
DIR_RECHAZADOS="rechazados"
DIR_VALIDADOS="validados"
DIR_REPORTES="reportes"
DIR_LOG="log"
DIR_CONFIG="dirconf"
variable=$(pwd)
export DIR_INSTALACION="$variable/grupo01"

#########################





loguear(){

if ! [ -d $DIR_INSTALACION/dirconf ]; then
	mkdir $DIR_INSTALACION/dirconf
fi
echo "$(date +"%D %X")-$1-$2-$3-$4">>$DIR_INSTALACION/$DIR_CONFIG/Instalacion.log
#loguear WHO WHERE WHAT WHY
#ie 
#loguear "Nahuel" "loguear" "no grabó" "no encontró el directorio"
}

createConfigFile(){
loguear $USER "createConfigFile:" "SE CREA EL ARCHIVO CONFIG" "OK"

	echo "ejecutables-$DIR_INSTALACION/$DIR_EJECUTABLES-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : ejecutables-$DIR_INSTALACION/$DIR_EJECUTABLES-$USER-$(date +"%D %X")" "OK"
	
	echo "maestros-$DIR_INSTALACION/$DIR_MAESTROS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : maestros-$DIR_INSTALACION/$DIR_MAESTROS-$USER-$(date +"%D %X")" "OK"
	
	echo "aceptados-$DIR_INSTALACION/$DIR_ACEPTADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : aceptados-$DIR_INSTALACION/$DIR_ACEPTADOS-$USER-$(date +"%D %X")" "OK"
	
	echo "rechazados-$DIR_INSTALACION/$DIR_RECHAZADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : rechazados-$DIR_INSTALACION/$DIR_RECHAZADOS-$USER-$(date +"%D %X")" "OK"
	
	echo "validados-$DIR_INSTALACION/$DIR_VALIDADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : validados-$DIR_INSTALACION/$DIR_VALIDADOS-$USER-$(date +"%D %X")" "OK"
	
	echo "reportes-$DIR_INSTALACION/$DIR_REPORTES-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : reportes-$DIR_INSTALACION/$DIR_REPORTES-$USER-$(date +"%D %X")" "OK"
	
	echo "logs-$DIR_INSTALACION/$DIR_LOG-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
	loguear $USER "createConfigFile:" "INSERTANDO REGISTRO : logs-$DIR_INSTALACION/$DIR_LOG-$USER-$(date +"%D %X")" "OK"


}

makeDirectories(){
loguear $USER "makeDirectories:" "CREANDO CARPETA EJECUTALES $DIR_EJECUTABLES" "OK"
mkdir -p $DIR_INSTALACION/$DIR_EJECUTABLES
loguear $USER "makeDirectories:" "CREANDO CARPETA MAESTROS $DIR_MAESTROS" "OK"
mkdir -p $DIR_INSTALACION/$DIR_MAESTROS
loguear $USER "makeDirectories:" "CREANDO CARPETA ACEPTADOS $DIR_ACEPTADOS" "OK"
mkdir -p $DIR_INSTALACION/$DIR_ACEPTADOS
loguear $USER "makeDirectories:" "CREANDO CARPETA RECHAZADOS $DIR_RECHAZADOS" "OK"
mkdir -p $DIR_INSTALACION/$DIR_RECHAZADOS
loguear $USER "makeDirectories:" "CREANDO CARPETA VALIDADOS $DIR_VALIDADOS" "OK"
mkdir -p $DIR_INSTALACION/$DIR_VALIDADOS
loguear $USER "makeDirectories:" "CREANDO CARPETA REPORTES $DIR_REPORTES" "OK"
mkdir -p $DIR_INSTALACION/$DIR_REPORTES
loguear $USER "makeDirectories:" "CREANDO CARPETA LOG $DIR_LOG" "OK"
mkdir -p $DIR_INSTALACION/$DIR_LOG


loguear $USER "SISTEMA:" "Estructura de los directorios de instalacion" "PANTALLA"

echo "Estructura de los directorios de instalacion"
echo "============================================"
find $DIR_INSTALACION -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"
echo ""
}

commands(){
#while [ "$1" != "" ]; do
   
if [ "$1" != "" ];then
      case $1 in
        -l | --log )           shift
                                echo "apreto f"
                                ;;
		-f | --fast)			shift
								echo "instalacion default";;
        -r | --repair)	        message=""
								echo "$message"
								loguear $USER "eleccion de comandos" "REPARACION" "opcion elegida"
								loguear $USER "SISTEMA:" "Reparacion del sistema" "MENSAJE EN PANTALLA"
								if ! checkInstallation;then
								repair
								else
								loguear $USER "SISTEMA:" "No existe sistema previo a reparar" "PANTALLA"
								loguear $USER "commands:" "No existe sistema previo a reparar. Terminado reparacion" "ERROR"
								echo "ERROR:"
								echo "No existe sistema previo a reparar"
								echo ""
								fi;;
        -h | --help )       	echo "Tp sistemas operativos 7508"
								echo "Para instalar el sistema el sistema ejecute el comando . install.sh"
								echo "Si se encuentra una version no completa del sistema el proceso de instalación lo informará"
								echo "Si necesita reparar el sistema ejecute el comando . install.sh -r"
								loguear $USER "SISTEMA:" "para reparar el sistema ejecute el comando -r" "MENSAJE EN PANTALLA"

                                ;;
				
        * )                     echo ""
				 message= "Invalid command. type '-h' or '--help' for instructions"
				 echo  $message
				 loguear $USER "SISTEMA:" "Invalid command. type '-h' or '--help' for instructions" "MENSAJE EN PANTALLA"

    esac
    shift
else

	
if  checkFilesForInstall;then	
loguear $USER "commands:" "archivos necesarios para instalacion" "OK"

if checkInstallation;then
loguear $USER "commands:" "sistema no esta instalado" "INSTALACION NUEVA"

setup
else

loguear $USER "commands:" "chequeo si el sistema esta instalado" "SISTEMA DETECTADO"

	if status_Installation;then
	loguear $USER "commands:" "chequeo si el sistema esta instalado" "SISTEMA INSTALADO CORRECTAMENTE"
	echo "El sistema se encuentra instalado correctamente"
	loguear $USER "SISTEMA:" "El sistema se encuentra instalado CORRECTAMENTE" "PANTALLA"

	else 
	echo "el sistema necesita reparacion. Ejecute install.sh -h para mas informacion"
	loguear $USER "SISTEMA:" "el sistema necesita reparacion. Ejecute install.sh -h para mas informacion" "PANTALLA"
	loguear $USER "commands:" "chequeo si el sistema esta instalado" "SISTEMA NECESITA REPARACION"

	fi
fi

else
echo "faltan archivos de instalacion. Terminando Instalacion"
loguear $USER "SISTEMA:" "faltan archivos de instalacion. Terminando Instalacion" "PANTALLA"
loguear $USER "commands:" "archivos necesarios para instalacion" "ERROR"

fi

fi
#done
}

checkFilesForInstall(){
loguear $USER "checkFilesForInstall:" "CHEQUEO DE ARCHIVOS DE INSTALACION" "INICIO"

if [ -d $DIR_INSTALACION/dirconf ]; then
    loguear $USER "checkFilesForInstall:" "Carpeta dirconf" "OK"
else
    loguear $USER "checkFilesForInstall:" "Carpeta dirconf" "ERROR"
    loguear $USER "checkFilesForInstall:" "Creando carpeta dirconf" "OK"

	mkdir $DIR_INSTALACION/dirconf
	no_dirconf=1
fi
if [ -f $(pwd)/maestros.tar ];then
    loguear $USER "checkFilesForInstall:" "Archivo maestros.tar" "OK"
else
    loguear $USER "checkFilesForInstall:" "Archivo maestros.tar" "ERROR"
    loguear $USER "SISTEMA:" "faltan archivos de instalacion Maestros.tar" "PANTALLA"
    echo "faltan archivos de instalacion Maestros.tar" 
	no_mae=1
fi

if [ -f $(pwd)/bin.tar ];then
	loguear $USER "checkFilesForInstall:" "Archivo bin.tar" "OK"

else
	loguear $USER "checkFilesForInstall:" "Archivo Bin.tar" "ERROR"
    loguear $USER "SISTEMA:" "faltan archivos de instalacion Bin.tar" "PANTALLA"
    echo "faltan archivos de instalacion Bin.tar" 
	no_bin=1
fi

if [ "$no_dirconf" == 1  -o  "$no_mae" == 1  -o  "$no_bin" == 1 ];then
	loguear $USER "checkFilesForInstall:" "FALTAN ARCHIVOS DE INSTALACION" "ERROR"

return 1
else 
return 0
fi
}


checkPerl(){

echo "Chequeo de version PERL"
loguear $USER "SISTEMA:" "Chequeo de version PERL" "PANTALLA"

sleep 1

V1=$(perl -e 'print substr($^V, 1)')
V2=5.0.0
result=$(echo $(perl -e '($x,$y)=@ARGV; print $x cmp $y' $V1 $V2))
loguear $USER "SISTEMA:" "[Perl] installed version $V1" "PANTALLA"
loguear $USER "checkPerl:" "VERSION DE PERL $V1" "ERROR"
echo "[Perl] installed version $V1"
if [ $result == 1 ]; then
loguear $USER "SISTEMA:" "[Perl version] == OK" "PANTALLA"
loguear $USER "checkPerl:" "VERSION DE PERL $V1" "OK"
echo "[Perl version] == OK"
echo
#loguear "Nahuel" "Perl version" "OK" "[Perl version] == OK"
return 0
else
loguear $USER "checkPerl:" "[Perl version] == ERROR ($V2 is required)" "ERROR"
loguear $USER "SISTEMA:" "[Perl version] == ERROR ($V2 is required)" "PANTALLA"
echo "[Perl version] == ERROR ($V2 is required)"
return 1
fi
}

caracteresValidos(){
if [[ $1 == *[-'!'@#\$%^\&*()_+]* ]];then
  return 0
else 
  return 1
fi
}

######################################################################
directories(){

loguear $USER "directories:" "INGRESO DE NOMBRES DE DIRECTORIOS" "INICIO"

#echo "tipo de instalacion $INSTALACION_RAPIDA"

#-----------
echo "Ingrese ruta de directorio para los archivos EJECUTABLES"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_EJECUTABLES)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos EJECUTABLES" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_EJECUTABLES)" "PANTALLA"

read in_ejecutable
READEJECUTABLE=$in_ejecutable
while caracteresValidos $READEJECUTABLE
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_ejecutable
READEJECUTABLE=$in_ejecutable
done

loguear $USER "USER:" "INGRESADO: $READEJECUTABLE" "PANTALLA"

if [ "$READEJECUTABLE" != "" ]; then
while checkNameDirectories $READEJECUTABLE 
do
loguear $USER "directories:" "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio" "PANTALLA"
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"

read in_ejecutable
READEJECUTABLE=$in_ejecutable
while caracteresValidos $READEJECUTABLE
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_ejecutable
READEJECUTABLE=$in_ejecutable
done

loguear $USER "USER:" "INGRESADO: $READEJECUTABLE" "PANTALLA"
done 
DIR_EJECUTABLES=$READEJECUTABLE
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA EJECUTABLE:: $READEJECUTABLE" "OK"

fi
#-----------
echo "Ingrese ruta de directorio para los archivos MAESTROS"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_MAESTROS)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos MAESTROS" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_MAESTROS)" "PANTALLA"

read in_maestros
READMAESTRO=$in_maestros
while caracteresValidos $READMAESTRO
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_maestros
READMAESTRO=$in_maestros
done

loguear $USER "USER:" "INGRESADO: $READMAESTRO" "PANTALLA"

if [ "$READMAESTRO" != "" ]; then
while checkNameDirectories $READMAESTRO
do
loguear $USER "directories:" "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio" "PANTALLA"
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"

read in_maestros
READMAESTRO=$in_maestros
while caracteresValidos $READMAESTRO
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_maestros
READMAESTRO=$in_maestros
done

loguear $USER "USER:" "INGRESADO: $READMAESTRO" "PANTALLA"

done
DIR_MAESTROS=$READMAESTRO
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA MAESTRO: $READMAESTRO" "OK"

fi

#--------------------------------
echo "Ingrese ruta de directorio para los archivos ACEPTADOS"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_ACEPTADOS)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos ACEPTADOS" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_ACEPTADOS)" "PANTALLA"
read in_aceptados
READACEPTADOS=$in_aceptados
while caracteresValidos $READACEPTADOS
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_aceptados
READACEPTADOS=$in_aceptados
done

loguear $USER "USER:" "INGRESADO: $READACEPTADOS" "PANTALLA"

if [ "$READACEPTADOS" != "" ]; then
while checkNameDirectories $READACEPTADOS 
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
loguear $USER "directories:" "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio" "PANTALLA"

read in_aceptados
READACEPTADOS=$in_aceptados
while caracteresValidos $READACEPTADOS
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_aceptados
READACEPTADOS=$in_aceptados
done

loguear $USER "USER:" "INGRESADO: $READACEPTADOS" "PANTALLA"
done
DIR_ACEPTADOS=$READACEPTADOS
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA ACEPTADOS: $READACEPTADOS" "OK"
fi


#----------------------------
echo "Ingrese ruta de directorio para los archivos RECHAZADOS"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_RECHAZADOS)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos RECHAZADOS" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_RECHAZADOS)" "PANTALLA"

read in_rechazados
READRECHAZADO=$in_rechazados
while caracteresValidos $READRECHAZADO
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_rechazados
READRECHAZADO=$in_rechazados
done

loguear $USER "USER:" "INGRESADO: $READRECHAZADO" "PANTALLA"

if [ "$READRECHAZADO" != "" ]; then
while checkNameDirectories $READRECHAZADO
do
loguear $USER "directories:" "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio" "PANTALLA"
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_rechazados
READRECHAZADO=$in_rechazados
while caracteresValidos $READRECHAZADO
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_rechazados
READRECHAZADO=$in_rechazados
done

loguear $USER "USER:" "INGRESADO: $READRECHAZADO" "PANTALLA"

done
DIR_RECHAZADOS=$READRECHAZADO
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA RECHAZADO: $READRECHAZADO" "OK"

fi


#-----------------------
echo "Ingrese ruta de directorio para los archivos VALIDADOS"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_VALIDADOS)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos VALIDADOS" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_VALIDADOS)" "PANTALLA"

read in_validados
READVALIDADOS=$in_validados
while caracteresValidos $READVALIDADOS
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_validados
READVALIDADOS=$in_validados
done

loguear $USER "USER:" "INGRESADO: $READVALIDADOS" "PANTALLA"

if [ "$READVALIDADOS" != "" ]; then

while checkNameDirectories $READVALIDADOS
do
loguear $USER "directories:" "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio" "PANTALLA"
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_validados
READVALIDADOS=$in_validados
while caracteresValidos $READVALIDADOS
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_validados
READVALIDADOS=$in_validados
done
loguear $USER "USER:" "INGRESADO: $READVALIDADOS" "PANTALLA"

done
DIR_VALIDADOS=$READVALIDADOS
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA READVALIDADOS: $READVALIDADOS" "OK"

fi


#----------------------
echo "Ingrese ruta de directorio para los archivos de REPORTES"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_REPORTES)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos REPORTES" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_REPORTES)" "PANTALLA"

read in_reportes
READREPORTES=$in_reportes
while caracteresValidos $READREPORTES
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_reportes
READREPORTES=$in_reportes
done

loguear $USER "USER:" "INGRESADO: $READREPORTES" "PANTALLA"

if [ "$READREPORTES" != "" ]; then
while checkNameDirectories $READREPORTES
do
loguear $USER "directories:" "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio" "PANTALLA"
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"

read in_reportes
READREPORTES=$in_reportes
while caracteresValidos $READREPORTES
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_reportes
READREPORTES=$in_reportes
done

loguear $USER "USER:" "INGRESADO: $READREPORTES" "PANTALLA"

done
DIR_REPORTES=$READREPORTES
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA REPORTES: $READREPORTES" "OK"
fi

#-------------------------
echo "Ingrese ruta de directorio para los archivos de LOG"
echo "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_LOG)"
echo "==================================================================="
loguear $USER "SISTEMA:" "Ingrese ruta de directorio para los archivos LOG" "PANTALLA"
loguear $USER "SISTEMA:" "Presione 'Enter' para ruta default ($DIR_INSTALACION/$DIR_LOG)" "PANTALLA"

read in_log
READLOG=$in_log
while caracteresValidos $READLOG
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_log
READLOG=$in_log
done

loguear $USER "USER:" "INGRESADO: $READLOG" "PANTALLA"

if [ "$READLOG" != "" ]; then
while checkNameDirectories $READLOG
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"

read in_log
READLOG=$in_log
while caracteresValidos $READLOG
do
echo "caratecteres invalidos ; no puede ingresar los sig caratecteres : -'!'@#\$%^\&*()_+ "
echo "ingrese nuevamente."
read in_log
READLOG=$in_log
done

loguear $USER "USER:" "INGRESADO: $READLOG" "PANTALLA"

done
DIR_LOG=$READLOG
loguear $USER "directories:" "DIRECTORIO ELEGIDO PARA LOG: $READLOG" "OK"

fi
clear
}


##############################################################3


showDirectories(){
loguear $USER "showDirectories:" "MOSTRAR RUTA DIRECTORIOS ELEGIDOS" "PANTALLA"

echo "Directorios de instalacion"
echo "=========================="

echo "$DIR_INSTALACION/$DIR_EJECUTABLES"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_EJECUTABLES" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_MAESTROS"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_MAESTROS" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_ACEPTADOS"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_ACEPTADOS" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_RECHAZADOS"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_RECHAZADOS" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_VALIDADOS"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_VALIDADOS" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_REPORTES"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_REPORTES" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_LOG"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_LOG" "PANTALLA"
echo "$DIR_INSTALACION/$DIR_CONFIG"
loguear $USER "showDirectories:" "$DIR_INSTALACION/$DIR_CONFIG" "PANTALLA"


}

repararInstalacion(){
echo "reparacion"
}

extrayendoMaestros(){
loguear $USER "extrayendoMaestros:" "Extrayendo files de maestros.tar en $1" "OK"

#tar -xf maestros.tar -C /$DIR_INSTALACION/maestros
tar -xf maestros.tar -C /$1

}

extrayendoBinFiles(){
loguear $USER "extrayendoBinFiles:" "Extrayendo files de bin.tar en $1" "OK"

tar -xf bin.tar -C /$1
#cp -r bin/. $1/
#cp -r bin/. $DIR_INSTALACION/$DIR_EJECUTABLES/

}

removeInstallationFiles(){
rm -r $(pwd)/bin
rm -r $(pwd)/maestros
}

existeFile(){

[ -f $1 ] && return 0 || return 1

}

caracterYoN(){

	if [ "$1" == "y" ] || [ "$1" == "n" ] ; then		
     return 0
    else 
   	 return 1
    fi
}

setup(){
clear
echo "*******************************************************************"
echo "*	       							  *"
echo "*                 Instalacion TP Sistemas Operativos              *"
echo "*								  *"
echo "*******************************************************************"
echo ""
sleep 1


##########################################INSTALACION NUEVA.#########################################
loguear $USER "Setup" "COMIENZO DE INSTALACION" "INICIO = OK"

#chequeando version de perl (mayor a v5 para instalar)

if checkPerl; then
continuar=1
while [ "$continuar" == 1 ]; do
 
directories
showDirectories
loguear $USER "setup:" "Confirmar estructura de directorios (y/n)" "PANTALLA"
echo "Confirmar estructura de directorios (y/n)"

read confirmar
valido=$confirmar

while ! caracterYoN $valido
do
echo "Ingreso incorrecto. Ingrese 'y' para confirmar o 'n' para ingresar nuevos directorios"
read confirmar
valido=$confirmar
done



	if [ $valido == 'y' ];then	
	continuar=0
	
	makeDirectories
	echo "Creando directorios"
	barra_progreso
	echo "INSTALANDO..."
	barra_progreso
	extrayendoMaestros $DIR_INSTALACION/$DIR_MAESTROS
	extrayendoBinFiles $DIR_INSTALACION/$DIR_EJECUTABLES
#	removeInstallationFiles
	fi
done
echo "Creando arhivo de configuracion"
barra_progreso
createConfigFile
fi
#fi
echo "Removiendo archivos de instalacion"
barra_progreso
}

#devuelve 0 si la carpeta existe
existeCarpeta(){

[ -d $1 ] && return 0 || return 1

}

checkNameDirectories(){

if [ "$1" != "$DIR_EJECUTABLES" -a "$1" != "$DIR_MAESTROS" -a "$1" != "$DIR_ACEPTADOS" -a "$1" != "$DIR_RECHAZADOS" -a "$1" != "$DIR_VALIDADOS" -a "$1" != "$DIR_REPORTES" -a "$1" != "$DIR_LOG" -a "$1" != "$DIR_CONFIG" ];then 
return 1
else 
return 0
fi

}

barra_progreso(){
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
}

repair(){
clear
echo "*******************************************************************"
echo "*	       							  *"
echo "*                 		Reparacion 				                *"
echo "*								  *"
echo "*******************************************************************"
echo ""
sleep 1
if  checkFilesForInstall;then
echo "Chequeo de archivos necesarios para reparacion Correctos"
echo "OK"
echo ""
archivoConf=$DIR_INSTALACION/dirconf/config.config
while read lineaConf
do
	directorio=$(echo "$lineaConf" | cut -d '-' -f1)
	case "$directorio" in
		ejecutables)
                        ejecutable=$(echo "$lineaConf" | cut -d '-' -f2);;
 		maestros)
                        maestro=$(echo "$lineaConf" | cut -d '-' -f2);;
 		rechazados)
                        rechazado=$(echo "$lineaConf" | cut -d '-' -f2);;
		aceptados)
			acetp=$(echo "$lineaConf" | cut -d '-' -f2);;

		validados) 
			validado=$(echo "$lineaConf" | cut -d '-' -f2);;
			
		reportes)
			reportes=$(echo "$lineaConf" | cut -d '-' -f2);;			
		log)
			log=$(echo "$lineaConf" | cut -d '-' -f2);;
		*)
			continue;
	esac

done < $archivoConf

echo "Reparando directorios de instalacion"
barra_progreso

if ! [ -d $ejecutable ]; then
mkdir -p $ejecutable
loguear $USER "repair:" "NO EXISTE DIRECTORIO EJECUTABLE" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO EJECUTABLE $ejecutable" "REPARANDO"

extrayendoBinFiles $ejecutable
fi

if ! [ -d $maestro ]; then
mkdir $maestro
extrayendoMaestros $DIR_INSTALACION/$maestro
loguear $USER "repair:" "NO EXISTE DIRECTORIO MAESTROS" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO MAESTROS $maestro" "REPARANDO"
fi

if ! [ -d $rechazado ]; then
loguear $USER "repair:" "NO EXISTE DIRECTORIO RECHAZADOS" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO RECHAZADOS $rechazado" "REPARANDO"
mkdir $rechazado
fi

if ! [ -d $validado ]; then
loguear $USER "repair:" "NO EXISTE DIRECTORIO VALIDADOS" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO RECHAZADOS $validado" "REPARANDO"
mkdir $validado
fi

if ! [ -d $reportes ]; then
mkdir $reportes
loguear $USER "repair:" "NO EXISTE DIRECTORIO REPORTES" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO RECHAZADOS $reportes" "REPARANDO"

fi

if ! [ -d $acept ]; then
loguear $USER "repair:" "NO EXISTE DIRECTORIO ACEPTADOS" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO RECHAZADOS $acept" "REPARANDO"

mkdir $acept
fi

if ! [ -d $log ]; then
loguear $USER "repair:" "NO EXISTE DIRECTORIO LOG" "ERROR"
loguear $USER "repair:" "CREANDO DIRECTORIO RECHAZADOS $log" "REPARANDO"

mkdir $log
fi

echo "Reparando archivos maestros"
barra_progreso
mkdir maestros
extrayendoMaestros $(pwd)/maestros
for f in $(pwd)/maestros/*
do
g=$(echo "$f" | cut -d '/' -f7)
if ! [ -f $maestro/$g ];then
#estado_sistema=1
echo "no existe archivo maestro: $g"
echo "restaurando archivo faltante $g"

loguear $USER "SISTEMA:" "NO EXISTE ARCHIVO MAESTRO $g" "PANTALLA"
loguear $USER "SISTEMA:" "RESTAURANDO ARCHIVO FALTANTE $g" "PANTALLA"

loguear $USER "repair:" "NO EXISTE ARCHIVO $g" "ERROR"
loguear $USER "repair:" "COPIANDO ARCHIVO FALTANTE $g" "REPARANDO"

cp maestros/$g $maestro/	

#return $estado_sistema
fi
done

echo "Reparando archivos ejecutables"
barra_progreso
## cheque que existan todos los achivos ejecutables
mkdir bin
extrayendoBinFiles $(pwd)/bin
for f in bin/*
do
g=$(echo "$f" | cut -d '/' -f2)
if ! [ -f $ejecutable/$g ];then

echo "no existe archivo ejecutable: $g"
echo "restaurando archivo faltante $g"

loguear $USER "SISTEMA:" "NO EXISTE ARCHIVO EJECUTABLE $g" "PANTALLA"
loguear $USER "SISTEMA:" "RESTAURANDO ARCHIVO FALTANTE $g" "PANTALLA"

loguear $USER "repair:" "NO EXISTE ARCHIVO $g" "ERROR"
loguear $USER "repair:" "COPIANDO ARCHIVO FALTANTE $g" "REPARANDO"

cp bin/$g $ejecutable/	

echo "existe"
fi
done



removeInstallationFiles
echo "Reparacion existosa"
loguear $USER "SISTEMA:" "Reparacion existosa" "PANTALLA"
loguear $USER "repair:" "REPARACION FINALIZADA" "OK"

else
loguear $USER "repair:" "faltan archivos de instalacion. Terminando reparacion" "PANTALLA"
echo "faltan archivos de instalacion. Terminando reparacion"
loguear $USER "repair:" "REPARACION FINALIZADA" "ERROR : FALTAN ARCHIVOS DE INSTALACION"
fi

}

checkInstallation(){
loguear $USER "checkInstallation:" "CHEQUEO INSTALACION PREVIA" "INICIO"
#devuelve 0 si no existe instalacion previa.
#devuelve 1 si el sistema esta instalado.
archivoConf=$DIR_INSTALACION/dirconf/config.config

if ! [ -f $archivoConf ];then
loguear $USER "checkInstallation:" "NO HAY SISTEMA INSTALADO" "FILE CONFIG.CONFIG NO EXISTE"
return 0
else 
loguear $USER "checkInstallation:" "SISTEMA INSTALADO" "FILE CONFIG.CONFIG EXISTE"

return 1
fi
}

status_Installation(){
loguear $USER "status_Installation:" "CHEQUEO ESTADO DE INSTALACION EN SISTEMA" "INICIO"

while read lineaConf
do
	directorio=$(echo "$lineaConf" | cut -d '-' -f1)
	case "$directorio" in
		ejecutables)
                        ejecutable=$(echo "$lineaConf" | cut -d '-' -f2);;
 		maestros)
                        maestro=$(echo "$lineaConf" | cut -d '-' -f2);;
 		rechazados)
                        rechazado=$(echo "$lineaConf" | cut -d '-' -f2);;
		aceptados)
			acetp=$(echo "$lineaConf" | cut -d '-' -f2);;

		validados) 
			validado=$(echo "$lineaConf" | cut -d '-' -f2);;
			
		reportes)
			reportes=$(echo "$lineaConf" | cut -d '-' -f2);;			
		log)
			log=$(echo "$lineaConf" | cut -d '-' -f2);;
		*)
			continue;
	esac

done < $archivoConf


if ! [ -d $ejecutable ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA $ejecutable" "ERROR"
loguear $USER "status_Installation:" "no existe carpeta $ejecutable" "PANTALLA"
echo "no existe carpeta $ejecutable"
return $estado_sistema
fi

if ! [ -d $maestro ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA MAESTROS" "ERROR"
loguear $USER "status_Installation:" "NO EXISTE CARPETA MAESTROS" "PANTALLA"
echo "no existe carpeta $maestro"
return $estado_sistema
fi

if ! [ -d $rechazado ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA $rechazado" "ERROR"
loguear $USER "status_Installation:" "NO EXISTE CARPETA $rechazado" "PANTALLA"
echo "no existe carpeta $rechazado"
return $estado_sistema
fi

if ! [ -d $validado ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA $validado" "ERROR"
loguear $USER "status_Installation:" "NO EXISTE CARPETA $validado" "PANTALLA"
echo "no existe carpeta $validado"
return $estado_sistema
fi

if ! [ -d $reportes ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA $reportes" "ERROR"
loguear $USER "status_Installation:" "NO EXISTE CARPETA $reportes" "PANTALLA"
echo "no existe carpeta $reportes"
return $estado_sistema
fi

if ! [ -d $acept ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA $acept" "ERROR"
loguear $USER "status_Installation:" "NO EXISTE CARPETA $acept" "PANTALLA"
echo "no existe carpeta $acept"
return $estado_sistema
fi

if ! [ -d $log ]; then
estado_sistema=1
loguear $USER "status_Installation:" "NO EXISTE CARPETA $log" "ERROR"
loguear $USER "status_Installation:" "NO EXISTE CARPETA $log" "PANTALLA"
echo "no existe carpeta $log"
return $estado_sistema
fi

##
#checkMasterFiles
mkdir $(pwd)/maestros
extrayendoMaestros $(pwd)/maestros
for f in $(pwd)/maestros/*
do
g=$(echo "$f" | cut -d '/' -f7)
if ! [ -f $maestro/$g ];then
estado_sistema=1
loguear $USER "status_Installation:" "EN CARPETA MAESTROS: NO EXISTE ARCHIVO $g" "ERROR"
loguear $USER "status_Installation:" "EN CARPETA MAESTROS: NO EXISTE ARCHIVO $g" "PANTALLA"
echo "no existe archivo maestro: $g"
rm -r maestros
return $estado_sistema
fi
done


## cheque que existan todos los achivos ejecutables
mkdir $(pwd)/bin
extrayendoBinFiles $(pwd)/bin
for f in bin/*
do
g=$(echo "$f" | cut -d '/' -f2)

if ! [ -f $ejecutable/$g ];then
estado_sistema=1
loguear $USER "status_Installation:" "EN CARPETA $ejecutable: NO EXISTE ARCHIVO $g" "ERROR"
loguear $USER "status_Installation:" "EN CARPETA $ejecutable: NO EXISTE ARCHIVO $g" "PANTALLA"
echo "no existe ejecutable $g"
rm -r bin
rm -r $(pwd)/maestros
return $estado_sistema
fi
done
##

estado_sistema=0
rm -r $(pwd)/bin
rm -r $(pwd)/maestros

return $estado_sistema

}

#################################################################
##############FUNCIONES DE INSTALACION###########################
#checkInstallation
#status=$(checkInstallation)
#echo "$status"
#if [ $status == "0" ];then 
#echo "sistema no istnaldo"
#fi

#devuelve 0, el sistema no esta instalado

loguear $USER "Main" "Comienzo de instalacion" "INICIO INSTALADOR"

commands $1
#checkFiles
#FILES=$(pwd)/bin/
