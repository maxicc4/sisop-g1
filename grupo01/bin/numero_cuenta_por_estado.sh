#script aux para listado de cuentas 

# $1 : ACTIVA, BAJA....
# $2 : directorio

 grep -i -e $1 $2 | cut -d';' -f2 

