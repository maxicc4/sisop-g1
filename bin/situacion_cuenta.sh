cat $1 | awk -v num="$2" 'BEGIN {FS=";"} $18~ num {print var " La cuenta: " $2   " con Documento de Cuenta: " $18 " se encuentra en estado: " $3 } '

