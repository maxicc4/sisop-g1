cat $1 | awk -v num="$2" 'BEGIN {FS=";"} $10~ num {print var " La cuenta: " $2   " con Documento de Tarjeta: " $10 " se encuentra en estado: " $3 } '