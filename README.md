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

Una explicación de cómo descomprimir, crear directorio del grupo, etc
listado de comandos

### Contenido del paquete

Una explicación de lo que se crea a partir de la descompresión

## Pre-requisitos

Para poder instalar y ejecutar el sistema se requieren los siguientes programas:

* Bash
* Shell Script
* Perl versión 5 o superior


## Instalación

### Instrucciones

Después de descomprimir el paquete, procedemos a instalar el sistema con el comando:

```
. install.sh
```

El sistema nos irá mostrando los subdirectorios de instalación por defecto, 
dejandonos cambiarlos si así lo quisiéramos

### Reparación de una instalación

Una explicacion de como reparar la reparación de la instalación, listado de comandos

### Contenido de la instalación

Que nos deja la instalación y dónde

## Ejecución

### Primeros pasos

Para ejecutar el sistema, debemos situarnos en la carpeta de "ejecutables" y correr el preparador.
Si no le cambiamos el nombre durante la instalación:

```
cd grupo01/ejecutables
. preparador.sh
```
Este comando inicializará el sistema y dejará corriendo al demonio.

### Detener demonio

Para parar el demonio ejecutamos el comando:

```
stop_demonio
```

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

