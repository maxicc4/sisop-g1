package Listador_Automatico;
use Listador;



$directorio_validados=$ENV{'VALIDADOS'}."/";
$directorio_reportes=$ENV{'REPORTES'}."/";

sub automatico {
	print "MODO AUTOMATICO\n";

    @archivos_validados = Listador::obtener_directorios_archivos($directorio_validados);

    $ultimo_archivo_validado = $directorio_validados . @archivos_validados[0];

    $nombre_nuevo_reporte = $nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("plasticos_distribucion");
    
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;

	open (ULTIMO_ARCHIVO_VALIDADO, $ultimo_archivo_validado) or die $!;
	
	#Defino condicion de distribucion
	while (<ULTIMO_ARCHIVO_VALIDADO>)
	{	
		chomp($_);
		@reg=split(";",$_);

		my $hoy = Time::Piece->new;
		my $fecha_hasta = Time::Piece->strptime(@reg[16], '%d/%m/%Y');

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
		elsif ($fecha_hasta <= $hoy){
			@reg[6] = "NO DISTRIBUIR, tarjeta VENCIDA";	
		}
		elsif (($hoy + ONE_DAY*10) >= $fecha_hasta){
			@reg[6] = "NO DISTRIBUIR, VENTANA de distribucion insuficiente";
		}
		elsif (@reg[4] == 1){
			@reg[6] = "DISTRIBUCION URGENTE";
		}
		else{
			@reg[6] = "DISTRIBUCION ESTANDAR";
		}

		@reg[7] = $hoy->strftime('%d/%m/%Y');;
		@reg[8] = 'LISTADOR';
		printf REPORTE join( ';', @reg );
		printf REPORTE "\n";
	
	}
    print $nombre_nuevo_reporte .  " fue creado.\n";

	close(ULTIMO_ARCHIVO_VALIDADO);
	close(REPORTE);

    exit 0;

}

1;
