.data
    ingreso: .asciiz "\nIngrese un numero flotante: "        # Mensaje para solicitar flotante
    mensaje_fin: .asciiz "\nLos valores flotantes ingresados son:\n" # Mensaje antes de imprimir flotantes
    flotantes: .space 20          # Espacio para almacenar 5 flotantes (4 bytes cada uno, 5x4=20 bytes)


.text
    main:
        # Mostrar mensaje de solicitud
        la $a0, ingreso         # Carga la dirección del mensaje "Ingrese un número flotante"
        addiu $v0, $zero, 4     # Llamada al sistema para imprimir string
        syscall

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
