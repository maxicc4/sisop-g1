#!/usr/bin/perl -X
package Listador_Manual;
use Listador;


# $directorio_validados=$ENV{'files_validated'};
# $files_reports=$ENV{'files_reports'};
$directorio_validados = '../files_validated/';
$directorio_reportes = '../files_report/';


sub estado_documento_cuenta {
	return ` ./filtro_documento_cuenta_estado.sh "@_[0]" @_[1] `;
}

sub filtros_a_bash{	
	$comando = "cat \$1 | awk '";
	foreach $sub (@_[0]){ 
		$comando = $comando . "/$sub/ && ";
	}
	$comando = substr($comando,0, -3) . "'| cut -d ';' -f@_[1]"  ;
	open (BASH, ">", "filtrado.sh") or die $!;
	printf BASH $comando;
	close(BASH);
}



sub seleccion_filtros {
	@nombre_filtros = ("Filtro por entidad", "Filtro por Fuente", "Filtro por Condición de Distribución", "Filtro por Documento de Cuenta", "Filtro por Documento de Tarjeta");
	print "\nSeleccione uno o varios filtros a aplicar: 
0. Filtro por entidad
1. Filtro por fuente (una o todas)
2. Filtro por condición de distribución
3. Filtro por documento cuenta
4. Filtro por documento tarjeta\n";
	
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

sub filtro_a_bash {
	open (BASH, ">", "filtrado.sh") or die $!;
	printf BASH @_[0];
	close(BASH);
}

sub seleccion_filtros_v1 {
	@nombre_filtros = ("Filtro por entidad", "Filtro por Fuente", "Filtro por Condición de Distribución", "Filtro por Documento de Cuenta", "Filtro por Documento de Tarjeta");
	print "\nSeleccione uno o varios filtros a aplicar: 
0. Filtro por entidad
1. Filtro por fuente (una o todas)
2. Filtro por condición de distribución
3. Filtro por documento cuenta
4. Filtro por documento tarjeta\n";
	$bash_command="cat \$1 | awk 'BEGIN {FS=\";\"} ";
	foreach $num (Listador::valores_input()){
		if ( $num ~~ [0..4] ) {
			print "\nIngrese valor de " . @nombre_filtros[$num] . " por el cual desea filtrar: ";
			$filtro = <STDIN>;
			$filtro = substr $filtro, 0, -1;

			if ($num == 0) {
				$bash_command = $bash_command . "\$22=\"$filtro\" && ";
			}elsif ($num == 1){
				$bash_command = $bash_command . "\$1=\"$filtro\" && ";
			}elsif ($num == 2){
				$bash_command = $bash_command . "\$7=\"$filtro\" && ";
			}elsif ($num == 3){
				$bash_command = $bash_command . "\$18=\"$filtro\" && ";
			}elsif ($num == 4){
				$bash_command = $bash_command . "\$10=\"$filtro\" &&";
			}
		}else{
			print "Input inválido";
			return seleccion_filtros_v1()
		}
	}
	$bash_command = substr $bash_command, 0, -3;

	return $bash_command;
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
	print "\nReporte Listado de Cuentas: $nombre_nuevo_reporte \n";
	close(REPORTE);
	
	@substrings = ();
	@substrings = seleccion_filtros();

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO DE CUENTAS:\n\n";

	filtros_a_bash(@substrings,2);
	foreach $dir (@directorios){
		@cuentas = `./filtrado.sh $dir `;
		chomp(@cuentas);
		if (@cuentas){
			$cuentas = join(',',@cuentas);
			$filtros = join(',',@substrings);
			print "\nEn archivo: $dir - Las cuentas que pasan los filtros: $filtros - Son: $cuentas";
			printf REPORTE " En archivo: $dir Las cuentas que pasaron los filtros: $filtros\n Son: $cuentas\n";
		}
	}
	print "\nReporte LISTADO CUENTAS: $nombre_nuevo_reporte \n";
	close(REPORTE);	
}


sub listado_tarjetas {
	print "\nLISTADO TARJETAS\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());
	#5.denunciada, 6.bloqueada
	
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO DE TARJETAS:\n\n";

	print "Tarjetas Denunciadas:\n";
	foreach $dir (@directorios){
		@tarjetas = `./filtro_tarjetas_denunciadas.sh $dir` ;
		if (@tarjetas){
			print "En $dir las tarjetas DENUNCIADAS son:\n @tarjetas\n";
			printf REPORTE "En $dir las tarjetas DENUNCIADAS son:\n @tarjetas\n";
		}
	}

	print "Tarjetas Bloqueadas:\n";
	foreach $dir (@directorios){
		@tarjetas = `./filtro_tarjetas_bloqueadas.sh $dir` ;
		if (@tarjetas){
			print "En $dir las tarjetas BLOQUEADAS son:\n @tarjetas\n";
			printf REPORTE "En $dir las tarjetas BLOQUEADAS son:\n @tarjetas\n";
		}
	}

	print "Tarjetas General (no bloqueadas, no denunciadas):\n";
	foreach $dir (@directorios){
		@tarjetas = `./filtro_tarjetas_general.sh $dir` ;
		if (@tarjetas){
			print "En $dir las tarjetas GENERAL son:\n @tarjetas\n";
			printf REPORTE "En $dir las tarjetas GENERAL son:\n @tarjetas\n";
		}
	}

	print "\nReporte Listado de tarjetas: $nombre_nuevo_reporte \n";
	close(REPORTE);

}

sub filtro_condicion_distribucion {
	filtros_a_bash(@_[0],2);
}

sub reporte_cuentas_condicion_distribucion {
	
	filtro_condicion_distribucion(@_[0]);
	$condicion = @_[0];
	
	open (REPORTE, ">>", @_[2]) or die $!;

	foreach $dir (@{$_[1]}){
		@cuentas = `./filtrado.sh $dir `;	
		if (@cuentas){
			print "\nEn archivo: $dir - Las cuentas en condicion de distribucion - $condicion Son:\n @cuentas\n";
			printf REPORTE " En archivo: $dir Las cuentas en condicion de distribucion - $condicion Son:\n @cuentas\n";
		}
	}

}

sub listado_condicion_distribucion {
	print "\nLISTADO CONDICION DE DISTRIBUCION\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO CONDICION DE DISTRIBUCIÓN:\n\n";

	reporte_cuentas_condicion_distribucion("DISTRIBUCION ESTANDAR", \@directorios, $nombre_nuevo_reporte);
	reporte_cuentas_condicion_distribucion("NO DISTRIBUIR, la cuenta esta dada de BAJA", \@directorios, $nombre_nuevo_reporte);
	reporte_cuentas_condicion_distribucion("NO DISTRIBUIR, la cuenta es CONTENCIOSA", \@directorios, $nombre_nuevo_reporte);
	reporte_cuentas_condicion_distribucion("NO DISTRIBUIR, la cuenta es JUDICIAL", \@directorios, $nombre_nuevo_reporte);
	reporte_cuentas_condicion_distribucion("NO DISTRIBUIR, la tarjeta fue BLOQUEADA", \@directorios, $nombre_nuevo_reporte);
	reporte_cuentas_condicion_distribucion("NO DISTRIBUIR, tarjeta VENCIDA", \@directorios, $nombre_nuevo_reporte);
	reporte_cuentas_condicion_distribucion("DISTRIBUCION URGENTE", \@directorios, $nombre_nuevo_reporte);

	
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO DE CUENTAS:\n\n";

	#cat $1 | awk 'BEGIN {FS=";"} $6=="1" {print "Nro de Tarjeta: ("$12 "-" $13 "-"$14 "-"$15 ")"}'
	$bash_command = seleccion_filtros_v1() . "{print \"La cuenta: \" \$2  \" pasó los filtros y tiene CONDICION DE DISTRIBUCION: \" \$7 } '";
	filtro_a_bash($bash_command);
	foreach $dir (@directorios){
		@cuentas = `./filtrado.sh $dir `;	
		if (@cuentas){
			print @cuentas;
			printf REPORTE @cuentas;
		}
	}


	print "\nReporte listado condicion de distribucion: $nombre_nuevo_reporte \n";
	close(REPORTE);	
}


sub listado_situcion {
	print "\nLISTADO SITUACION DE @_[0]\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());
	
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	
	print "Ingresar documento de @_[0]: ";
	$documento_cuenta = <STDIN>;
	chomp($documento_cuenta);

	printf REPORTE "LISTADO SITUACION DE @_[0]:\n\n";

	foreach $dir (@directorios){
		$estado = estado_documento_cuenta($documento_cuenta, $dir);
		if ($estado){
			print "En el archivo: " . $dir ;
			print "La cuenta con documento de @_[0]: $documento_cuenta está en situacion: " . $estado;	
			printf REPORTE " En archivo: $dir La situacion de: $documento_cuenta es: $estado";
		}else{
			print "Cuenta $documento_cuenta no encontrada\n";
			printf REPORTE " En archivo: $dir La cuenta: $documento_cuenta no figura";
		}
	}
	print "\nReporte Situacion de @_[0] generado: $nombre_nuevo_reporte \n";
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
		listado_situcion("CUENTA") if ($opcionListado == 3);
		listado_situcion("TARJETA") if ($opcionListado == 4);
		
		print "\nPara continuar 1, para salir 0: \n";
		$continue = <STDIN>;
		chomp($continue);

	}
}

1;

