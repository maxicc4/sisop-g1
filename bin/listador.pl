#!/usr/bin/perl -X

use strict;
use warnings;
use Fcntl qw(:flock);
use Listador_Automatico;
use Listador_Manual;


print "\nIniciando LISTADOR\n";

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
	print "______________________________________________________\n";
    print "$0 - Ya existe otro LISTADOR ejecutando.\n";
    print "Para poder ejecutar $0 debe frenar el demonio\no esperar para poder ejecutar LISTADOR manualmente\n";
    print "______________________________________________________\n";
    exit(1);
}

if ($ARGV[0] eq '-a') {
	Listador_Automatico::automatico();

}elsif ($ARGV[0] eq '-m') {

	Listador_Manual::manual($ARGV[1]);
}else {
	print "El modo de ejecucion $ARGV[0] es invalido\n";
}

__DATA__
