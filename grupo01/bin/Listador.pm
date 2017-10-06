# listadorAutomatico.pm
package Listador;
use Time::Piece;
use Time::Seconds;


# $files_validated=$ENV{'file_validated'};
# $files_reports=$ENV{'files_reports'};
$files_validated = '../files_validated/';
$files_report = '../files_report/';


sub automatico {
	print "INICIALIZADO LISTADOR MODO AUTOMATICO\n";
	 
	#Busco nombre del ultimo archivo validado en files_validated
    opendir(FILES_VALIDATED, $files_validated) or die $!;

    my @files = readdir(FILES_VALIDATED);

    $last_validated_file_dir = $files_validated . @files[-1];

    closedir(FILES_VALIDATED);

    #Defino nombre del nuevo reporte
    opendir(REPORTS, $files_report) or die $!;
	@files =  readdir(REPORTS);
	$nro_seq = @files -2; #Definido por la cantidad de reportes realizados
	closedir(REPORTS);


    # Creo archivo del nuevo reporte
    $report_dir = $files_report . "plasticos_distribucion_" . $nro_seq;
   
	open (REPORT_FILE, ">>", $report_dir) or die $!;


	open (LAST_VALIDATED_FILE, $last_validated_file_dir) or die "ERROR: No se pudo abrir el archivo de contratos\n";
	
	#Defino condicion de distribucion
	while (<LAST_VALIDATED_FILE>)
	{	
		chomp($_);
		@reg=split(";",$_);


		my $today = Time::Piece->new;
		my $to_date = Time::Piece->strptime(@reg[16], '%d/%m/%Y');

		if (@reg[2] eq 'BAJA') {
			@reg[6] = "NO DISTRIBUIR, la cuenta esta dada de BAJA";
		}
		elsif (@reg[2] eq 'CTX') {
			@reg[6] = "NO DISTRIBUIR, la cuenta es CONTENCIOSA";
		}
		elsif (@reg[2] eq 'JUD') {
			@reg[6] = "NO DISTRIBUIR, la cuenta es JUDICIAL";
		}
		elsif (@reg[5] == 1){
			@reg[6] = "NO DISTRIBUIR, la tarjeta fue BLOQUEADA";	
		}
		elsif ($to_date <= $today){
			@reg[6] = "NO DISTRIBUIR, tarjeta VENCIDA";	
		}
		elsif (($today + ONE_DAY*10) >= $to_date){
			@reg[6] = "NO DISTRIBUIR, VENTANA de distribucion insuficiente";
		}
		elsif (@reg[4] == 1){
			@reg[6] = "DISTRIBUCION URGENTE";
		}
		else{
			@reg[6] = "DISTRIBUCION ESTANDAR";
		}

		@reg[7] = $today->strftime('%d/%m/%Y');;
		@reg[8] = 'LISTADOR';
		printf REPORT_FILE join( ';', @reg );
		printf REPORT_FILE "\n";
	
	}


	close(LAST_VALIDATED_FILE);
	close(REPORT_FILE);

    exit 0;

}

sub manual {

	print "INICIALIZADO LISTADOR MODO MANUAL\n";
	print "@_[0]\n";
	if (@_[1] eq '-h') {
		print "Modo ayuda @_[1] \n";
	}

	print "Ingrese archivo/s de input: \n
	Puede ingresar: \n
	- un archivo especifico de plasticos_emitidos \n
	- un archivo de plasticos_distribucion \n
	- varios archivos especificos (de emitidos, de distribucion o de ambos)\n
	- todos los archivos plasticos_emitidos (default)\n
	- todos los archivos plasticos_distribucion\n";
	

}

1;