#script aux para listado de cuentas 

# $1 : ACTIVA, BAJA....
# $2 : directorio

 grep -i -e $1 $2 | sed -e "s/.*\txt;\(.*\);$1.*/\1/"

