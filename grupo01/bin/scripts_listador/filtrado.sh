cat $1 | awk 'BEGIN {FS=";"} $23=="003" {print "La cuenta: " $2  " pasó los filtros y tiene CONDICION DE DISTRIBUCION: " $7 } '