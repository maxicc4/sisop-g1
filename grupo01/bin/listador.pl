#!/usr/bin/perl


#EJECUCIÓN VIA VALIDADOR


#EJECUCION VIA MANUAL: •	Ya existe otro LISTADOR ejecutando!! 
#--> impedir que el de ejecución manual inicie el proceso!! 
#mostrar un mensaje de error al usuario, indicar que debe frenar el demonio 
#o esperar para poder ejecutar el Listador manualmente.

use strict;
use warnings;
use Fcntl qw(:flock);
print "Iniciando el LISTADOR\n";

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
    print "$0 -- Ya existe otro LISTADOR ejecutando.\n";
    print "Para poder ejecutar $0 debe fremar el demonio\no esperar para poder ejecutar el LISTADOR manualmente\n";
    exit(1);
}


print "sleeping\n";
sleep(30);
print "end of program\n";

__DATA__

#en la modalidad manual, debe contar con una opción de ayuda del comando que 
#muestre las opciones disponibles y los diferentes parámetros para su uso. 