package Listador;
use Time::Piece;
use Time::Seconds;


$directorio_validados=$ENV{'VALIDADOS'}  . "/";
$directorio_reportes=$ENV{'REPORTES'}  . "/";

sub valores_input{
	print "Indique una o varias opciones separadas por \",\ : "; 
	$input = <STDIN>;
	@input = split(",",$input);	
	return @input;
}

sub obtener_directorios_archivos {
	return  `ls -t @_[0]`; #ordenados por fecha de creacion 
}

sub obtener_directorios_archivos_que_contengan {
	return  `ls -t -f @_[0]  | grep @_[1]`;
}

sub filtrar_duplicados {
    my %seen;
    grep !$seen{$_}++, @_;
}

sub obtener_nombre_nuevo_reporte{
	@arc =  Listador::obtener_directorios_archivos_que_contengan($directorio_reportes . "/", "@_[0]"); #Definido por la cantidad de reportes realizados
	$nro_seq = scalar @arc;
	return $directorio_reportes .  "@_[0]" . "_" . $nro_seq;
}


1;
