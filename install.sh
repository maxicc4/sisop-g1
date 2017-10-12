
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
export DIR_INSTALACION=$variable/"grupo01"

#########################





loguear(){

echo "$(date +"%D %X")-$1-$2-$3-$4">>$DIR_INSTALACION/$DIR_CONFIG/Instalacion.log
#loguear WHO WHERE WHAT WHY
#ie 
#loguear "Nahuel" "loguear" "no grabó" "no encontró el directorio"
}

createConfigFile(){
#rm $DIR_INSTALACION/$DIR_CONFIG/config.txt
echo "ejecutables-$DIR_INSTALACION/$DIR_EJECUTABLES-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
echo "maestros-$DIR_INSTALACION/$DIR_MAESTROS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
echo "aceptados-$DIR_INSTALACION/$DIR_ACEPTADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
echo "rechazados-$DIR_INSTALACION/$DIR_RECHAZADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
echo "validados-$DIR_INSTALACION/$DIR_VALIDADOS-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
echo "reportes-$DIR_INSTALACION/$DIR_REPORTES-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config
echo "log-$DIR_INSTALACION/$DIR_LOG-$USER-$(date +"%D %X")">>$DIR_INSTALACION/$DIR_CONFIG/config.config

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
        -r | --repair)	        echo "Reparacion de sistema"
				reinstall
                                ;;
        -h | --help )       	checkNameDirectories
				exit
                                ;;
				
        * )                     echo ""
				echo "Invalid command. type '-h' or '--help' for instructions"
    esac
    shift
else
checkPreviousInstallation
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
#loguear "Nahuel" "Perl version" "OK" "[Perl version] == OK"
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

extrayendoMaestros(){

tar -xf maestros.tar -C $DIR_INSTALACION
tar -xf bin.tar

}

existeFile(){

[ -f $1 ] && return 0 || return 1

}


checkPreviousInstallation(){
config_file=$DIR_INSTALACION/dirconf/config.txt
if existeFile $config_file;then
echo "ya se encuentra una version instalada del sistema. Desea repararla?"
repair
else 
setup
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



#if tipoDeInstalacion;then 
#echo "Se encuentra una version instalada del sistema. Desea reparar el sistema? (y/n)"
#read opcion
#if [ "$opcion" == "y" ]; then
#reinstall
#fi

#else


#Inicializo el log 
loguear $USER "INSTALACION" "Inicio de instalacción" "Inicio de log correcto"


##########################################INSTALACION NUEVA.#########################################
 
#chequeando version de perl (mayor a v5 para instalar)
if checkPerl; then

continuar=1
while [ "$continuar" == 1 ]; do
 
directories
showDirectories
echo "Confirmar estrutura de directorios (y/n)"
read confirmar

	if [ $confirmar == 'y' ];then	
	continuar=0
	makeDirectories
	extrayendoMaestros
	fi
done
createConfigFile
fi
#fi
}

#devuelve 0 si la carpeta existe
existeCarpeta(){

[ -d $1 ] && return 1 || return 0

}

checkNameDirectories(){

if [ "$1" != "$DIR_EJECUTABLES" -a "$1" != "$DIR_MAESTROS" -a "$1" != "$DIR_ACEPTADOS" -a "$1" != "$DIR_RECHAZADOS" -a "$1" != "$DIR_VALIDADOS" -a "$1" != "$DIR_REPORTES" -a "$1" != "$DIR_LOG" -a "$1" != "$DIR_CONFIG" ];then 
return 1
else 
return 0
fi

}


repair(){
archivoConf=$DIR_INSTALACION/dirconf/config.txt
while read lineaConf
do
	directorio=$(echo "$lineaConf" | cut -d '-' -f1)
	case "$directorio" in
		ejecutables)
                        ejecutable=$(echo "$lineaConf" | cut -d '-' -f2)
			echo "$ejecutable";;
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

#checkMasterFiles

if existeCarpeta $ejecutable; then
mkdir $ejecutable
echo "$ejecutable"
fi

if existeCarpeta $maestro; then
mkdir $maestro
echo "$maestro"
fi

if existeCarpeta $rechazado; then
echo "$rechazado"
mkdir $rechazado
fi

if existeCarpeta $validado; then
mkdir $validado
fi

if existeCarpeta $reportes; then
mkdir $reportes
fi

if existeCarpeta $acept; then
mkdir $acept
fi

if existeCarpeta $log; then
mkdir $log
fi

}

reinstall(){
checkFiles
}

#################################################################
##############FUNCIONES DE INSTALACION###########################
commands $1
chmod +x $DIR_INSTALACION/bin/*.sh
#checkFiles
