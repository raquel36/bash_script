#!/bin/bash
# Me crea un array de 
tiradasPosibles=()
for fila in {0..9}; do
  for columna in {0..9}; do
    tiradasPosibles+=("$(printf "%s%s" "$fila" "$columna" )")
  done
done

turno="user"
modo="buscar"
# Cómo pintar dos tableros, uno al lado del otro
tablero_doble(){
  echo "         Radar                     Barcos"
  # Espacio extra antes de los numeros de columna
  printf "  "
  # El siguiente bucle pinta los números de columna
  for i in {0..9}
    do
    printf '%s' "$i "
    done
    # Espacio entre el rango de numeros de cada tablero(7 espacios)
    printf "       "
    # Segunda línea de números en el segundo tablero para las columnas
  for i in {0..9}
    do
      printf '%s' "$i "
    done
    echo
  # Bucle para pintar los dos tableros
  for i in {0..9}
  do
      # Muestra los números de las filas del primer tablero
      printf '%s' "$i "
      # Bucle para pintar el primer tablero
      for j in {0..9}
      do
          printf ". "
      done
      # Espacio entre tableros (5 espacios)
      printf "     "
      # Pinta los numeros de fila en el segundo tablero
      printf '%s' "$i "
      # Bucle para pintar el segundo tablero
      for j in {0..9}
      do
          printf ". "
      done
      printf "\n"
  done
}
# Definir una variable global para almacenar las coordenadas
coordenadas_ordenador=()
#Array de la información de la longitud de cada barco, aquí no es necesario el
#Diccionario, ya que es información no relevante
barcos_ordenador=(5 4 3 2 2)

generar_posiciones() {
  coordenadas_generadas=()
  for ship_size in "${barcos_ordenador[@]}"; do
    # asigna la orientación de forma aleatoria
    while :; do
      # obtiene las coordenadas del barco
      if [[ $((RANDOM % 2)) -eq 0 ]]; then
        orientation="horizontal"
      else
        orientation="vertical"
      fi

      row=$((RANDOM % 10))
      column=$((RANDOM % 10))

      if [[ "$orientation" == "horizontal" ]]; then
        if [[ "$((column + ship_size))" -ge 11 ]]; then
          continue
        fi
      else
        if [[ "$((row + ship_size))" -ge 11 ]]; then
          continue
        fi
      fi

      coordenadas_barco=()
      for i in $(seq 1 "$ship_size"); do
        if [[ "$orientation" == "horizontal" ]]; then
          coordenada="$row$((column + i - 1))"
        else
          coordenada="$((row + i - 1))$column"
        fi

        # verifica si las coordenadas están duplicadas
        if [[ "${coordenadas_generadas[*]}" =~ ${coordenada} ]]; then
          break
        fi
        coordenadas_generadas+=("$coordenada")
        coordenadas_barco+=("$coordenada")
      done

      if [[ ${#coordenadas_barco[@]} -eq $ship_size ]]; then
        # añade las coordenadas al array coordenadas_ordenador
        coordenadas_ordenador+=("${coordenadas_barco[@]}")
        # imprime las coordenadas del barco
        #echo "Coordenadas para barco de tamaño $ship_size: ${coordenadas_barco[*]}"
        # resetea el array coordenadas_barco
        coordenadas_barco=()
        break
      fi

    done
    if [[ ${#coordenadas_ordenador[@]} -eq 16 ]]; then
      #echo "Coordenadas ordenador: ${coordenadas_ordenador[*]}"
      break
    fi
  done
  
}

aciertos_ordenador=()
fallos_ordenador=()
validar_disparo_ordenador(){
  disparos_ordenador+=("$1")
   # Bucle para validar si el disparo ha sido acierto o fallo
  while [[ $validar == true ]]
  do
   if [[ "${coordenadas_barcos[*]}" =~ $1 ]]
   then
    aciertos_ordenador+=("$1")
    borrar="$1"
    modo="hundir"
    nuevo_array=()
    for coordenada in "${coordenadas_barcos[@]}"
    do
      if [[ "$coordenada" != "$borrar" ]]
      then
        nuevo_array+=("$coordenada")
      fi
    done
    coordenadas_barcos=("${nuevo_array[@]}")
    break
    else
      fallos_ordenador+=("$1")
      modo="buscar"
      break
    fi
   done
   echo "disparos realizados ordenador" "${disparos_ordenador[@]}"
}


aciertos=()
fallos=()
validar_disparo_user(){
  disparos_realizados+=("$1")
  validar=true
  # Bucle para validar si el disparo ha sido acierto o fallo
  while [[ $validar == true ]]
  do
   if [[ "${coordenadas_ordenador[*]}" =~ $1 ]]
   then
    aciertos+=("$1")
    borrar="$1"
    nuevo_array=()
    for coordenada in "${coordenadas_ordenador[@]}"
    do
      if [[ "$coordenada" != "$borrar" ]]
      then
        nuevo_array+=("$coordenada")
      fi
    done
    coordenadas_ordenador=("${nuevo_array[@]}")
    break
    else
      fallos+=("$1")
      break
    fi
   done
}

coordenadas_barcos=()
#Declaramos el diccionario
declare -A barcos
barcos=(
  ["1"]="acorazado 5"
  ["2"]="portaaviones 4"
  ["3"]="crucero 3"
  ["4"]="submarino 2"
  ["5"]="destructor 2"
)
# Esta implementación de un diccionario es incorrecta!!
#barcos=(["1"]=("acorazado" "5") ["2"]=("portaaviones" "4") ["3"]=("crucero" "3") ["4"]=("submarino" "2") ["5"]=("destructor" "2"))

disparos_realizados=()
disparos_ordenador=()
tablero_doble_barcos(){
  colorX="\e[1;32mX \e[0m"
  colorO="\e[1;31mO \e[0m"

  echo "         Radar                     Barcos"
  # Espacio extra antes de los numeros de columna
  printf "  "
  # El siguiente bucle pinta los números de columna
  for i in {0..9}
    do
    printf '%s' "$i "
    done
    # Espacio entre el rango de numeros de cada tablero(7 espacios)
    printf "       "
    # Segunda línea de números en el segundo tablero para las columnas
  for i in {0..9}
    do
      printf '%s' "$i "
    done
    echo
  # Bucle para pintar los dos tableros
  for i in {0..9}
  do
      # Muestra los números de las filas del primer tablero
      printf '%s' "$i "
      # Bucle para pintar el primer tablero
      for j in {0..9}
      do
        pos="$i$j"
        if [[ "${aciertos[*]}" =~ $pos ]]; then
          echo -ne "$colorX"
        elif [[ "${fallos[*]}" =~ $pos ]]; then
          echo -ne "$colorO"
        else
          echo -n ". "
        fi
      done
      # Espacio entre tableros (5 espacios)
      printf "     "
      # Pinta los numeros de fila en el segundo tablero
      printf '%s' "$i "
      # Bucle para pintar el segundo tablero
      for j in {0..9}
      do
        # Definimos el símbolo a introducir en la posición del
        # barco y su color - Amarillo
        coloro="\e[1;33mo \e[0m"
        # Variable que recoge cada coordenada del tablero
        pos="$i$j"
        # Bucle que permite validar si alguna de las coordenadas
        # de los barcos coincide con una posición del tablero
        if [[ "${coordenadas_barcos[*]}" =~ $pos ]]; then
          # En caso de coincidencia pintaremos la posición del barco
          echo -ne "$coloro"
        elif [[ "${aciertos_ordenador[*]}" =~ $pos ]]; then
          echo -ne "$colorX"
        elif [[ "${fallos_ordenador[*]}" =~ $pos ]]; then
          echo -ne "$colorO"
        else
          echo -n ". "
        fi
        

      done
      echo
  done
  # Eliminamos el barco colocado del diccionario
  unset "barcos[$1]"
}



# La siguiente función me permite crear las coordenadas de los barcos
# del usuario
crear_barcos_user(){
    suma=0
    # La variable long me permite validar si todo el barco ha sido colocado
    long=0
    # Renombramos las variables pasadas como parámetro para facilitar
    # su comprensión
    barco="$1"
    orientacion="$2"
    coordenadas="$3"
    coordenadas_navio=()
    # Dividimos las coordenadas de inicio en fila y columna para poder colocar
    # las coordenadas de los barcos correctamente.
    fila="${coordenadas:0:1}"
    columna="${coordenadas:1:1}"
    # Bucle que recorre el diccionario de barcos para extraer sus valores
 
    for clave in "${!barcos[@]}"; do
        # valor es el contenido de cada identificador
        valor="${barcos[$clave]}"
        # Comparamos la key con el barco introducido por el usuario
        if [[ "$clave" == "$barco" ]]; then
            # Extraemos la longitud, que es el segundo registro de cada valor
            longitud="${valor##* }"
            # Bucle que indica que mientras la longitud del barco no sea igual a la longitud
            # de las coordenadas introducidas, el bucle seguirá activo
            while [[ $long -ne $longitud ]]; do
                # Si la orientación es vertical, vamos sumando una posicion hasta alcanzar
                # la longitud del barco
                if [[ "$orientacion" == "v" ]]; then
                    fila=$((fila + suma))
                    suma=$((suma + 1))
                    long=$((long + 1))
                    # Aquí establecemos la coordenada para poder guardarla
                    posicion="$fila$columna"
                    coordenadas_navio+=("$fila$columna")
                    # Condición que comprueba si alguna posición está repetida
                    # Comprobar si la posición ya está cogida
                    repetido=false
                    for i in "${coordenadas_barcos[@]}"; do
                      if [[ $posicion == "$i" ]]; then
                        repetido=true
                        break
                      fi
                    done

                    # Si la posición ya ha sido cogida, se vuelven a pedir los datos del barco
                    if [[ $repetido == true ]]; then
                      echo "Las posiciones se superponen."
                      coordenadas_navio=()
                      echo "coordenadas vaciadas" "${coordenadas_navio[@]}"
                      decidir_posicion
                      break
                    fi

                    if [[ ! ${#coordenadas_navio} -eq 0 ]]
                    then
                       #echo "coordenadass si repeticion" "${coordenadas_navio[@]}"
                       for i in "${coordenadas_navio[@]}"
                       do
                        coordenadas_barcos+=("$i")
                       done
                       suma=1
                    fi
                # En caso de que la orientación sea horizontal, realizamos los mismos pasos que
                # en la posición vertical, pero incrementando el número de columna
                elif [[ "$orientacion" == "h" ]]; then
                    columna=$((columna + suma))
                    suma=$((suma + 1))
                    long=$((long + 1))
                    posicion="$fila$columna"
                    coordenadas_navio+=("$fila$columna")
                     # Comprobar si la posición ya está cogida
                    repetido=false
                    for i in "${coordenadas_barcos[@]}"; do
                      if [[ $posicion == "$i" ]]; then
                        repetido=true
                        break
                      fi
                    done

                    # Si la posición ya ha sido cogida, se vuelven a pedir los datos del barco
                    if [[ $repetido == true ]]; then
                      echo "Las posiciones se superponen."
                      coordenadas_navio=()
                      echo "coordenadas vaciadas" "${coordenadas_navio[@]}"
                      decidir_posicion
                      break
                    fi

                    if [[ ! ${#coordenadas_navio} -eq 0 ]]
                    then
                       echo "coordenadass sin repeticion" "${coordenadas_navio[@]}"
                       for i in "${coordenadas_navio[@]}"
                       do
                        coordenadas_barcos+=("$i")
                       done
                      suma=1
                    fi
                   
                fi
                #echo "COORDENADAS" "${coordenadas_barcos[*]}"
            done
            #clear
            if  [[ ! ${#coordenadas_navio} -eq 0 ]]
            then
            # LLamamos a la función que nos pintará el tablero con los barcos
            tablero_doble_barcos "$barco"
            fi
        fi
    done
  
}
# Variable para comprobar que la suma de fila o columna por la longitud del barco
# no supera la del tablero
lon=""
# Variable para guardar el valor máximo de fila o columna según su orientación
# de cada barco elegido
max=""
# Función que permite que el usuario introduzca los valores que se le piden,
# número de barco, orientación y coordenadas de inicio
decidir_posicion(){
    numeros_validos=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
    # Booleano que nos permitirá cerrar el bucle cuando todos los barcos estén
    # colocados
    barco_elegido=false
    while [[ $barco_elegido == false ]]
    do
        # Para saber que barcos han sido colocados en la función "tablero_doble_barcos"
        # cuando un barco ha sido colocado, lo eliminamos del diccionario. En caso que el
        # diccionario esté vacio el bucle se cerrará
         if [[ ${#barcos[*]} -eq 0 ]]
        then
          barco_elegido=true
          break
        fi
        # Mostramos los barcos disponibles que puede colocar el usuario
        echo "Los barcos a colocar son los siguientes:"
        # Array para validar las orientaciones que introduce el usuario
        orientaciones=("v" "h")
        barco_elegido=false
        #temporal=( "${!barcos[@]}" )
        # Tecnica empleada para invertir la posición en que la lista de barcos
        # se pinta por pantalla, creamos un diccionario temporal, lo giramos y
        # mostramos los valores definidos por el orden del diccionario temporal
       temporal=( "${!barcos[@]}" )

        for ((i=${#temporal[@]}-1; i>=0; i--)); do
          clave="${temporal[i]}"
          valor_completo="${barcos[$clave]}"
          tipoBarco="$(echo "$valor_completo" | awk '{print $1}')"
          longitud="$(echo "$valor_completo" | awk '{print $2}')"
          echo " $clave-$tipoBarco, Longitud: $longitud"
        done
        # El usuario debe introducir un número de barco que se muestra por pantalla
        read -r -p "Introduzca el número del barco a colocar: " barco
        # Variable que nos permite validar si el barco está en el diccionario
        if [ -z "$barco" ]; then
         echo "No ha introducido ningún valor"
         continue
        fi
        encontrado=0
        for key in "${!barcos[@]}"; do
         if [[ $key == "$barco" ]]; then
          encontrado=1
          break
         fi
        done
        # Si el barco no está en el diccionario, se le muestra un mensaje al usuario
        if [[ $encontrado == 0 ]]; then
         echo "El barco elegido no está disponible"
         continue
        fi
        # El usuario debe introducir la orientacion, vertical u horizontal
        read -r -p "Introduzca orientacion(v,h): " orientacion
        # En caso de que lo que ha introducido el usuario no se corresponda con los
        # valores válidos se le mostrára un mensaje
        if [[ ! " ${orientaciones[*]} " =~ $orientacion ]] || [[ -z "$orientacion" ]]; then
         echo "Orientación invalida"
        continue
        fi
        # El usuario debe introducir las coordenadas de inicio del barco
        read -r -p "Introduce las coordenadas de inicio del barco: " inicio
       
        # De las coordenadas de inicio extraemos la fila y la columna
        fila="${inicio:0:1}"
        columna="${inicio:1:1}"
        if [[ -z "$inicio" ]]
        then
         echo "No na introducido ningún valor"
         continue
        fi
        # Validación de que los números introducidos son correctos y de el valor
        # no es menor o mayor a 2 posiciones
        if [[ !  "${numeros_validos[*]}" =~ $fila ]] || [[ ! "${numeros_validos[*]}" =~ $columna ]] || [[ ${#inicio} -gt 2 ]] || [[ ${#inicio} -lt 2 ]]
        then
          # Limpiamos la pantalla
          #clear
          # Mensaje para indicar que el usuario ha cometido un error
          # En ese caso volvemos a ejecutar la función
          echo "inicio incorrecto, deben ser numeros del 00 al 99. No letras"
          decidir_posicion
        fi
        # Bucle que me permite validar si las posiciones introducidas no se salen
        # del tablero
        for k in "${!barcos[@]}"; do
            # val es el valor de cada key
            val="${barcos[$k]}"
            # Condición que comprueba si el número de barco es igual a la key
            if [[ "$barco" ==  "$k" ]]
            then
                # Definimos lon(longitud) y lo convertimos a número
                lon="$(echo "$val" | awk '{print $2}')"
                #echo "lon antes de la conversión: $lon"
                lon=$(bc <<< "$lon + 0")
                #echo "lon después de la conversión: $lon"
            fi
            # Condición que comprueba que orientación ha elegido el usuario,
            # y según esta información, comprobar la posición máxima que
            # ocupará el barco
            if [[ "$orientacion" == "v" ]]
            then
            max=$((fila+lon))
            #echo "fila+lon $max"
            elif [[ "$orientacion" == "h" ]]
            then
            max=$((columna+lon))
            #echo "columna+lon $max"
            fi
            # Condición que comprueba si el barco se sale del tablero según su
            # valor máximo
            if [[ $max -ge 11 ]]
            then
             #clear
             echo "El barco se sale del tablero"
             # Si el barco se sale del tablero volveremos a llamar a la función
             decidir_posicion
            fi
        done
        # Si todas las validaciones son correctas llamamos a la función que nos
        # creará las posiciones de los barcos introducidos
        crear_barcos_user "$barco" "$orientacion" "$inicio"
    done
}
 # Ultimos elementos

        # Elementos anteriores al último elemento

buscar_alrededor(){
        # Estrategias empleadas para favorecer que el ordenador sea más intuitivo
        # seleccionamos la fila y la columna de la ultima tirada acertada por el ordenador
        echo "-----buscar_alrededor--------"
        contador_eleccion=0
        fila=${aciertos_ordenador[-1]:0:1}
        fila=$((fila + 0))
        echo "Fila $fila"
        columna=${aciertos_ordenador[-1]:1:1}
        columna=$((columna + 0))
        echo "columna $columna"
        # Es obligatorio inicializar la variable, y aunque la coordenada la de como repetida, se validará despues
        eleccion="$fila$columna"
        # Dirección de la tirada consecutiva (0 = ninguna, 1 = horizontal, 2 = vertical
        direccion_tirada=0
        while [[ "${disparos_ordenador[*]}" =~ $eleccion ]]
        do
            # Si el tamaño de los aciertos es mayor a 1
            if [[ ${#aciertos_ordenador[*]} -gt 1 ]]
            then
                # Comprueba si hay una fila o columna de tiradas acertadas consecutivas
                if [[ $fila == "${aciertos_ordenador[-2]:0:1}" ]]
                then
                    direccion_tirada=1
                    # Verificamos que el número de columna no se salga del tablero
                    if [[ $((columna + 1)) -gt 9 ]]
                    then
                        columna=$((columna-1))
                    elif [[ $((columna - 1)) -lt 0 ]]
                    then
                        columna=$((columna + 1))
                    else
                        if [[ $((RANDOM % 2)) -eq 0 ]]
                        then
                          columna=$((columna - 1))
                        else
                          columna=$((columna + 1))
                        fi
                    fi
                    eleccion="$fila$columna"
                    row=${eleccion:0:1}
                    column=${eleccion:1:1}
                    echo "Eleccion en caso de aciertos consecutivos en horizontal $eleccion"
                    contador_eleccion=1
                elif [[ $columna == "${aciertos_ordenador[-2]:1:1}" ]]
                then 
                   direccion_tirada=2
                    if [[ $((fila + 1)) -gt 9 ]]
                        then
                            fila=$((fila - 1))
                        elif [[ $((fila - 1)) -lt 0 ]]
                        then
                            fila=$((fila + 1))
                        else
                            if [[ $((RANDOM % 2)) -eq 0 ]]; then
                            fila=$((fila - 1))
                            else
                            fila=$((fila + 1))
                            fi
                        eleccion="$fila$columna"
                        row=${eleccion:0:1}
                        column=${eleccion:1:1}
                        echo "Eleccion en caso de aciertos consecutivos en vertical $eleccion"
                        contador_eleccion=1
                        break
                    fi
                  fi
                  if [[ ! "${disparos_ordenador[*]}" =~ $eleccion ]]
                  then
                    row=${eleccion:0:1}
                    column=${eleccion:1:1}
                    echo "Eleccion en orientación 1 o 2 $eleccion"
                    contador_eleccion=1
                    break
                  else
                    direccion_tirada=0
                  fi                
            else
                # En caso de que no haya un número de aciertos mayor a 1, no sabremos
                # la dirección
                direccion_tirada=0
                # En caso de que el tiro elegido esté dentro de los disparos ya realizados
                # la dirección será desconocida
            fi
            if [[ "${disparos_ordenador[*]}" =~ $eleccion ]]
            then
                direccion_tirada=0
            fi
            # Si la dirección es desconocida seguimos la siguiente estrategia
            if [[ $direccion_tirada -eq 0 ]]
            then
              echo "Se ha elegido dirección aleatoria"
              # Creamos una lista de aproximaciones
              # Inicializamos fila y columna al valor inicial y definimos las variables de menor y mayor
              fila=${aciertos_ordenador[-1]:0:1}
              fila=$((fila + 0))
              filaMenos=$((fila - 1))
              echo "fila menos $filaMenos"
              filaMas=$((fila + 1))
              echo "fila mas $filaMas"
              columna=${aciertos_ordenador[-1]:1:1}
              columna=$((columna + 0))
              columnaMenos=$((columna - 1))
              echo "columna menos $columna $columnaMenos"
              columnaMas=$((columna + 1))
               echo "columna mas $columna $columnaMas"
              if [[ $columnaMas -gt 9 ]] || [[ $columnaMenos -lt 0 ]]
                then
                if [[ $filaMas -gt 9 ]]
                then
                    fila=$filaMenos
                elif [[ $filaMenos -lt 0 ]]
                then
                    fila=$filaMas
                else
                    if [[ $((RANDOM % 2)) -eq 0 ]]; then
                    fila=$filaMenos
                    else
                    fila=$filaMas
                    fi
                fi
              if [[ "${disparos_ordenador[*]}" =~ $eleccion  ]]
              then
                 indice=${#tiradasPosibles[*]}
                  mezcla=$((RANDOM % indice))
                  eleccion=${tiradasPosibles[$mezcla]}
                  row=${eleccion:0:1}
                  column=${eleccion:1:1}
                  echo "Eleccion en caso de que las condiciones anteriores no se cumplan $eleccion" 
                  contador_eleccion=1
                  break
              else
                  eleccion="$fila$columna"
                  row=${eleccion:0:1}
                  column=${eleccion:1:1}

                  echo "Eleccion validando las columnas $eleccion"
                  contador_eleccion=1
                  break
              fi
              elif [[ $filaMas -gt 9 ]] || [[ $filaMenos -lt 0 ]]
              then
                if [[ columnaMas -gt 9 ]]
                then
                    columna=$columnaMenos
                elif [[ $columnaMenos -lt 0 ]]
                then
                    columna=$columnaMas
                else
                    if [[ $((RANDOM % 2)) -eq 0 ]]
                    then
                      columna=$columnaMenos
                    else
                      columna=$columnaMas
                    fi
                fi
                 if [[ "${disparos_ordenador[*]}" =~ $eleccion  ]]
                  then
                    indice=${#tiradasPosibles[*]}
                      mezcla=$((RANDOM % indice))
                      eleccion=${tiradasPosibles[$mezcla]}
                      row=${eleccion:0:1}
                      column=${eleccion:1:1}
                      echo "Eleccion en caso de que las condiciones anteriores no se cumplan $eleccion" 
                      contador_eleccion=1
                      break
                  else
                    eleccion="$fila$columna"
                    row=${eleccion:0:1}
                    column=${eleccion:1:1}
                    echo "Elección validando las filas $eleccion"
                    contador_eleccion=1
                    break
                  fi

              else
                aproximaciones=("$filaMenos$columna" "$filaMas$columna" "$fila$columnaMenos" "$fila$columnaMas")
                # Creamos una lista de aproximaciones válidas, que serán las que no se salgan del tablero
                valid_aproximaciones=()
                for j in "${aproximaciones[@]}" 
                do 
                  mezcla=$((RANDOM % 4))
                  selected_aprox=${aproximaciones[$mezcla]} 
                  
                  echo "seleccion aproximada $selected_aprox"
                  valid_aproximaciones+=("$selected_aprox")
                  for i in "${valid_aproximaciones[@]}"
                  do
                    found=0
                    # Validamos que la aproximación no esté en los disparos ya realizados por el ordenador
                    for d in "${disparos_ordenador[@]}"; do
                      if [[ "$d" == "$i" ]]; then
                        found=1
                        echo "Elección ya realizada como disparo $i"
                        break
                      fi
                      done
                      if [[ $found -eq 0 ]]; then
                        eleccion="$i"
                        row=${eleccion:0:1}
                        column=${eleccion:1:1}
                        echo "Eleccion en caso de no saber la orientacion $eleccion"
                        contador_eleccion=1
                        break
                      else
                        indice=${#tiradasPosibles[*]}
                        mezcla=$((RANDOM % indice))
                        eleccion=${tiradasPosibles[$mezcla]}
                        row=${eleccion:0:1}
                        column=${eleccion:1:1}
                        echo "Eleccion en caso de que las condiciones anteriores no se cumplan $eleccion" 
                        contador_eleccion=1
                        break
                      fi
                    done
                  
                if [[ ! "${disparos_ordenador[*]}" =~ $eleccion ]]
                then
                  row=${eleccion:0:1}
                  column=${eleccion:1:1}
                  echo "Eleccion en orientación 0 $eleccion"
                  contador_eleccion=1
                  break
                else
                  continue
                fi         
                done
            fi 
            fi
          if [[ $contador_eleccion -eq 1 ]]
          then 
            break
          fi
      done
           
}

tirada_aleatoria(){
  echo "Tirada aleatoria"
  row=$((RANDOM % 10))
  column=$((RANDOM % 10))
  disparo_or="$row$column"
  tirada=0
      # Comprobar si el disparo ya ha sido realizado
    repetido=false
    while [[ $tirada -eq 0 ]]
    do
      for k in "${disparos_ordenador[@]}"; do
        if [[ $disparo_or == "$k" ]]; then
          repetido=true
          echo "disparo repetido, $disparo_or"
          break
        fi
      done
      # Si el disparo ya ha sido realizado, se vuelve a pedir el tiro
      if [[ $repetido == true ]]; then
        tirada_aleatoria
      else
        echo "disparo a realizar(no repetido), $disparo_or"
        tirada=$((tirada+1))
        row=${disparo_or:0:1}
        column=${disparo_or:1:1}
        repetido=false
        break
      fi
    done
}

juego_ordenador(){
  echo "$modo"
  continuar=true
   while [[ $continuar == true ]]
  do
    if [[ $modo == "buscar" ]]
    then
      tirada_aleatoria
    elif [[ $modo == "hundir" ]]
    then
      buscar_alrededor
    fi
    turno="usuario"
    continuar=false
  done
  disparo="$row$column"
  echo "disparo realizado $disparo"
  tiradasPosibles=( "${tiradasPosibles[@]}" ) # Convertir el array en una lista de elementos
for i in "${!tiradasPosibles[@]}"; do
  if [[ "${tiradasPosibles[$i]}" == "$disparo" ]]; then
    # Eliminamos el valor mediante su índice
    unset "tiradasPosibles[$i]"
    break
  fi
done
tiradasPosibles=( "${tiradasPosibles[@]}" ) # Convertir la lista de elementos de nuevo en un array
echo "disparos restantes" "${tiradasPosibles[@]}"
validar_disparo_ordenador "$disparo"
}

juego_user(){
  continuar=true
  while [[ $continuar == true ]]
  do
    # prompt para que el usuario introduzca las coordenadas de tiro
    read -r -p "Introduce una coordenada de tiro(fila,columna): " disparo
    fila="${disparo:0:1}"
    columna="${disparo:1:1}"
    # Validación de que el disparo no sea una letra ni sean numeros que se salen
    # del tablero, tanto en fila como en columna
    # El conjunto de simbolos "=~" se usan en el contexto de una condicional para
    # comprobar si una cadena de texto cumple con un determinado patrón de expresión regular.
     if [[ ! $fila =~ ^[0-9]$ ]] || [[ ! $columna =~ ^[0-9]$ ]]; then
      echo "Ha introducido letras o el disparo se sale del tablero"
       continue
    fi
    # Validación de que la longitud del disparo no es menor ni mayor a 2 digitos
     if [[ ${#disparo} -lt 2 ]] || [[ ${#disparo} -gt 2 ]]; then
       echo "La longitud del disparo es incorrecta."
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
    #clear
    # Llamamos a la función e introducimos los parámetros de tiro
    # echo -n "disparos realizados: "
    # echo "${disparos_realizados[@]}"
    # echo -n "coordenadas barcos: "
    # echo "${coordenadas_barcos[@]}"
    # echo -n "Aciertos:"
    # echo "${aciertos[@]}"
    # echo -n "Fallos ordenador"
    # echo "${fallos_ordenador[@]}"
    # echo -n "Fallos usuario"
    # echo "${fallos[@]}"
    turno="ordenador"
    continuar=false
  done
  validar_disparo_user "$disparo"
}

victoria(){
  printf "\e[1;32m
█▄        ▄█   ██     ▄█▀▀▀▀▀   ██       ▄█▀▀▀▀▀▀▀█▄   ▄█▀▀▀▀▀█▄     ██    ▄█▀▀▀▀▀▀█▄
▀█▄      ▄█▀        ▄█▀         ██▀▀▀▀   █▀       ▀█   ██      █          ██        ██
 ▀█▄    ▄█▀    ██   ██          ██       █         █   ██▄▄▄▄▄█▀     ██   ██        ██
  ▀█▄  ▄█▀     ██   ██          ██       █         █   ██  ▀█▄       ██   ██▀▀▀▀▀▀▀▀██
   ▀█▄▄█▀      ██   ▀█▄         ██       █▄       ▄█   ██    ▀█▄     ██   ██        ██
    ▀██▀       ██     ▀█▄▄▄▄▄    ▀█▄▄▄   ▀█▄▄▄▄▄▄▄█▀   ██      ▀█▄   ██   ██        ██
\e[0m"
echo
}

derrota(){
  printf "\e[1;31m
██▀▀▀▀█▄    ▄█▀▀▀▀▀▀   ▄█▀▀▀▀▀█▄     ▄█▀▀▀▀▀█▄     ▄█▀▀▀▀▀▀▀█▄   ██        ▄█▀▀▀▀▀▀█▄
██     ▀█   ██         ██      █     ██      █     █▀       ▀█   ██▀▀▀▀   ██        ██
██      █   ██▄▄▄▄     ██▄▄▄▄▄█▀     ██▄▄▄▄▄█▀     █         █   ██       ██        ██
██      █   ██         ██  ▀█▄       ██  ▀█▄       █         █   ██       ██▀▀▀▀▀▀▀▀██
██     ▄█   ██         ██    ▀█▄     ██    ▀█▄     █▄       ▄█   ██       ██        ██
██▄▄▄▄█▀    ▀█▄▄▄▄▄▄   ██      ▀█▄   ██      ▀█▄   ▀█▄▄▄▄▄▄▄█▀    ▀█▄▄▄   ██        ██
\e[0m"
echo
}

turnos(){
  running=true
  while [[ $running == true  ]]
  do
    if [[ $turno == "user" ]]
      then
        juego_user
        if [[ ${#coordenadas_ordenador} -eq 0 ]]
        then
          running=false
          victoria
          break
        else
          turno="Ordenador"
        fi
    else
      juego_ordenador
      tablero_doble_barcos
      if [[ ${#coordenadas_barcos} -eq 0 ]]
        then
          running=false
          derrota
          break
        else
          turno="user"
        fi
    fi
  done
  

}
# Llamada a la función de tablero vacio, para que el usuario tenga una idea de
# cómo es el tablero y donde colocar los barcos.
tablero_doble
generar_posiciones
decidir_posicion
turnos



#decidir_posicion
 #generate_position barcos_ordenador

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
# Arrays en Bash y Loops: iterar a través de los valores de la matriz
# https://www.linuxparty.es/116-scripting/10887-arrays-en-bash-y-loops-iterar-a-traves-de-los-valores-de-la-matriz.html

# Errores:
# bash: 09: value too great for base (error token is "09")
# El error se producia porque estába intentando usar un número decimal (09) como índice de un array en Bash, 
# pero Bash interpreta los números que comienzan con 0 como octales. Por lo tanto, 09 en octal equivale a 9 en decimal, 
# pero 9 en octal equivale a 0 en decimal, lo que provoca un error.

# Usuario Github Marc
# EntregasBM
