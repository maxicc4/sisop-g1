# listadorAutomatico.pm
package Listador;

# $files_processed=$ENV{'file_proccessed'};


sub automatico {
	print "INICIALIZADO LISTADOR MODO AUTOMATICO\n";
	 
	my $dir = '../files_validated/';

    opendir(DIR, $dir) or die $!;

    my @files = readdir(DIR);

    $lastProccessed = $dir . @files[-1];
    
    closedir(DIR);


	if (open(my $fh, '<:encoding(UTF-8)', $lastProccessed)) {
	  while (my $row = <$fh>) {
	    chomp $row;
	    print "$row\n";
	  }
	} else {
	  warn "Could not open file '$filename' $!";
}

    exit 0;



}

sub manual {

	print "INICIALIZADO LISTADOR MODO MANUAL\n";
	print "@_[0]\n";
	if (@_[1] eq '-h') {
		print "Modo ayuda @_[1] \n";
	}

	print "Seleccion de input: \n
	- un archivo especifico de plasticos_emitidos \n
	- un archivo de plasticos_distribucion \n
	- varios archivos especificos (de emitidos, de distribucion o de ambos)\n
	- todos los archivos plasticos_emitidos (default)\n
	- todos los archivos plasticos_distribucion\n";
	

}

1;