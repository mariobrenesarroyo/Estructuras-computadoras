
.data
    ingreso: .asciiz "\n Ingrese un numero flotante: "   # Mensaje para solicitar un flotante
    mensaje_four: .asciiz "El flotante ingresado es:  " # Mensaje antes de mostrar el flotante
    x: .asciiz "x"
    n: .asciiz "n"
    ms1: .asciiz "el valor ingresado es una n"
    ms2: .asciiz "el valor ingresado es una x"
    buffer: .space 20 # Espacio para almacenar la cadena de entrada

.text
main:
    # Mostrar mensaje de solicitud
    la $a0, ingreso         # Carga la dirección del mensaje "Ingrese un número flotante"
    addiu $v0,$zero,4            # Llamada al sistema para imprimir string
    syscall

    # Leer número flotante ingresado
    li $v0, 8               # Llamada al sistema para leer una cadena
    la $a0, buffer          # Dirección de almacenamiento de la cadena leída
    li $a1, 20              # Longitud máxima de la cadena
    syscall

    # Llamar a la función de verificación
    jal verificar_entrada

    # Llamar a la función para convertir la cadena a flotante
    jal convertir_cadena_a_float
 

    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, mensaje_four            # Carga la dirección del mensaje "El flotante ingresado es:" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f0                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante 

    syscall                         # Terminar el programa 
    li $v0, 10                      # Llamada al sistema para salir del programa 
    syscall

verificar_entrada:
    # Verificar si la entrada es 'n' o 'x'
    la $t0, n               # Cargar dirección de "n"
    la $t1, x               # Cargar dirección de "x"
    lb $t2, 0($a0)          # Cargar el primer carácter de la entrada

    # Comparar con 'n'
    lb $t3, 0($t0)
    beq $t2, $t3, es_n

    # Comparar con 'x'
    lb $t4, 0($t1)
    beq $t2, $t4, es_x

    # Si no es 'n' ni 'x', asumir que es un número
    jr $ra

es_n:
    la $a0, ms1             # Cargar dirección del mensaje "el valor ingresado es una n"
    addiu $v0,$zero,4            # Llamada al sistema para imprimir string
    syscall

    # Terminar el programa
    li $v0, 10              # Llamada al sistema para salir del programa
    syscall

es_x:
    la $a0, ms2             # Cargar dirección del mensaje "el valor ingresado es una x"
    addiu $v0,$zero,4            # Llamada al sistema para imprimir string
    syscall

    # Terminar el programa
    li $v0, 10              # Llamada al sistema para salir del programa
    syscall


# Función convertir_cadena_a_float
# Entrada: Dirección de la cadena en $a0
# Salida: Número flotante en $f0

convertir_cadena_a_float:
    # $a0: dirección de la cadena
    # Devuelve: $f0 - el número en punto flotante

    # Inicializar variables
    li $t0, 0       # Parte entera
    li $t1, 0       # Parte fraccionaria
    li $t2, 0       # Indicador de punto decimal
    li $t3, 10      # Para multiplicaciones
    mtc1 $t0, $f0   # Mover parte entera a $f0
    cvt.s.w $f0, $f0 # Convertir a flotante de precisión simple
    
bucle:
    lb $t4, 0($a0)   # Cargar un byte de la cadena
    beqz $t4, fin    # Si es el terminador nulo, salir del bucle
    beq $t4, '.', punto_decimal # Verificar si es un punto decimal
    
    blt $t4, '0', entrada_invalida  # Verificar carácter inválido
    bgt $t4, '9', entrada_invalida  # Verificar carácter inválido
    
    sub $t4, $t4, '0'  # Convertir de ASCII a número entero
    
    # Si está antes del punto decimal (o no hay punto decimal todavía)
    bnez $t2, parte_fraccionaria 
    
    mul $t0, $t0, $t3 # Multiplicar la parte entera actual por 10
    add $t0, $t0, $t4 # Sumar el nuevo dígito
    
    # Mover la parte entera actualizada a $f0
    mtc1 $t0, $f0
    cvt.s.w $f0, $f0  
    
    b siguiente_caracter
    
parte_fraccionaria:
    mul $t1, $t1, $t3 # Multiplicar la parte fraccionaria actual por 10
    add $t1, $t1, $t4 # Sumar el nuevo dígito
    addi $t2, $t2, 1   # Incrementar el contador de posiciones decimales

siguiente_caracter:
    addi $a0, $a0, 1   # Pasar al siguiente carácter de la cadena
    j bucle
    
punto_decimal:
    li $t2, 1       # Activar indicador de punto decimal
    j siguiente_caracter
    
entrada_invalida:
    # Manejar entrada inválida (por ejemplo, imprimir un mensaje de error)
    # ...
    jr $ra

fin:
    # Si no se encontró un punto decimal, asumir .0
    beqz $t2, asumir_decimal_cero 
    
    # Convertir la parte fraccionaria a flotante y sumarla a la parte entera
    mtc1 $t1, $f1       # Mover parte fraccionaria a $f1
    cvt.s.w $f1, $f1   # Convertir a flotante de precisión simple
    
    # Dividir por 10 elevado a la cantidad de posiciones decimales
    # (Podrías necesitar un bucle o función aparte para esto)
    # Ejemplo para 1 posición decimal: div.s $f1, $f1, 10.0
    # Ajustar según el número real de posiciones decimales usando $t2
    # ...
    # Para simplificar, asumiendo una posición decimal
    lui $t5, 0x4120     # Cargar los 16 bits superiores de 10.0 (0x41200000)
    ori $t5, $t5, 0x0000 # Configurar los 16 bits inferiores a 0 (no necesario aquí, pero incluido por claridad)
    mtc1 $t5, $f2      # Mover el valor de $t5 a $f2
    cvt.s.w $f2, $f2    # Convertir a flotante de precisión simple
    
    div.s $f1, $f1, $f2
    
    add.s $f0, $f0, $f1  # Sumar las partes entera y fraccionaria
    
    jr $ra              # Retornar
    
asumir_decimal_cero:
    # Si no se encontró un punto decimal en la cadena, $f0 ya contiene la parte entera.
    # No necesitamos sumarle nada porque implícitamente es .0
    jr $ra
