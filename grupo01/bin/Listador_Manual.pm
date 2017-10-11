package Listador_Manual;
use Listador;


# $directorio_validados=$ENV{'files_validated'};
# $files_reports=$ENV{'files_reports'};
$directorio_validados = '../files_validated/';
$directorio_reportes = '../files_report/';


sub estado_documento_cuenta {
	return ` ./filtro_documento_cuenta_estado.sh "@_[0]" @_[1] `;
}


sub seleccion_filtros {
	@nombre_filtros = ("Filtro por entidad", "Filtro por Fuente", "Filtro por Condición de Distribución", "Filtro por Documento de Cuenta", "Filtro por Documento de Tarjeta");
	print "\nSeleccione uno o varios filtros a aplicar: 
0. Filtro por entidad (una, rango de entidades, todas)
1. Filtro por fuente (una o todas)
2. Filtro por condición de distribución
3. Filtro por documento cuenta
4. Filtro por documento tarjeta";
	
	@substrings;
	foreach $filtro (Listador::valores_input()){
		print "\n" . @nombre_filtros[$filtro] . "\n";
		foreach $input (Listador::valores_input()){
			chomp($input);
			push @substrings, $input;	
		}
	}
	return Listador::filtrar_duplicados(@substrings);
}


sub listado_cuentas {
	print "\nLISTADO CUENTAS:\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO DE CUENTAS:\n\n";
	

	@estados_cuentas = ("ACTIVA","BAJA", "CTX", "JUD");
	foreach $estado (@estados_cuentas) {
		foreach $dir (@directorios){
			@cuentas = ` ./numero_cuenta_por_estado.sh $estado $dir`;
			chomp(@cuentas);
			if (@cuentas) {
				$cuentas = join(',',@cuentas); 
				print " En archivo: $dir Las cuentas en estado: $estado son: $cuentas \n";
				printf REPORTE " En archivo: $dir Las cuentas en estado: $estado son: $cuentas\n";
			}
		}
	}
	print "\nReporte Situacion de Cuentas: $nombre_nuevo_reporte \n";
	close(REPORTE);
	
	@substrings = seleccion_filtros();

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO DE CUENTAS:\n\n";
	
	print "Filtros aplicados: ";	
	$comando = "";
	foreach $sub (@substrings){	
		print $sub;
		$comando = $comando . "grep -e $sub | ";
	}
	$comando = $comando ;
	$cut =  "cut -d ';' -f2";
	foreach $dir (@directorios){
		print $comando . $cut;
		print "En archivo: $dir las cuentas que pasan los filtros son: ";
		print ` cat $dir | $comando $cut `;
	}

	
	print "\nReporte Situacion de Cuentas: $nombre_nuevo_reporte \n";
	close(REPORTE);
	
}
sub listado_tarjetas {
	print "\nLISTADO TARJETAS\n";
}
sub listado_condicion_distribucion {
	print "\nLISTADO CONDICION DE DISTRIBUCION\n";
}
sub listado_situcion_cuenta {
	print "\nLISTADO SITUACION DE CUENTA\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO SITUACION DE CUENTA:\n\n";
	
	print "Ingresar documento de cuenta: ";
	$documento_cuenta = <STDIN>;
	chomp($documento_cuenta);


	foreach $dir (@directorios){
		print "\nEn el archivo: " . $dir ;
		$estado = estado_documento_cuenta($documento_cuenta, $dir);
		chomp($estado);
		print "La cuenta con documento: $documento_cuenta está en situacion: " . $estado;	
		printf REPORTE " En archivo: $dir La situacion de: $documento_cuenta es: $estado";
	}
	print "\nReporte Situacion de Cuenta generado: $nombre_nuevo_reporte \n";
	close(REPORTE);
}

sub listado_situcion_tarjeta {
	print "\nLISTADO SITUACION DE TARJETA\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());
	
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	
	print "Ingresar documento de tarjeta: ";
	$documento_cuenta = <STDIN>;
	chomp($documento_cuenta);

	printf REPORTE "LISTADO SITUACION DE TARJETA:\n\n";

	foreach $dir (@directorios){
		print "En el archivo: " . $dir ;
		$estado = estado_documento_cuenta($documento_cuenta, $dir);
		print "La cuenta con documento de tarjeta: $documento_cuenta está en situacion: " . $estado;	
		printf REPORTE " En archivo: $dir La situacion de: $documento_cuenta es: $estado";
	}
	print "\nReporte Situacion de Tarjeta generado: $nombre_nuevo_reporte \n";
	close(REPORTE);
}

sub seleccion_archivos{
	@directorios = ();
	$opciones = scalar 0;
	print "\nSeleccionar archivos para generar el listado_tarjetas";

	@archivos_validados = Listador::obtener_directorios_archivos($directorio_validados);
    print "\nARCHIVOS VALIDADOS:\n";
    foreach my $archivo (@archivos_validados) {
    	print $opciones .". ". $archivo;
		$opciones +=1;
    }
	print $opciones . ". todos\n\n";
	$opciones +=1;

	@reportes = Listador::obtener_directorios_archivos_que_contengan($directorio_reportes, "plasticos_distribucion_");
	print "REPORTES: \n";
    foreach my $archivo (@reportes) {
		print $opciones .". ". $archivo;
		$opciones +=1;
	}
	print $opciones . ". todos\n\n";
	@input =  Listador::valores_input();

	foreach my $i (@input){
		chomp($i);

		if ($i > $opciones || $i eq "") {
			print "Input inválido, vuelva a ingresar selección\n";
			seleccion_archivos();
		}
		elsif ($i < (scalar @archivos_validados)) {
			push @directorios, $directorio_validados . @archivos_validados[$i];
		}
		elsif ($i == (scalar @archivos_validados)) {
			foreach my $j (@archivos_validados){
				push @directorios, $directorio_validados . $j;		
			}
		}
		elsif ($i < (scalar @archivos_validados + scalar @reportes + 1)){
			push @directorios, $directorio_reportes . @reportes[$i - (scalar @archivos_validados + 1)];
		}
		elsif ($i == $opciones){
			foreach my $j (@reportes){
				push @directorios, $directorio_reportes . $j;
			}
		}
		else{
			print "$i es opcion inválida, ingresar caracteres numericos\n";
			seleccion_archivos();
		}
	}
    return @directorios;
}

sub manual {

	print "MODO MANUAL\n";
	if (@_[1] == '-h') {
		print "Ayuda @_[1]: \n";
		print "__________________________________________________________________________________\n";
		print "Cada listado generado se va a salvar en la carpeta de reportes $directorio_reportes.\n";
		print "__________________________________________________________________________________\n";
	}

	$continue = 1;

	while ($continue) {


		print 
		"Seleccione una opcion de listado a generar:
0. Listados de cuentas: general / cuentas activas / cuentas dadas de baja, ctx, o jud
1. Listados de tarjetas: general / denunciadas / bloqueadas / vencidas
2. Listado de condicion de distribucion
3. Listado de la situacion de una cuenta en particular
4. Listado de la situacion de una tarjeta en particular
\nOpcion elegida: ";

		$opcionListado = <STDIN>;
		chomp($opcionListado);
		
		listado_cuentas() if ($opcionListado == 0);
		listado_tarjetas() if ($opcionListado == 1);
		listado_condicion_distribucion() if ($opcionListado == 2);
		listado_situcion_cuenta() if ($opcionListado == 3);
		listado_situcion_tarjeta() if ($opcionListado == 4);
		
		print "Para continuar 1, para salir 0: ";
		$continue = <STDIN>;
		chomp($continue);

	}
}

1;

