DirActual=$DIR_INSTALACION
#Guardo las rutas de los directorios:
acept=$ACEPTADOS
recha=$RECHAZADOS
valid=$VALIDADOS
log=$LOGS
proc="$DirActual/procesados"
dupli="$recha/dup"
archivolog="$log/ValidadorLog.log"
archivoSecEmitidos="$valid/secuencia/secuenciaArchivosEmitidos.txt"
archivoSecDuplicados="$dupli/secuenciaArchivosRechazadosDuplicados.txt"
archivoRechazados="$recha/Plasticos_rechazados.txt"
archivoCumae="$DirActual/maestros/cumae"
archivoBamae="$DirActual/maestros/bamae"
archivoTarjetas="$DirActual/maestros/tx_tarjetas"
#validar que este el directorio de aceptados
archivosAceptados=$(ls $acept)

function escribirLog(){
	fecha=`date +%Y%m%d" "%H:%M:%S`
	usuario=$USER
	tipoMensaje=$1
	mensaje=$2
	
	echo "$fecha-$usuario-Validador-$tipoMensaje-$mensaje" >> $archivolog	
		
	
}


function existeOcrearDirectorio(){
#Chequea si existe el directorio y sino lo crea

         if ! [ -d "$1" ]
         then
                 mkdir "$1"
         fi
}

function validarFecha(){
	#valido fechas
	#Fecha con formato dia[01..31], mes[01,03,05,07,08,10,12], ano[0000..9999]
    	DATE_1="((([123][0]|[012][1-9])|3[1])/(0[13578]|1[02])/[0-9]{4})"
    	#Fecha con formato dia[01..30], mes[04,06,09,11], ano[0000..9999]
    	DATE_2="(([123][0]|[012][1-9])/(0[469]|11)/[0-9]{4})"

   	#Fecha con formato dia[01..28], mes[02], ano[0000..9999]
   	DATE_3="(([12][0]|[01][1-9]|2[1-8])/02/[0-9]{4})"

  	#Fecha con formato dia[29], mes[02], ano[0000..9999]
   	DATE_4="(29/02/[0-9]{3})"

	fechaValidada=$(echo "$1" | egrep "$DATE_1|$DATE_2|$DATE_3|$DATE_4")

	if [ "$fechaValidada" != "$1" ]; then
		return 0
   	fi

	ano=$(echo $1 | cut -d "/" -f3)
	mes=$(echo $1 | cut -d "/" -f2)
	dia=$(echo $1 | cut -d "/" -f1)	
	if [[ $mes == "02" && $dia == "29" ]]; then
		if [ $(($ano % 4)) -eq 0 ]; then
    			if [ $(($ano % 100)) -eq 0 ]; then
				if [ $(($ano % 400)) -ne 0 ]; then
					return 0

				fi

			fi			
		else	
			return 0
		fi		
	fi
	return 1			
 
}

function primerafechaMenorQueSegunda(){
#Devuelve 0 (false) si la primera fecha pasada por parametro es mayor que la segunda o 1 en caso contrario
#terminar 
	
	anoUna=$(echo $1 | cut -d "/" -f3)
	mesUna=$(echo $1 | cut -d "/" -f2)
	diaUna=$(echo $1 | cut -d "/" -f1)

	anoDos=$(echo $2 | cut -d "/" -f3)
	mesDos=$(echo $2 | cut -d "/" -f2)
	diaDos=$(echo $2 | cut -d "/" -f1)


	if [ $anoUna -gt $anoDos ]; then
		return 0
	fi
	if [ $anoUna -eq $anoDos ]; then
		if [ $mesUna -gt $mesDos ]; then
			return 0
		fi
		if [ $mesUna -eq $mesDos ]; then
			if [ $diaUna -gt $diaDos ]; then
				return 0
			fi
		fi
	fi
	return 1
}

function agregarCamposCumaeRegistroSalida(){
#Busca el numero de cuenta en el archivo Cumae
	
	while read lineaCumae
	do 	
		
		cuentaCumae=$( echo "$lineaCumae" | cut -d ';' -f2)
		if [ "$cuentaCumae" == $regCuenta ]; then
			docCuentaCumae=$( echo "$lineaCumae" | cut -d ';' -f3)
			denominacionCuentaCumae=$( echo "$lineaCumae" | cut -d ";" -f4)
			fechaAltaCumae=$( echo "$lineaCumae" | cut -d ";" -f5)
			categoriaCumae=$( echo "$lineaCumae" | cut -d ";" -f6)
			limiteCumae=$( echo "$lineaCumae" | cut -d ";" -f7)
			estadoCumae=$( echo "$lineaCumae" | cut -d ";" -f8)
			registroSalida="$estadoCumae;$registroSalida;$docCuentaCumae;$denominacionCuentaCumae;$fechaAltaCumae;$categoriaCumae;$limiteCumae"
			return 1
		fi
	done < $archivoCumae
	
	return 0
	
}

function agregarFlagsTarjetaVieja(){
#Busca la tarjeta en el archivo tarjetas y si hay alguna ya entregada agregar los flags de Denunciada/ Bloqueada al registro de salida
	lineasArchivoTarjetas=$(cut -d ';' -f 2,8,11,12,13,14 $archivoTarjetas)
	mayorFecha="01/01/0000"
	regTarjetaVieja="0"
	regDenunciada="0"
	regBloqueada="0"
	for linea in $lineasArchivoTarjetas
	do
		cuenta=$( echo $linea | cut -d ";" -f1)
		t4Tarjetas=$(echo $linea | cut -d ";" -f2)
		Denunciada=$(echo $linea | cut -d ";" -f3)
		Bloqueada=$(echo $linea | cut -d ";" -f4)
		estadoTarjeta=$(echo $linea | cut -d ";" -f5)
		fechaEstado=$(echo $linea | cut -d ";" -f6)
		if [[ "$cuenta" == $regCuenta && "$t4Tarjetas" == $regT4 && "$estadoTarjeta" == "Entregada" ]];then
			regTarjetaVieja="1"
			primerafechaMenorQueSegunda $fechaEstado $mayorFecha
			if [ "$?" == "0" ]; then
				mayorFecha=$fechaEstado
				regDenunciada=$Denunciada
				regBloqueada=$Bloqueada
			fi
		fi
	done
	registroSalida="$registroSalida$regTarjetaVieja;$regDenunciada;$regBloqueada"
}

function agregarAliasEntidadBancaria(){
	while read lineaBamae
	alias=""
	do
		entidadBamae=$( echo "$lineaBamae" | cut -d ';' -f1)
		if [ "$entidadBamae" == $entidadBancaria ]; then
			alias=$( echo "$lineaBamae" | cut -d ';' -f2)
			registroSalida="$registroSalida;$alias"
			return 1
		fi

	done < $archivoBamae
	registroSalida="$registroSalida;$alias"
	return 0
}

function buscarNroCuenta(){
#Busca el numero de cuenta en el archivo Cumae

	for nrocuenta in $cuentas
	do 
		if [ "$nrocuenta" == "$1" ]; then
			return 1
		fi
	done 
	
	return 0
	
}

function validarRegistro(){
#Chequea las validaciones del registro dado

	regCuenta=$(echo "$1" | cut -d ';' -f 1 )
	regDNI=$(echo "$1" |cut -d ';' -f 2 )
	regDenominacion=$(echo "$1" |cut -d ';' -f 3)
	regT1=$(echo "$1" |cut -d ';' -f 4 )
	regT2=$(echo "$1" |cut -d ';' -f 5 )
	regT3=$(echo "$1" |cut -d ';' -f 6 )
	regT4=$(echo "$1" |cut -d ';' -f 7 )
	regFechaDesde=$(echo "$1" |cut -d ';' -f 8 )
	regFechaHasta=$(echo "$1" |cut -d ';' -f 9 )
	
	#valido Cuenta	
	buscarNroCuenta "$regCuenta"
	if [ "$?" == "0" ]; then
		motivo="No existe el numero de cuenta en el maestro de cuentas Cumae"
		return 0
	fi
	#valido DNI y Denominacion
	cantDeCaractDNI=$(echo $regDNI | wc -c)
	cantDeCaractDenominacion=$(echo $regDenominacion | wc -c)
	if [ "$cantDeCaractDNI" == "1" ]; then	
		motivo="Documento de tarjeta no informado"	
		return 0
	fi
	if [ "$cantDeCaractDenomiacion" == "1" ]; then
		motivo="Denominacion de la tarjea no informada"	
		return 0
	fi
	#valido numeros de tarjeta
	nroTarjeta="$regT1 $regT2 $regT3 $regT4"
	for regT in $nroTarjeta
	do
		numero=$(echo "$regT" | grep -e '^[0-9]*$')
		if [ "$regT" != "$numero" ]; then
			motivo="Numeros de tarjena no numericos"
			return 0
		fi		
		cantNros=$(echo $regT | wc -c)
		if [ "$cantNros" != "5" ]; then
			motivo="Cantidad de digitos del numero de tarjeta incorrecto"
			return 0
		fi	
	done
	
  	#valido formato fechas
	
	validarFecha $regFechaDesde
	if [ $? -eq 0 ]; then
		motivo="Formato de Fecha Desde incorrecta"
		return 0
	fi
	validarFecha $regFechaHasta
	if [ $? -eq 0 ]; then
		motivo="Formato de Fecha Hasta incorrecta"
		return 0
	fi
	
	#valido que la fecha Desde sea menor o igual que la Hasta
	
	
	primerafechaMenorQueSegunda "$regFechaDesde" "$regFechaHasta"
	if [ $? -eq 0 ]; then
		motivo="Fecha Hasta menor que Fecha Desde"
		return 0
	fi
	
	
	return 1

}
	
numeroDeSecuencia(){
#Guarda en la variable "nroSec" el siguiente numero de secuencia del archivo pasado por parametro y lo actualiza
	if [ -f "$1" ]; then
		ultimoNroSec=$(cut -d '#' -f2 "$1")	
		nroSec=$(($ultimoNroSec+1))
		sed s/"$ultimoNroSec"/"$nroSec"/ "$1" > "$1"	
	
	else
		nroSec="1"
		echo "#$nroSec" >> "$1"
	fi
	
}	

#creo el directorio de secuencia dentro de la carpeta de validados
existeOcrearDirectorio "$valid/secuencia"
cuentas=$(cut -d ';' -f 2 $archivoCumae)

archEmitidosCreado=0

for archivo in $archivosAceptados
do
	#Me fijo si existe el directorio de "Procesados", si no existe lo creo
        existeOcrearDirectorio $proc
	#Me fijo si el archivo esta en el directorio de "Procesados
        if [ -f "$proc/$archivo" ]; then
		#ARCHIVO YA PROCESADO
		#Movemos el archivo a la carpeta de rechazados
                #chequeo que no haya un archivo de igual nombre en la carpeta de rechazados
                if [ -f "$recha/$archivo" ]; then
			#NOMBRE DE ARCHIVO EXISTE EN RECHAZADOS
                        #Me fijo si existe el directorio de "dup", si no existe lo creo
                        existeOcrearDirectorio $dupli
			#Le agrego el numero de secuencia al nombre del archivo y lo muevo a /dup
			nroSec="1"
			numeroDeSecuencia $archivoSecDuplicados
			mv "$acept/$archivo" "$dupli/$archivo($nroSec)"
                      
                else
			#NOMBRE DE ARCHIVO NO EXISTE EN RECHAZADOS
			#Muevo el archivo al directorio de Rechazados                       
			mv "$acept/$archivo" $recha
                fi
		#Escribimos log
		mensajeLog="Archivo rechazado <$archivo> Archivo ya procesado"
		escribirLog "ERROR" "$mensajeLog"
		
        else
		#ARCHIVO A PROCESAR
		#Proceso todos los registros del archivo
		numReg=0
		numRegInvalido=0
		numRegValido=0
		while read registro
		do
			numReg=$(($numReg+1))
			validarRegistro "$registro"
			if [ $? -eq 0 ]; then
				#REGISTRO INVALIDO
				numRegInvalido=$(($numRegInvalido+1))
				#Me fijo que el archivo de Plasticos Rechazados este creado, si no lo creo
				if [ ! -f $archivoRechazados ]; then
					echo "FUENTE;MOTIVO DEL RECHAZO;NRO CUENTA;DOCUMENTO TARJETA;DENOMINACION DE TARJETA;T1;T2;T3;T4;FECHA DESDE;FECHA HASTA" >> $archivoRechazados
				fi
				#Creo registro de salida
				registroSalida="$archivo;$motivo;$registro"
				#Agrego el registro al archivo de Plasticos Rechazados
				echo $registroSalida >> $archivoRechazados
				#Escribimos log
				mensajeLog="Archivo procesado <$archivo> registro N$numReg: Error! $motivo"
				escribirLog "ERROR" "$mensajeLog"

			else
				#REGISTRO VALIDO
				numRegValido=$(($numRegValido+1))
				#Me fijo que el archivo de Plasticos Emitidos este creado, si no lo creo
				if [ $archEmitidosCreado -eq 0 ];then
					nroSec="1"
					numeroDeSecuencia $archivoSecEmitidos
					archivoEmitidos="Plasticos_emitidos_$nroSec.txt"
					archEmitidosCreado=1
				fi

				#Creo registro de salida
				regCuenta=$(echo "$registro" | cut -d ';' -f1)
				regDNI=$(echo "$registro" |cut -d ';' -f2)
				regDenominacion=$(echo "$registro" |cut -d ';' -f3)
				regT1=$(echo "$registro" |cut -d ';' -f4)
				regT2=$(echo "$registro" |cut -d ';' -f5)
				regT3=$(echo "$registro" |cut -d ';' -f6)
				regT4=$(echo "$registro" |cut -d ';' -f7)
				regFechaDesde=$(echo "$registro" |cut -d ';' -f8)
				regFechaHasta=$(echo "$registro" |cut -d ';' -f9)
				
				
				registroSalida=""
				agregarFlagsTarjetaVieja 
				registroSalida="$registroSalida;;;VALIDADOR;$regDNI;$regDenominacion;$regT1;$regT2;$regT3;$regT4;$regFechaDesde;$regFechaHasta"
				agregarCamposCumaeRegistroSalida
				registroSalida="$archivo;$regCuenta;$registroSalida"

				entidadBancaria=$( echo "$archivo" |cut -d '_' -f1)
				registroSalida="$registroSalida;$entidadBancaria"
				agregarAliasEntidadBancaria

				#Agrego registro de salida al archivo Plasticos emitidos
				echo $registroSalida >> "$valid/$archivoEmitidos"
				#Escribimos log
				mensajeLog="Archivo procesado <$archivo> registro N$numReg: Aceptado"
				escribirLog "INF" "$mensajeLog"
				
							
			fi
					
		done < $acept/$archivo
		#Muevo el archivo al directorio de Procesados
               mv "$acept/$archivo" $proc

		#Escribimos log
		mensajeLog="Archivo procesado <$archivo> Total de registros leidos: $numReg"
		escribirLog "INF" "$mensajeLog"
		mensajeLog="Archivo procesado <$archivo> Total de registros aceptados: $numRegValido"
		escribirLog "INF" "$mensajeLog"
		mensajeLog="Archivo procesado <$archivo> Total de registros rechazados: $numRegInvalido"
		escribirLog "INF" "$mensajeLog"
	
        fi

done

if [ $archEmitidosCreado -gt 0 ];then
	#Escribimos log
	mensajeLog="Invocar a LISTADOR"
	escribirLog "INF" "$mensajeLog"	
	#perl $DirActual/listador.pl -a
fi




