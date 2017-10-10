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
DIR_INSTALACION="grupo01"
#########################


#RUTAS DE ARCHIVOS INSTALABLES.

FILES_EJECUTABLES=$(pwd)/Temp/bin;
FILES_MAESTROS=$(pwd)/Temp/master_files;
FILES_ACEPTADOS=$(pwd)/Temp/files_accepted;
FILES_RECHAZADOS=$(pwd)/Temp/files_rejected;
FILES_VALIDADOS=$(pwd)/Temp/files_validated;
FILES_REPORTES=$(pwd)/Temp/files_report;

#######################################




loguear(){
#touch $DIR_INSTALACION/$DIR_CONF/log.txt
echo "$(date +"%D %X")-$1-$2-$3-$4">>$DIR_INSTALACION/$DIR_CONFIG/Instalacion.log
#loguear WHO WHERE WHAT WHY
#ie 
#loguear "Nahuel" "loguear" "no grabó" "no encontró el directorio"
}

createConfigFile(){
rm $DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "ejecutables-$DIR_INSTALACION/$DIR_EJECUTABLES-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "maestros-$DIR_INSTALACION/$DIR_MAESTROS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "aceptados-$DIR_INSTALACION/$DIR_ACEPTADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "rechazados-$DIR_INSTALACION/$DIR_RECHAZADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "validados-$DIR_INSTALACION/$DIR_VALIDADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "reportes-$DIR_INSTALACION/$DIR_REPORTES-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "log-$DIR_INSTALACION/$DIR_LOG-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.txt

}

makeDirectories(){

mkdir -p $DIR_INSTALACION/$DIR_EJECUTABLES
mkdir -p $DIR_INSTALACION/$DIR_MAESTROS
mkdir -p $DIR_INSTALACION/$DIR_ACEPTADOS
mkdir -p $DIR_INSTALACION/$DIR_RECHAZADOS
mkdir -p $DIR_INSTALACION/$DIR_VALIDADOS
mkdir -p $DIR_INSTALACION/$DIR_REPORTES
mkdir -p $DIR_INSTALACION/$DIR_LOG
echo "Estructura de los directorios de instalacion"
echo "============================================"
#tree -d $DIR_INSTALACION
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
	-f | --fast)		shift
				echo "instalacion default"
				$INSTALACION_RAPIDA=1
				;;
        -r | --repair)	        echo "apreto r"
				repararInstalacion
                                ;;
        -h | --help )       	checkNameDirectories
				exit
                                ;;
				
        * )                     echo ""
				echo "Invalid command. type '-h' or '--help' for instructions"
    esac
    shift
else
setup
fi
#done
}

checkPerl(){

echo "checking perl version.."
sleep 1

V1=$(perl -e 'print substr($^V, 1)')
V2=5.0.0
result=$(echo $(perl -e '($x,$y)=@ARGV; print $x cmp $y' $V1 $V2))

echo "[Perl] installed version $V1"
if [ $result == 1 ]; then
echo "[Perl version] == OK"
loguear "Nahuel" "Perl version" "OK" "[Perl version] == OK"
return 0
else
loguear "Nahuel" "Perl version" "OK" "[Perl version] == ERROR  ($V2 is required)"
echo "[Perl version] == ERROR ($V2 is required)"
return 1
fi
}


######################################################################
directories(){


#echo "tipo de instalacion $INSTALACION_RAPIDA"

#-----------
echo "Ingrese ruta de directorio para los archivos EJECUTABLES"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_EJECUTABLES)"
echo "==================================================================="
read in_ejecutable
READEJECUTABLE=$in_ejecutable
if [ "$READEJECUTABLE" != "y" ]; then
while checkNameDirectories $READEJECUTABLE 
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_ejecutable
READEJECUTABLE=$in_ejecutable
loguear "Nahuel" "directories()" "directorio ejecutar" "directorio elegido por usuario"
done 
DIR_EJECUTABLES=$READEJECUTABLE
fi
loguear "Nahuel" "directories()" "directorio ejecutar" "DEFAULT"

#-----------
echo "Ingrese ruta de directorio para los archivos MAESTROS"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_MAESTROS)"
echo "==================================================================="

read in_maestros
READMAESTRO=$in_maestros
if [ "$READMAESTRO" != "y" ]; then
while checkNameDirectories $READMAESTRO
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_maestros
READMAESTRO=$in_maestros
done
DIR_MAESTROS=$READMAESTRO
fi
loguear "Nahuel" "directories()" "directorio maestros" "DEFAULT"

#--------------------------------
echo "Ingrese ruta de directorio para los archivos ACEPTADOS"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_ACEPTADOS)"
echo "==================================================================="
read in_aceptados
READACEPTADOS=$in_aceptados
if [ "$READACEPTADOS" != "y" ]; then
while checkNameDirectories $READACEPTADOS 
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_aceptados
READACEPTADOS=$in_aceptados
done
DIR_ACEPTADOS=$READACEPTADOS
fi
loguear "Nahuel" "directories()" "directorio aceptados" "DEFAULT"


#----------------------------
echo "Ingrese ruta de directorio para los archivos RECHAZADOS"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_RECHAZADOS)"
echo "==================================================================="
read in_rechazados
READRECHAZADO=$in_rechazados
if [ "$READRECHAZADO" != "y" ]; then
while checkNameDirectories $READRECHAZADO
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_rechazados
READRECHAZADO=$in_rechazados
done
DIR_RECHAZADOS=$READRECHAZADO
fi
loguear "Nahuel" "directories()" "directorio rechazados" "DEFAULT"


#-----------------------
echo "Ingrese ruta de directorio para los archivos VALIDADOS"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_VALIDADOS)"
echo "==================================================================="
read in_validados
READVALIDADOS=$in_validados
if [ "$READVALIDADOS" != "y" ]; then

while checkNameDirectories $READVALIDADOS
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_validados
READVALIDADOS=$in_validados
done
DIR_VALIDADOS=$READVALIDADOS
fi
loguear "Nahuel" "directories()" "directorio validados" "DEFAULT"


#----------------------
echo "Ingrese ruta de directorio para los archivos de REPORTES"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_REPORTES)"
echo "==================================================================="
read in_reportes
READREPORTES=$in_reportes
if [ "$READREPORTES" != "y" ]; then
while checkNameDirectories $READREPORTES
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_reportes
READREPORTES=$in_reportes
done
DIR_REPORTES=$READREPORTES
fi
loguear "Nahuel" "directories()" "directorio reportes" "DEFAULT"

#-------------------------
echo "Ingrese ruta de directorio para los archivos de LOG"
echo "Type 'y' for default option ($DIR_INSTALACION/$DIR_LOG)"
echo "==================================================================="
read in_log
READLOG=$in_log
if [ "$READLOG" != "y" ]; then
while checkNameDirectories $READLOG
do
echo "El nombre elegido ya existe. Por favor ingrese otro nombre de directorio"
read in_log
READLOG=$in_log
done
DIR_LOG=$READLOG
fi
loguear "Nahuel" "directories()" "directorio log" "DEFAULT"
clear
}


##############################################################3

installationDirectory(){

echo "Indique el directorio de instalación o presione 'y' para utilizar"
echo "el directorio actual"
read dir_ins
variable=$(pwd)

if [ $dir_ins != 'y' ];then

DIR_INSTALACION=$variable/$dir_ins/"grupo01"
#mkdir -p $DIR_INSTALACION/$DIR_CONFIG
#loguear "Nahuel" "installationDirectorie()" "Directorio de instalacion" "$DIR_INSTALACION"
else 
DIR_INSTALACION=$variable/"grupo01"
#mkdir -p $DIR_INSTALACION/$DIR_CONFIG
#loguear "Nahuel" "installationDirectorie()" "Directorio de instalacion (actual)" "$DIR_INSTALACION"


fi
}

showDirectories(){

echo "Directorios de instalacion"
echo "=========================="

echo "$DIR_INSTALACION/$DIR_EJECUTABLES"
echo "$DIR_INSTALACION/$DIR_MAESTROS"
echo "$DIR_INSTALACION/$DIR_ACEPTADOS"
echo "$DIR_INSTALACION/$DIR_RECHAZADOS"
echo "$DIR_INSTALACION/$DIR_VALIDADOS"
echo "$DIR_INSTALACION/$DIR_REPORTES"
echo "$DIR_INSTALACION/$DIR_LOG"
echo "$DIR_INSTALACION/$DIR_CONFIG"


}

repararInstalacion(){
echo "reparacion"
}

copyingFiles(){
echo "Extrayendo archivos para la instalacion"
echo "======================================="
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
tar -xf temp.tar
echo "copiando archivos"
echo "================="
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
cp -r $FILES_EJECUTABLES/. $DIR_INSTALACION/$DIR_EJECUTABLES/
cp -r $FILES_MAESTROS/. $DIR_INSTALACION/$DIR_MAESTROS/
cp -r $FILES_ACEPTADOS/. $DIR_INSTALACION/$DIR_ACEPTADOS/
cp -r $FILES_RECHAZADOS/. $DIR_INSTALACION/$DIR_RECHAZADOS/
cp -r $FILES_VALIDADOS/. $DIR_INSTALACION/$DIR_VALIDADOS/
cp -r $FILES_REPORTES/. $DIR_INSTALACION/$DIR_REPORTES/
echo "eliminando archivos de instalacion"
echo "=================================="
echo -ne '#####                     (33%)\r'
sleep 1
echo -ne '#############             (66%)\r'
sleep 1
echo -ne '#######################   (100%)\r'
echo -ne '\n'
rm -R Temp
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

installationDirectory

#if tipoDeInstalacion;then 
#echo "Reparar"
#fi 

mkdir -p $DIR_INSTALACION/$DIR_CONFIG

#Inicializo el log 
loguear $USER "INSTALACION" "Inicio de instalacción" "Inicio de log correcto"


##########################################INSTALACION NUEVA.#########################################
 
#chequeando version de perl (mayor a v5 para instalar)
if checkPerl; then
#directories
#makeDirectories

continuar=1
while [ "$continuar" == 1 ]; do
 
directories
#makeDirectories
showDirectories
echo "Confirmar estrutura de directorios (y/n)"
read confirmar

	if [ $confirmar == 'y' ];then	
	let continuar='0'
	makeDirectories
	else
	directories
	showDirectories
	fi
done

createConfigFile
#copiar archivos.
copyingFiles

fi
#######################################################################################################

}

tipoDeInstalacion(){

buscar=$DIR_INSTALACION/$DIR_CONFIG/Instalacion.log
[ -f $buscar ] && return 0 || return 1

}

checkNameDirectories(){

if [ "$1" != "$DIR_EJECUTABLES" -a "$1" != "$DIR_MAESTROS" -a "$1" != "$DIR_ACEPTADOS" -a "$1" != "$DIR_RECHAZADOS" -a "$1" != "$DIR_VALIDADOS" -a "$1" != "$DIR_REPORTES" -a "$1" != "$DIR_LOG" -a "$1" != "$DIR_CONFIG" ];then 
return 1
else 
return 0
fi

}

reinstall(){
#obtenerDirectorios
#copyingFiles
}

#################################################################
##############FUNCIONES DE INSTALACION###########################
commands $1
