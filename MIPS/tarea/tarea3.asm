.data
    prompt1: .asciiz "¡Bienvenido a la calculadora MRUA!\n\n"
    prompt2: .asciiz "Por favor ingrese los datos siguientes:\n"
    prompt3: .asciiz "Velocidad inicial (m/s): "
    prompt4: .asciiz "Velocidad final (m/s): "
    prompt5: .asciiz "Aceleración (m/s²): "
    prompt6: .asciiz "Distancia (m): "
    prompt7: .asciiz "Tiempo (s): "
    result: .asciiz "\nResultados:\n"
    vel_init_msg: .asciiz "Velocidad inicial (redondeada): "
    vel_final_msg: .asciiz "Velocidad final (redondeada): "
    acceleration_msg: .asciiz "Aceleracion (redondeada): "
    distance_msg: .asciiz "Distancia (redondeada): "
    time_msg: .asciiz "Tiempo (redondeado): "
    input_error: .asciiz "Error en la entrada. Por favor ingrese un valor correcto.\n"
    negative_error: .asciiz "ADVERTENCIA: NO PUEDE INGRESAR VALORES NEGATIVOS. INTÉNTELO DE NUEVO.\n"

    # Variables para almacenar los datos ingresados por el usuario
    Vi: .word 0
    Vf: .word 0
    a: .word 0
    d: .word 0
    t: .word 0
    factor: .word 100  # Factor de escala para trabajar con enteros

.text
    .globl main

main:
    # Imprimir bienvenida
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 4
    la $a0, prompt2
    syscall

    # Pedir Velocidad Inicial
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 5  # Leer entero
    syscall
    sw $v0, Vi  # Guardar el valor de Vi

    # Pedir Velocidad Final
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 5  # Leer entero
    syscall
    sw $v0, Vf  # Guardar el valor de Vf

    # Pedir Aceleración
    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 5  # Leer entero
    syscall
    sw $v0, a  # Guardar el valor de a

    # Pedir Distancia
    li $v0, 4
    la $a0, prompt6
    syscall

    li $v0, 5  # Leer entero
    syscall
    sw $v0, d  # Guardar el valor de d

    # Pedir Tiempo
    li $v0, 4
    la $a0, prompt7
    syscall

    li $v0, 5  # Leer entero
    syscall
    sw $v0, t  # Guardar el valor de t

    # Aquí debes realizar los cálculos. Vamos a calcular una variable:
    # Fórmula para la Velocidad Final: Vf = Vi + a * t
    lw $t0, Vi    # Cargar Vi
    lw $t1, a     # Cargar a
    lw $t2, t     # Cargar t
    lw $t3, factor # Cargar el factor de escala

    # Realizar la multiplicación a * t (multiplicación de enteros con factor de escala)
    mul $t4, $t1, $t2     # t1 * t2 = a * t
    mul $t4, $t4, $t3     # (a * t) * factor para escalar

    # Sumar Vi
    add $t5, $t0, $t4     # Vi + (a * t)

    # Dividir por el factor para obtener el valor real redondeado
    div $t5, $t3           # Dividir (Vi + (a * t) * factor) / factor
    mflo $t6               # Obtener el cociente, que es el valor redondeado

    # Imprimir el resultado redondeado de la velocidad final
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 4
    la $a0, vel_init_msg
    syscall
    lw $a0, Vi
    li $v0, 1  # Imprimir entero
    syscall

    li $v0, 4
    la $a0, vel_final_msg
    syscall
    move $a0, $t6  # Mover el valor redondeado de Vf a $a0
    li $v0, 1  # Imprimir entero
    syscall

    # Continuar con el resto de los resultados...
    j fin

fin:
    li $v0, 10  # Salir del programa
    syscall
