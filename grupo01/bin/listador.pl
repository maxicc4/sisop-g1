#!/usr/bin/perl -X



use strict;
use warnings;
use Fcntl qw(:flock);
use Listador;

print "\nIniciando LISTADOR\n\n";

unless (flock(DATA, LOCK_EX|LOCK_NB)) {
	print "______________________________________________________\n";
    print "$0 - Ya existe otro LISTADOR ejecutando.\n";
    print "Para poder ejecutar $0 debe frenar el demonio\no esperar para poder ejecutar LISTADOR manualmente\n";
    print "______________________________________________________\n";
    exit(1);
}

if ($ARGV[0] eq '-a') {
	Listador::automatico();

}elsif ($ARGV[0] eq '-m') {

	Listador::manual($ARGV[1]);
}else {
	print "El modo de ejecucion $ARGV[0] es invalido\n";
}

print "sleeping\n";
sleep(30);
print "end of program\n";

__DATA__
