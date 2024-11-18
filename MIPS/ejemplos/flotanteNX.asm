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

    # Leer número flotante ingresado
        li $v0, 6               # Llamada al sistema para leer un número flotante
        syscall
        mov.s $f12, $f0         # Mueve el número leído de $f0 a $f12 (preparación para impresión)

        # Mostrar mensaje antes de imprimir el flotante
        la $a0, mensaje_four    # Carga la dirección del mensaje "El flotante ingresado es:"
        addiu $v0, $zero, 4     # Llamada al sistema para imprimir string
        syscall

        # Imprimir el número flotante ingresado
        addiu $v0, $zero, 2     # Llamada al sistema para imprimir un número flotante
        syscall

        # Terminar el programa
        li $v0, 10              # Llamada al sistema para salir del programa
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
