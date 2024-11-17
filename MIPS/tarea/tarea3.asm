.data
n: .asciiz "n"
x: .asciiz "x"

msg_bienvenida: .asciiz "Bienvenido, ingrese valores x, n, o numeros entre 0 y 100\n"
msg_ingresar_valor: .asciiz "Ingrese valor para A: "
msg_error: .asciiz "Error: El valor (valor) es 'n' y no se puede realizar el calculo\n"
msg_exito_A: .asciiz "Exitos, el calculo de A es: "
msg_exito_B: .asciiz "Exitos, el calculo de B es: "
msg_exito_C: .asciiz "Exitos, el calculo de C es: "
msg_exito_D: .asciiz "Exitos, el calculo de D es: "
msg_exito_E: .asciiz "Exitos, el calculo de E es: "

.text
main:
    # Mostrar mensaje de bienvenida
    li $v0, 4
    la $a0, msg_bienvenida
    syscall

    # Ingresar los valores A, B, C, D, E
    # Ingresar A
    li $v0, 4
    la $a0, msg_ingresar_valor
    syscall
    li $v0, 5       # Leer entero
    syscall
    move $t0, $v0   # Guardar A en $t0

    # Ingresar B
    li $v0, 4
    la $a0, msg_ingresar_valor
    syscall
    li $v0, 5       # Leer entero
    syscall
    move $t1, $v0   # Guardar B en $t1

    # Ingresar C
    li $v0, 4
    la $a0, msg_ingresar_valor
    syscall
    li $v0, 5       # Leer entero
    syscall
    move $t2, $v0   # Guardar C en $t2

    # Ingresar D
    li $v0, 4
    la $a0, msg_ingresar_valor
    syscall
    li $v0, 5       # Leer entero
    syscall
    move $t3, $v0   # Guardar D en $t3

    # Ingresar E
    li $v0, 4
    la $a0, msg_ingresar_valor
    syscall
    li $v0, 5       # Leer entero
    syscall
    move $t4, $v0   # Guardar E en $t4

    # Llamar a calcular_A
    jal calcular_a

    # Llamar a calcular_B
    jal calcular_b

    # Llamar a calcular_C
    jal calcular_c

    # Llamar a calcular_D
    jal calcular_d

    # Llamar a calcular_E
    jal calcular_e

    # Terminar el programa
    li $v0, 10
    syscall

calcular_a:
    # Verificar si B, C, D, o E son 'n'
    beq $t1, $s1, error_b
    beq $t2, $s1, error_b
    beq $t3, $s1, error_b
    beq $t4, $s1, error_b

    # Calcular la suma de B + C + D + E
    add $t5, $t1, $t2  # B + C
    add $t5, $t5, $t3  # B + C + D
    add $t5, $t5, $t4  # B + C + D + E

    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, msg_exito_A
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    # Terminar el programa después de calcular A
    li $v0, 10
    syscall

error_b:
    # Imprimir mensaje de error
    li $v0, 4
    la $a0, msg_error
    syscall

    # Terminar el programa en caso de error
    li $v0, 10
    syscall

calcular_b:
    # Verificar si A, C, D, o E son 'n'
    beq $t0, $s1, error_b_calculo
    beq $t2, $s1, error_b_calculo
    beq $t3, $s1, error_b_calculo
    beq $t4, $s1, error_b_calculo

    # Calcular la suma de A + C + D + E
    add $t5, $t0, $t2  # A + C
    add $t5, $t5, $t3  # A + C + D
    add $t5, $t5, $t4  # A + C + D + E

    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, msg_exito_B
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    # Terminar el programa después de calcular B
    li $v0, 10
    syscall

error_b_calculo:
    # Imprimir mensaje de error
    li $v0, 4
    la $a0, msg_error
    syscall

    # Terminar el programa en caso de error
    li $v0, 10
    syscall

calcular_c:
    # Verificar si A, B, D, o E son 'n'
    beq $t0, $s1, error_c
    beq $t1, $s1, error_c
    beq $t3, $s1, error_c
    beq $t4, $s1, error_c

    # Calcular la suma de A + B + D + E
    add $t5, $t0, $t1  # A + B
    add $t5, $t5, $t3  # A + B + D
    add $t5, $t5, $t4  # A + B + D + E

    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, msg_exito_C
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    # Terminar el programa después de calcular C
    li $v0, 10
    syscall

error_c:
    # Imprimir mensaje de error
    li $v0, 4
    la $a0, msg_error
    syscall

    # Terminar el programa en caso de error
    li $v0, 10
    syscall

calcular_d:
    # Verificar si A, B, C, o E son 'n'
    beq $t0, $s1, error_d
    beq $t1, $s1, error_d
    beq $t2, $s1, error_d
    beq $t4, $s1, error_d

    # Calcular la suma de A + B + C + E
    add $t5, $t0, $t1  # A + B
    add $t5, $t5, $t2  # A + B + C
    add $t5, $t5, $t4  # A + B + C + E

    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, msg_exito_D
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    # Terminar el programa después de calcular D
    li $v0, 10
    syscall

error_d:
    # Imprimir mensaje de error
    li $v0, 4
    la $a0, msg_error
    syscall

    # Terminar el programa en caso de error
    li $v0, 10
    syscall

calcular_e:
    # Verificar si A, B, C, o D son 'n'
    beq $t0, $s1, error_e
    beq $t1, $s1, error_e
    beq $t2, $s1, error_e
    beq $t3, $s1, error_e

    # Calcular la suma de A + B + C + D
    add $t5, $t0, $t1  # A + B
    add $t5, $t5, $t2  # A + B + C
    add $t5, $t5, $t3  # A + B + C + D

    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, msg_exito_E
    syscall
    li $v0, 1
    move $a0, $t5
    syscall

    # Terminar el programa después de calcular E
    li $v0, 10
    syscall

error_e:
    # Imprimir mensaje de error
    li $v0, 4
    la $a0, msg_error
    syscall

    # Terminar el programa en caso de error
    li $v0, 10
    syscall
