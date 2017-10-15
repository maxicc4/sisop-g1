#!/usr/bin/perl -X
package Listador_Manual;
use Listador;


$directorio_validados=$ENV{'VALIDADOS'};
$directorio_reportes=$ENV{'REPORTES'};

sub filtro_a_bash {
	open (BASH, ">", "scripts_listador/filtrado.sh") or die $!;
	printf BASH @_[0];
	close(BASH);
}

sub seleccion_filtros_v1 {
	@nombre_filtros = ("Filtro por entidad", "Filtro por Fuente", "Filtro por Condición de Distribución", "Filtro por Documento de Cuenta", "Filtro por Documento de Tarjeta");
	print "\nSeleccione uno o varios filtros a aplicar: 
0. Filtro por entidad
1. Filtro por fuente
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
				$bash_command = $bash_command . "\$23==\"$filtro\" && ";
			}elsif ($num == 1){
				$bash_command = $bash_command . "\$1==\"$filtro\" && ";
			}elsif ($num == 2){
				$bash_command = $bash_command . "\$7==\"$filtro\" && ";
			}elsif ($num == 3){
				$bash_command = $bash_command . "\$18~\"$filtro\" && ";
			}elsif ($num == 4){
				$bash_command = $bash_command . "\$10~\"$filtro\" &&";
			}
		}else{
			print "Input inválido";
			return seleccion_filtros_v1()
		}
	}
	$bash_command = substr $bash_command, 0, -3;

	return $bash_command;
}


sub reporte_cuentas {
	return `./scripts_listador/reporte_cuentas.sh @_[0]`;
}

sub listado_cuentas {
	print "\nLISTADO CUENTAS:\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO DE CUENTAS:\n\n";

	for $dir (@directorios){
		print "En el directorio $dir\n";
		print reporte_cuentas($dir);		
	}

	$bash_command = seleccion_filtros_v1() . "{print \"La cuenta: \" \$2  \" pasó los filtros - ESTADO: \" \$3 } '";
	filtro_a_bash($bash_command);

	foreach $dir (@directorios){
		
		$output = `./scripts_listador/filtrado.sh $dir `;	
		if ($output){
			print "\nEn archivo: $dir\n" . $output;
			printf REPORTE "En archivo: $dir\n" . $output;
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
		@tarjetas = `./scripts_listador/filtro_tarjetas_denunciadas.sh $dir` ;
		if (@tarjetas){
			print "En $dir las tarjetas DENUNCIADAS son:\n @tarjetas\n";
			printf REPORTE "En $dir las tarjetas DENUNCIADAS son:\n @tarjetas\n";
		}
	}

	print "Tarjetas Bloqueadas:\n";
	foreach $dir (@directorios){
		@tarjetas = `./scripts_listador/filtro_tarjetas_bloqueadas.sh $dir` ;
		if (@tarjetas){
			print "En $dir las tarjetas BLOQUEADAS son:\n @tarjetas\n";
			printf REPORTE "En $dir las tarjetas BLOQUEADAS son:\n @tarjetas\n";
		}
	}

	print "Tarjetas General (no bloqueadas, no denunciadas):\n";
	foreach $dir (@directorios){
		@tarjetas = `./scripts_listador/filtro_tarjetas_general.sh $dir` ;
		if (@tarjetas){
			print "En $dir las tarjetas GENERAL son:\n @tarjetas\n";
			printf REPORTE "En $dir las tarjetas GENERAL son:\n @tarjetas\n";
		}
	}

	print "\nReporte Listado de tarjetas: $nombre_nuevo_reporte \n";
	close(REPORTE);

}


sub reporte_condicion_distribucion {
	return `./reporte_condicion_distribucion.sh @_[0]`;
}

sub listado_condicion_distribucion {
	print "\nLISTADO CONDICION DE DISTRIBUCION\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	printf REPORTE "LISTADO CONDICION DE DISTRIBUCIÓN:\n\n";

	for $dir (@directorios){
		print "En el directorio $dir:\n";
		print reporte_condicion_distribucion($dir);		
	}

	$bash_command = seleccion_filtros_v1() . "{print \"La cuenta: \" \$2  \" pasó los filtros y tiene CONDICION DE DISTRIBUCION: \" \$7 } '";
	filtro_a_bash($bash_command);
	foreach $dir (@directorios){
		$output = `./scripts_listador/filtrado.sh $dir `;	
		if ($output){
			print "\nEn archivo: $dir\n" . $output;
			printf REPORTE "En archivo: $dir\n" . $output;
		}
	}

	print "\nReporte listado condicion de distribucion: $nombre_nuevo_reporte \n";
	close(REPORTE);	
}

sub listado_situcion_tarjeta {
	print "\nLISTADO SITUACION DE TARJETA\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());
	
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	
	print "Ingresar documento de tarjeta: ";$documento_tarjeta = <STDIN>;chomp($documento_tarjeta);

	printf REPORTE "LISTADO SITUACION DE TARJETA:\n\n";
	foreach $dir (@directorios){
		$reporte = "";
		open (OUTPUT, '-|',"scripts_listador/situacion_tarjeta.sh", ($dir,$documento_tarjeta));
	    while (<OUTPUT>) {$reporte = $reporte . $_;}
		if ($reporte){
			print "\nEn el archivo: " . $dir . "\n" . $reporte;
			printf REPORTE " En archivo: $dir\n" . $reporte;
		}else{
			print "Cuenta con documento de tarjeta: $documento_cuenta no encontrada\n";
			printf REPORTE " En archivo: $dir \n La cuenta con documento de tarjeta: $documento_cuenta no figura";
		}
	}
	print "\nReporte Situacion de TARJETA generado: $nombre_nuevo_reporte \n";
	close OUTPUT;
	close(REPORTE);
}

sub listado_situcion_cuenta {
	print "\nLISTADO SITUACION DE CUENTA\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());
	
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	open (REPORTE, ">>", $nombre_nuevo_reporte) or die $!;
	
	print "Ingresar documento de tarjeta: ";$documento_cuenta = <STDIN>;chomp($documento_cuenta);

	printf REPORTE "LISTADO SITUACION DE CUENTA:\n\n";
	foreach $dir (@directorios){
		$reporte = "";
		open (OUTPUT, '-|',"scripts_listador/situacion_cuenta.sh", ($dir,$documento_cuenta));
	    while (<OUTPUT>) {$reporte = $reporte . $_;}
		if ($reporte){
			print "\nEn el archivo: " . $dir . "\n" . $reporte;
			printf REPORTE " En archivo: $dir\n" . $reporte;
		}else{
			print "Cuenta con documento de cuenta: $documento_cuenta no encontrada\n";
			printf REPORTE " En archivo: $dir \n La cuenta con documento de cuenta: $documento_cuenta no figura";
		}
	}
	print "\nReporte Situacion de CUENTA generado: $nombre_nuevo_reporte \n";
	close OUTPUT;
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
		print "Cada listado generado se va a salvar en la carpeta de reportes: 
$directorio_reportes.
siga las instrucciones indicadas por pantalla y elija las opciones que correspondan
a su consulta\n";
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
		listado_situcion_cuenta if ($opcionListado == 3);
		listado_situcion_tarjeta if ($opcionListado == 4);
		
		print "\nPara continuar 1, para salir 0: \n";
		$continue = <STDIN>;
		chomp($continue);

	}
}

1;

