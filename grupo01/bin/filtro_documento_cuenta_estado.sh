#script devuelve las lineas del archivo que contengan el documento de una cuenta dado 

# $1 : documento_cuenta
# $2 : directorio

 grep -i -e $1 $2 | cut -d';' -f3 

