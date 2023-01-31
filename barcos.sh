#!/bin/bash
tablero_vacio(){
# Realiza un espacio para centrar la línea de numeros
# El parametro -n evita que se realice un salto de línea al mostrar los resultados
 echo -n " "
 # Bucle para mostrar los numeros de las columnas, en la parte superior
 # del tablero, de forma horizontal
 for i in {0..9}
  do
   echo -n "$i "
  done
  echo
# Bucle para mostrar el tablero de puntos, el primero for indicará la posición
# de fila. El segundo for indica la posicion de columna
 for i in {0..9}
  do
  # Con este "echo" se muestran los números de las filas
   echo -n "$i "

   for j in {0..9}
    do
     # El siguiente "echo" muestra cada punto en las posiciones i,j del bucle
     echo -n ". "
    done
   echo
  done
}
tablero_vacio
# prompt para que el usuario introduzca las coordenadas de tiro
read -p "Introduce una coordenada de tiro: " disparo
#echo $disparo
# Aquí extraemos el primer numero de las cifras introducidas como fila
fila="${disparo:0:1}"
# Aquí extraemos el segundo número de las cifras introducidas como columna
columna="${disparo:1:1}"
#echo $fila, $columna
# Llamamos a la función e introducimos los parámetros de tiro
tablero $fila $columna

tablero(){

 echo -n " "
 for i in {0..9}
  do
   echo -n "$i "
  done
  echo

 for i in {0..9}
  do
   echo -n "$i "
   for j in {0..9}
    do
    # El siguiente if recoge los parametros introducidos y sustituye sus posiciones
    # por una X, $1 es el primer parámetro y $2 el segundo
     if [[ "$i" -eq $1 ]] && [[ "$j" -eq $2 ]]
      then
       echo -n "X "
     else
       echo -n ". "
     fi
    done
   echo
  done
}
# Cómo sacar un numero aleatorio entre 0 y 9
numero_aleatorio=$(( RANDOM % 10 ))
echo $numero_aleatorio

# Cómo pintar dos tableros, uno al lado del otro
tablero_doble(){
  echo "         Radar                     Barcos"
  # Espacio extra antes de los numeros de columna
  printf "  "
  # El siguiente bucle pinta los números de columna
  for i in {0..9}
    do
    printf "$i "
    done
    # Espacio entre el rango de numeros de cada tablero(7 espacios)
    printf "       "
    # Segunda línea de números en el segundo tablero para las columnas
  for i in {0..9}
    do
      printf "$i "
    done
    echo
  # Bucle para pintar los dos tableros
  for i in {0..9}
  do  
      # Muestra los números de las filas del primer tablero
      printf "$i "
      # Bucle para pintar el primer tablero
      for j in {0..9}
      do
          printf ". "
      done
      # Espacio entre tableros (5 espacios)
      printf "     "
      # Pinta los numeros de fila en el segundo tablero
      printf "$i "
      # Bucle para pintar el segundo tablero
      for j in {0..9}
      do
          printf ". "
      done
      printf "\n"
  done
}

tablero_doble_barcos(){
  echo "         Radar                     Barcos"
  # Espacio extra antes de los numeros de columna
  printf "  "
  # El siguiente bucle pinta los números de columna
  for i in {0..9}
    do
    printf "$i "
    done
    # Espacio entre el rango de numeros de cada tablero(7 espacios)
    printf "       "
    # Segunda línea de números en el segundo tablero para las columnas
  for i in {0..9}
    do
      printf "$i "
    done
    echo
  # Bucle para pintar los dos tableros
  for i in {0..9}
  do  
      # Muestra los números de las filas del primer tablero
      printf "$i "
      # Bucle para pintar el primer tablero
      for j in {0..9}
      do
          printf ". "
      done
      # Espacio entre tableros (5 espacios)
      printf "     "
      # Pinta los numeros de fila en el segundo tablero
      printf "$i "
      # Bucle para pintar el segundo tablero
      for j in {0..9}
      do
        # Valida si la orientacion es vertical y las coordenadas introducidas
        if [[ "$1" -eq "v" ]] && [[ "$i" -eq "$2" ]] && [[ "$j" -eq "$3" ]]; then
          long=3
          incrementar=$2
          for k in $(seq 0 $long)
          do
           i=$((incrementar + 1))
           echo -n "o "
          done
        else
          for k in $long
          do
           i=$((i-1))
           echo -n ". "
          done
        fi
      done
      echo
  done
}
tablero_doble
read -p "Introduzca orientacion: " orientacion
read -p "Introduce las coordenadas de inicio del barco: " disparo
#echo $disparo
# Aquí extraemos el primer numero de las cifras introducidas como fila
fila="${disparo:0:1}"
# Aquí extraemos el segundo número de las cifras introducidas como columna
columna="${disparo:1:1}"
tablero_doble_barcos orientacion fila columna
# FACTORES A TENER EN CUENTA
# Las funciones en bash se encierran entre llaves, para llamarla basta boner el
# nombre de la función despues de crearla. Para pasarle parámetros se deben introducir
# al llamar a la función. Dentro de la función se definen según el orden introducido
# por ejemplo $1 seria el primer parámetro y $2, el segundo.

# CONSULTAS DE LA WEB
# Funciones en bash
# https://atareao.es/tutorial/scripts-en-bash/funciones-en-bash/
# Trabajar con cadenas en bash
# https://atareao.es/tutorial/scripts-en-bash/trabajar-con-texto-en-bash/
# Uso de printf
# https://diarioinforme.com/como-usar-printf-en-bash/
# Arrays en bash
# https://atareao.es/tutorial/scripts-en-bash/arrays-en-bash/
# Diccionarios en bash
#https://atareao.es/tutorial/scripts-en-bash/diccionarios-en-bash/

