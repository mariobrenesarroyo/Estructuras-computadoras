.data
    ingreso: .asciiz "\nIngrese un numero flotante: "        # Mensaje para solicitar flotante
    mensaje_fin: .asciiz "\nLos valores flotantes ingresados son:\n" # Mensaje antes de imprimir flotantes
    flotantes: .space 20          # Espacio para almacenar 5 flotantes (4 bytes cada uno, 5x4=20 bytes)


.text
    main:
        li $t0, 0                # Inicializa índice del bucle (contador)
        la $t1, flotantes        # Dirección base del arreglo donde se guardarán los flotantes

    # Bucle para ingresar 5 flotantes
    leer_flotantes:
        # Mostrar mensaje para solicitar un número flotante
        la $a0, ingreso          # Carga la dirección del mensaje "Ingrese un número flotante"
        addiu $v0, $zero, 4      # Llamada al sistema para imprimir string
        syscall

        # Leer número flotante ingresado
        li $v0, 6                # Llamada al sistema para leer flotante
        syscall
        swc1 $f0, 0($t1)         # Almacena el flotante en la dirección actual del arreglo
        addiu $t1, $t1, 4        # Incrementa la dirección del arreglo (siguiente posición)
        
        addiu $t0, $t0, 1        # Incrementa el contador
        li $t2, 5                # Valor máximo del contador
        bne $t0, $t2, leer_flotantes  # Si no hemos ingresado 5 flotantes, repite el bucle

    # Mostrar mensaje antes de imprimir los flotantes
    la $a0, mensaje_fin          # Carga el mensaje "Los valores flotantes ingresados son:"
    addiu $v0, $zero, 4          # Llamada al sistema para imprimir string
    syscall

    # Imprimir los flotantes ingresados
    li $t0, 0                    # Reinicia el índice del bucle
    la $t1, flotantes            # Dirección base del arreglo

    imprimir_flotantes:
        lwc1 $f12, 0($t1)        # Carga el flotante de la posición actual del arreglo
        addiu $v0, $zero, 2      # Llamada al sistema para imprimir flotante
        syscall

        addiu $t1, $t1, 4        # Incrementa la dirección del arreglo (siguiente posición)
        addiu $t0, $t0, 1        # Incrementa el contador
        li $t2, 5                # Valor máximo del contador
        bne $t0, $t2,
