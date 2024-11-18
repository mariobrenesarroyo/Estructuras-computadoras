.data
    ingreso: .asciiz "\nIngrese un número flotante o una letra (n/x): "
    mensaje_n: .asciiz "Ingresaste la letra 'n', valor predeterminado asignado.\n"
    mensaje_x: .asciiz "Ingresaste la letra 'x', valor predeterminado asignado.\n"
    mensaje_default: .asciiz "Flotante válido ingresado.\n"

.text
    main:
        # Mostrar mensaje de solicitud
        la $a0, ingreso         # Carga la dirección del mensaje
        li $v0, 4               # Llamada al sistema para imprimir string
        syscall

        # Leer número flotante ingresado
        li $v0, 6               # Llamada al sistema para leer flotante
        syscall
        mov.s $f1, $f0          # Almacena el número leído en $f1

        # Verificar si el usuario ingresó 'n' o 'x'
        mfc1 $t0, $f0           # Mueve el valor en $f0 a $t0 para manipulación
        li $t1, 0x3EB73190      # Valor hexadecimal correspondiente a 'n'
        li $t2, 0x3D00ECFA      # Valor hexadecimal correspondiente a 'x'

        # Comparar con 'n'
        beq $t0, $t1, letra_n

        # Comparar con 'x'
        beq $t0, $t2, letra_x

        # Si no es una letra conocida, asumir valor válido
        j flotante_valido

    letra_n:
        # Mensaje para la letra 'n'
        la $a0, mensaje_n
        li $v0, 4
        syscall

        # Asignar valor 3EB73190 a $f1
        li $t0, 0x3EB73190
        mtc1 $t0, $f1
        j fin

    letra_x:
        # Mensaje para la letra 'x'
        la $a0, mensaje_x
        li $v0, 4
        syscall

        # Asignar valor 3D00ECFA a $f1
        li $t0, 0x3D00ECFA
        mtc1 $t0, $f1
        j fin

    flotante_valido:
        # Mensaje para flotante válido
        la $a0, mensaje_default
        li $v0, 4
        syscall

    fin:
        # Terminar el programa
        li $v0, 10
        syscall
