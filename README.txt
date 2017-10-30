# sisop-g1 

# Trabajo práctico de la materia Sistemas Operativos - FIUBA

## Integrantes

* **Burastero Maximiliano Ariel**
* **Galván Pedro Nahuel**
* **Perez Bustos Drew María Victoria**
* **Prado María Florencia**
* **Suppes Maximiliano**


## Descarga del paquete

Una explicación de cómo descargar el paquete

## Descompresión del paquete

Ejecute el comando tar -xvzf tp.tgz dentro una carpeta previamente creada.

### Contenido del paquete

El paquete posee los siguientes archivos necesarios para la instalacion: 
bin.tar (scripts ejecutables)
maestros.tar (archivos maestros)
grupo01 ( carpeta donde se realizará la instalacion )
install.sh (instalador)

## Pre-requisitos

Para poder instalar y ejecutar el sistema se requieren los siguientes programas:

* Bash
* Shell Script
* Perl versión 5 o superior


## Instalación

### Instrucciones

Después de descomprimir el paquete, nos paramos en la carpeta donde se encuentra el archivo install.sh y procedemos a instalar el sistema con el comando:

. install.sh
Si el sistema se encuentra instalado correctamente la instalación terminará. Y tendremos el sistema correctamente instalado en la carpeta grupo01.
Si el sistema se encuentra instalado con errores, se informará por pantalla.

El sistema nos irá mostrando los subdirectorios de instalación por defecto, 
dejandonos cambiarlos si así lo quisiéramos.

### Reparación de una instalación

Para reparar el sistema ejecute el comando . install.sh -r

### Contenido de la instalación

La estructura de instalación sera la siguiente: ( dependiendo del directorio de extraccion ) 

/home/user/grupo01/ejecutables
/home/user/grupo01/maestros
/home/user/grupo01/aceptados
/home/user/grupo01/rechazados
/home/user/grupo01/validados
/home/user/grupo01/reportes
/home/user/grupo01/log
/home/user/grupo01/dirconf

## Ejecución

### Primeros pasos

Para ejecutar el sistema, debemos situarnos en la carpeta de "ejecutables" y correr el preparador.
Si no le cambiamos el nombre durante la instalación:

```
cd grupo01/ejecutables
. preparador.sh
```
Este comando inicializará el sistema y dejará corriendo al demonio.

Luego el sistema pedirá el ingreso de un directorio donde irá leyendo los archivos a procesar (ingresar ruta completa).

### Detener demonio

Para parar el demonio ejecutamos el comando:

```
stop_demonio
```
Si queremos volver a ejecutar el demonio bastará con correr nuevamente el preparador, como ya se mencionó anteriormente en "Primeros pasos".

### Listador

Es invocado automáticamente por el "Validador" a través del comando:

```
perl listador.pl -a
```
O puede ser invocado manualmente ejecutando:

```
perl listador.pl -m
```

También se cuenta con la posibilidad de acceder a líneas de ayuda para el modo manual, agregando "-h en la llamada a la funcion:


```
perl listador.pl -m -h
```

