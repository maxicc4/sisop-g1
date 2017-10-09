package Listador_Manual;
use Listador;


# $directorio_validados=$ENV{'files_validated'};
# $files_reports=$ENV{'files_reports'};
$directorio_validados = '../files_validated/';
$directorio_reportes = '../files_report/';

sub filtro_entidad{}
sub filtro_fuente{}
sub filtro_condicion_distribucion {}
sub filtro_documento_cuenta {}
sub filtro_documento_tarjeta {}


sub listado_cuentas {
	print "Listado Cuentas\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

	# seleccion_filtros();
	$nombre_nuevo_reporte = Listador::obtener_nombre_nuevo_reporte("reporte");
	
	@estados_cuentas = ("ACTIVA","BAJA", "CTX", "JUD");
	foreach $estado (@estados_cuentas) {
		print "Numeros de Cuentas en Estado: $estado \n";
		foreach $dir (@directorios){
			print ` ./script_aux.sh $estado $dir `;
		}
	}


	
}
sub listado_tarjetas {
	print "Listado Tarjetas\n";
}
sub listado_condicion_distribucion {
	print "Listado Condicion de Distribucion\n";
}
sub listado_situcion_cuenta {
	print "Listado Situacion de Cuenta\n";
	@directorios = Listador::filtrar_duplicados(seleccion_archivos());

}
sub listado_situcion_tarjeta {
	print "Listado Situacion de Tajeta\n";
	foreach $dir (@directorios){
			print ` ./script_aux.sh $estado $dir `;
	}
	

}



sub seleccion_archivos{
	@directorios = ();
	$opciones = scalar 0;

	print "\nEl o los archivos seleccionados serán los usados para generar el listado:\n\n";

	@archivos_validados = Listador::obtener_directorios_archivos($directorio_validados);

    print "ARCHIVOS VALIDADOS:\n\n";
    foreach my $archivo (@archivos_validados) {
    	print $opciones .". ". $archivo;
		$opciones +=1;
    }

	print $opciones . ". todos\n\n";
	$opciones +=1;

	@reportes = Listador::obtener_directorios_archivos_que_contengan($directorio_reportes, "plasticos_distribucion_");

    
	print "REPORTES: \n\n";
    foreach my $archivo (@reportes) {
		print $opciones .". ". $archivo;
		$opciones +=1;
	}

	print $opciones . ". todos\n\n";
	@input =  Listador::valores_input();

	@directorios;
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
Opcion elegida: ";

		$opcionListado = <STDIN>;
		
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

