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
    # Inicializar registros
    li $t1, 0           # Acumulador para la parte entera
    li $t2, 0           # Acumulador para la parte fraccionaria
    li $t3, 1           # Multiplicador para fracciones
    li $t4, 0           # Flag para el punto decimal (0: parte entera, 1: fracción)

    # Apuntar al inicio del buffer
    la $t0, buffer

parse_loop:
    lb $t5, 0($t0)      # Leer un carácter del buffer
    beqz $t5, end_parse # Si es carácter nulo, salir del bucle
    beq $t5, '.', switch_to_fraction # Detectar punto decimal

    # Convertir dígito
    sub $t5, $t5, '0'   # Convertir ASCII a número
    blt $t5, 0          # Ignorar si no es un dígito válido
    bge $t5, 10

    beq $t4, 0, accumulate_integer
    accumulate_fraction:
        mul $t3, $t3, 10      # Incrementar la posición decimal
        add $t2, $t2, $t5     # Agregar el dígito a la fracción
        j continue

    accumulate_integer:
        mul $t1, $t1, 10      # Desplazar parte entera
        add $t1, $t1, $t5     # Agregar el dígito
        j continue

switch_to_fraction:
    li $t4, 1                 # Cambiar a modo fracción

continue:
    addi $t0, $t0, 1          # Avanzar al siguiente carácter
    j parse_loop

end_parse:
    # Si no se encontró un punto decimal, asumir parte fraccionaria como 0
    beqz $t4, set_fraction_zero

    # Combinar parte entera y fracción en punto flotante
    mtc1 $t1, $f12            # Parte entera al registro flotante
    mtc1 $t2, $f13            # Parte fraccionaria al registro flotante
    li.s $f14, 10.0           # Valor 10 en punto flotante

fraction_div:
    c.eq.s $f13, $f0          # Verificar si la fracción es 0
    bc1t combine_float
    div.s $f13, $f13, $f14    # Dividir fracción por 10
    j fraction_div

combine_float:
    add.s $f0, $f12, $f13     # Combinar parte entera y fracción
    jr $ra                    # Retornar al llamador

set_fraction_zero:
    li.s $f13, 0.0            # Si no hay fracción, asignar 0.0 a la fracción
    j combine_float