cat $1 | awk 'BEGIN {FS=";"} {print "CUENTA: " $2  " - ESTADO: " $3 } '