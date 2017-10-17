# script que devuelva 0 si el sistema esta inicializado correctamente
# 0 si hay errores en la inicializacion
# Este se usará por el PREPARADOR, DEMONIO, VERIFICADOR Y LISTADOR

extrayendoMaestros(){

#tar -xf maestros.tar -C /$DIR_INSTALACION/maestros
tar -xf maestros.tar -C /$1

}

extrayendoBinFiles(){
tar -xf bin.tar -C /$1
#cp -r bin/. $1/
#cp -r bin/. $DIR_INSTALACION/$DIR_EJECUTABLES/

}

status_Installation(){
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
echo "no existe carpeta ejecutable"
return $estado_sistema
fi

if ! [ -d $maestro ]; then
estado_sistema=1
echo "no existe carpeta maestro"
return $estado_sistema
fi

if ! [ -d $rechazado ]; then
estado_sistema=1
echo "no existe carpeta rechazado"
return $estado_sistema
fi

if ! [ -d $validado ]; then
estado_sistema=1
echo "no existe carpeta validado"
return $estado_sistema
fi

if ! [ -d $reportes ]; then
estado_sistema=1
echo "no existe carpeta reportes"
return $estado_sistema
fi

if ! [ -d $acept ]; then
estado_sistema=1
echo "no existe carpeta aceptados"
return $estado_sistema
fi

if ! [ -d $log ]; then
estado_sistema=1
echo "no existe carpeta log"
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


if status_Installation; then
echo "estan todos los archivos necesarios para la ejecucion"
else 
echo "faltan archivos. Reparar sistema . ( se llama a install.sh -r )"
fi