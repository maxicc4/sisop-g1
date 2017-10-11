#script devuelve el estado del numero de cuenta $1 pasado en el archivo $2
# $1 : documento_cuenta
# $2 : directorio

 grep -i -e $1 $2 | cut -d';' -f3 

