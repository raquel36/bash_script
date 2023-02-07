#!/bin/bash

# ---/ Variables /---
disparos_realizados=() # Array que guarda los disparos del jugador
k=0 # Variable utilizada para recorrer los datos del array de disparos realizados
coordenadas_barcos=() # Array de coordenadas de los barcos a hundir
contador=0 # Variable empleada para contar las tiradas realizadas
aciertos=() # Array para guardar los aciertos del usuario
fallos=() # Array para guardar los fallos del usuario


# ---/ Funciones /---

titulo(){
   printf "\e[1;34m
  ▄█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█▄
▄█▀                                                                                                                      ▀█▄
█   ████████▄     ▄█▀▀▀▀▀▀█▄    ██       ██       ██         ▄█▀▀▀▀▀▀▀▀   ▄███████▄    ▄█        █▄     ██     ▄██████▄    █
█   ██      ██   ██        ██   ██       ██       ██         ██          ██       ██   ██        ██            ██      ██  █
█   ██      ██   ██        ██   ██▀▀▀▀   ██▀▀▀▀   ██         ██          ▀█▄           ██        ██     ██     ██      ██  █
█   █████████    ██▀▀▀▀▀▀▀▀██   ██       ██       ██         ██▄▄▄▄▄▄      ██████▄     ██▄▄▄▄▄▄▄▄██     ██     ███████▀    █
█   ██      ██   ██        ██   ██       ██       ██         ██                  ▀█▄   ██        ██     ██     ██          █
█   ██      ██   ██        ██   ██       ██       ██         ██          ██       ██   ██        ██     ██     ██          █
█   ████████▀    ██        ██    ▀█▄▄▄    ▀█▄▄▄   ██▄▄▄▄▄▄   ▀█▄▄▄▄▄▄▄▄   ▀███████▀    ▀█        █▀     ██     ██          █
▀█▄                                                                                                                      ▄█▀
 ▀█▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█▀
 \e[0m"
 echo
 echo
}

instrucciones(){
titulo
printf "Bienvenido a las instrucciones de Battleship.\n
Este juego es una versión reducida al juego que conocemos de Battleship  (Hundir la flota en castellano), ya que solo juega el usuario.\n
Para jugar a este Battleship, al jugador se le muestra por pantalla un tablero de 5x5 donde debe indicar las coordenadas de tiro.\n
    - Las coordenadas se indican mediante dos números, el primero será la fila y el segundo la columna, por ejemplo 03, 44, 16.\n
    - En cada partida se generarán 5 posiciones diferentes de barcos del ordenador, que el jugador debe ir hundiendo.\n
    - El juego termina cuando el jugador acaba con todos los barcos o cuando alcanza un número máximo de tiradas.(15)\n                                                                                                                                                       

A continuación se muestra una partida empezada como referencia:\n
    
          
  0 1 2 3 4\n        
0 · \e[1;32mX\e[0m · · \e[1;31mO\e[0m\n
1 · · · \e[1;31mO\e[0m ·\n
2 · · \e[1;32mX\e[0m · ·\n 
3 · · · · ·\n 
4 · · · \e[1;31mO\e[0m ·\n
"

echo "Presiona cualquier tecla para continuar..."
#Detecta cualquier tecla del teclado y no se muestra por pantalla
read -r -n 1 -s
echo "Continuando con el programa..."
}


tablero(){
 echo -n "  "
 # Números de columna
 for i in {0..4}
  do
   echo -n "$i "
  done
  echo

 for i in {0..4}
  do
   # Numeros de fila
   echo -n "$i "
   for j in {0..4}
    do
      # La siguiente variable define el color del simbolo "O", 1 es grosor extra, 31m es el color rojo
      colorO="\e[1;31mO \e[0m"
      # En vez de sustraer fila y columna, lo compacto en una variable y lo comparo con la lista de disparos realizados
      pos="$i$j"
      # Variable empleada para pintar los aciertos, una X en verde.
      colorX="\e[1;32mX \e[0m"
      # Variable empleada para pintar los fallos, un O en rojo.
      colorO="\e[1;31mO \e[0m"
      pos="$i$j"
      if [[ "${aciertos[*]}" =~ $pos ]]; then
        # -ne sirve para indicar que no realice un salto de línea (-n) y (-e) sirver para interpretar los simbolos \ o de escape
        echo -ne "$colorX"
      elif [[ "${fallos[*]}" =~ $pos ]]; then
        echo -ne "$colorO"
      else
        echo -n ". "
      fi
    done
  echo
done
}

# CORRECCIONES
crear_barcos(){
  while [ ${#coordenadas_barcos[*]} -lt 5 ]
  do
    #echo "Estoy dentro, creando barquitos"
    # Para que tenga en cuenta todas las posiciones del tablero, el random debe ser hasta 5,
    # creará números random del 0 al 4
    fila=$(( RANDOM % 5 ))
    columna=$(( RANDOM % 5 ))
    posicion="$fila$columna"
    # Cuando se realiza una comparación con "=~" es mejor hacerla contra una variable
    if [[ ! "${coordenadas_barcos[*]}" =~ $posicion ]]; then
      # Aquí añado las posiciones de cada barco
      coordenadas_barcos+=("$posicion")
    fi
  done
}

# CODIGO ANTERIOR
# crear_barcos(){
#   while [ ${#barcos[*]} -lt 5 ]
#   do
#     echo "Estoy dentro, creando barquitos"
#     fila=$(( RANDOM % 4 ))
#     columna=$(( RANDOM % 4 ))
#     if [[ ! "${barcos[*]}" =~ " $fila$columna " ]]; then
#       barcos+=("$fila$columna")
#     fi
#   done
# }
validar_disparo(){
  validar=true
  # Bucle para validar si el disparo ha sido acierto o fallo
  while [[ $validar == true ]]
  do
   # comparamos el parámetro introducido con las coordenadas de los barcos
   if [[ "${coordenadas_barcos[*]}"  =~ $1 ]]
   then
    aciertos+=("$1")
    #echo "Aciertos" "${aciertos[@]}"
    borrar="$1"
    nuevo_array=()
    # En este bucle eliminamos las posiciones que ya se han acertado
    for coordenada in "${coordenadas_barcos[@]}"
    do
      if [[ "$coordenada" != "$borrar" ]]
      then
        # Emplemos un array temporal para guardar las coordenadas restantes
        nuevo_array+=("$coordenada")
      fi
    done
    # Reseteamos el array de coordenadas con el array temporal
    coordenadas_barcos=("${nuevo_array[@]}")
    break
    else
      fallos+=("$1")
      #echo "fallos" "${fallos[@]}"
      break
    fi
   done
   # LLamamos a la función "tablero" para que nos pinte las posiciones de aciertos
   # o fallos
   tablero
}

fin_juego(){
   printf "\e[1;31m
           ███▀▀▀██ ███▀▀▀███ ███▀█▄█▀███ ██▀▀▀
           ██    ██ ██     ██ ██   █   ██ ██   
           ██   ▄▄▄ ██▄▄▄▄▄██ ██   ▀   ██ ██▀▀▀
           ██    ██ ██     ██ ██       ██ ██   
           ███▄▄▄██ ██     ██ ██       ██ ██▄▄▄

           ███▀▀▀███ ▀███  ██▀ ██▀▀▀ ██▀▀▀▀██▄
           ██     ██   ██  ██  ██    ██     ██
           ██     ██   ██  ██  ██▀▀▀ ██▄▄▄▄▄▀▀
           ██     ██   ██  █▀  ██    ██     ██
           ███▄▄▄███    ▀█▀    ██▄▄▄ ██     ██▄
           \e[0m
           \e[1;32mHAS GANADO!!!\n
           Has realizado %s$contador disparos!!\e[0m\n"
  echo
}


juego(){
  # Mientras la longitud de las coordenadas de los barcos sea diferente a 0
  while [[ "${#coordenadas_barcos}" -ne 0 ]]
  do
    # prompt para que el usuario introduzca las coordenadas de tiro
    #echo "${barcos[*]}"
    read -r -p "Introduce una coordenada de tiro(fila,columna): " disparo
    fila="${disparo:0:1}"
    columna="${disparo:1:1}"
     # Validación de que la longitud del disparo no es menor ni mayor a 2 digitos
     if [[ ${#disparo} -lt 2 ]] || [[ ${#disparo} -gt 2 ]]; then
       echo "La longitud del disparo es incorrecta."
       continue
    fi
    # Validación de que el disparo no sea una letra ni sean numeros que se salen 
    # del tablero, tanto en fila como en columna
    # El conjunto de simbolos "=~" se usan en el contexto de una condicional para
    # comprobar si una cadena de texto cumple con un determinado patrón de expresión regular. 
     if [[ ! "$fila" =~ ^[0-4]$ ]] || [[ ! "$columna" =~ ^[0-4]$ ]]; then
      echo "Ha introducido letras o el disparo se sale del tablero"
       continue
    fi
    # Comprobar si el disparo ya ha sido realizado
    repetido=false
    for k in "${disparos_realizados[@]}"; do
      if [[ $disparo == "$k" ]]; then
        repetido=true
        break
      fi
    done

    # Si el disparo ya ha sido realizado, se vuelve a pedir el tiro
    if [[ $repetido == true ]]; then
      echo "Este disparo ya ha sido realizado. Introduce una nueva coordenada."
      continue
    fi
    clear
    #Guardamos los disparos realizados en el array
    disparos_realizados+=("$disparo")
    # Llamamos a la función que nos pintará el tablero con los aciertos y fallos
    validar_disparo "$disparo"
    # Los argumentos "string" y "array" se deben pasar de forma separada
    #echo "disparos realizados:" "${disparos_realizados[@]}"
    #Incrementamos el contador de disparos
    contador=$((contador + 1))
    # echo "contador disparos: $contador"
    # if [[ $contador -eq 10 ]]
    # then
    #   echo "Ha alcanzado el límite de disparos!"
    #   break
    # fi
  done
  # Cuando el array de barcos esté vacio llamaremos a la función fin de juego 
  # que nos pintará un game over
  if [[ "${#coordenadas_barcos}" -eq 0 ]]
  then
    fin_juego
  fi
}

# LLamamos a las funciones necesarias para iniciar el juego
instrucciones
tablero
crear_barcos
echo -n "barcos ordenador "
echo "${coordenadas_barcos[@]}"
juego



# FACTORES A TENER EN CUENTA
# Las funciones en bash se encierran entre llaves, para llamarla basta boner el
# nombre de la función despues de crearla. Para pasarle parámetros se deben introducir
# al llamar a la función. Dentro de la función se definen según el orden introducido
# por ejemplo $1 seria el primer parámetro y $2, el segundo.

# Una función en la que se necesitan parametros externos para trabajar no puede ser llamada
# si parametros, en cambio si los datos con los que trabajan pertenecen a variables o arrays globales
# si se puede llamar sin parámetros, por eso he eliminado la función que me creaba un tablero vacio
# al inicio del juego

# Al recorrer un array siempre empezará por el primer elemento, por eso no puedo recorrer el array
# de barcos para validar los aciertos, ya que si el primer valor no coincide, se guardará como fallo

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
# https://atareao.es/tutorial/scripts-en-bash/diccionarios-en-bash/
# Colorear el prompt, codigos de color
# https://atareao.es/como/colorear-la-linea-de-comandos/
# Da color a tus scripts en bash
# https://noroute2host.com/color-bash.html
# Expresión regular para saber si un número no está en el rango de numeros válidos
# https://es.stackoverflow.com/questions/333071/comprobar-que-la-variable-sea-un-n%C3%BAmero-en-bash