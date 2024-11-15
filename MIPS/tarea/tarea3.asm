.data
prompts: .asciiz "Ingrese 'x' para calcular, 'n' para excluir o el valor numérico:\n"
promptVi: .asciiz "Velocidad inicial (Vi): "
promptVf: .asciiz "Velocidad final (Vf): "
promptA: .asciiz "Aceleración (a): "
promptD: .asciiz "Distancia (d): "
promptT: .asciiz "Tiempo (t): "
msgCalculoA: .asciiz "Calculando aceleración como predeterminado.\n"
error: .asciiz "Error: Se ingresaron datos erroneos.\n"
x: .asciiz "x"
n: .asciiz "n"
buffer: .space 2

.text
main:
    la $a0, prompts
    li $v0, 4
    syscall

    # Leer entradas para Vi, Vf, a, d y t
    jal leer_valor_Vi
    jal leer_valor_Vf
    jal leer_valor_a
    jal leer_valor_d
    jal leer_valor_t

    # Verificar cuál variable tiene 'x'
    jal verificar_x

    # Salir del programa
    li $v0, 10
    syscall

# Función para leer Vi
leer_valor_Vi:
    la $a0, promptVi
    jal leer_valor
    move $t1, $v0  # Guardar Vi en $t1
    jr $ra

# Función para leer Vf
leer_valor_Vf:
    la $a0, promptVf
    jal leer_valor
    move $t2, $v0  # Guardar Vf en $t2
    jr $ra

# Función para leer a
leer_valor_a:
    la $a0, promptA
    jal leer_valor
    move $t3, $v0  # Guardar a en $t3
    jr $ra

# Función para leer d
leer_valor_d:
    la $a0, promptD
    jal leer_valor
    move $t4, $v0  # Guardar d en $t4
    jr $ra

# Función para leer t
leer_valor_t:
    la $a0, promptT
    jal leer_valor
    move $t5, $v0  # Guardar t en $t5
    jr $ra

# Leer valor general (x, n o número positivo)
leer_valor:
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t6, buffer      # Leer primer caracter ingresado

    # Comparar si es 'x' o 'n'
    la $t7, x           # Cargar "x" en $t7
    la $t8, n           # Cargar "n" en $t8
    lb $t9, ($t7)       # Obtener valor ASCII de "x"
    lb $t0, ($t8)       # Obtener valor ASCII de "n"

    # Si es 'x', asignar marcador 2 para cálculo
    beq $t6, $t9, marcar_para_calculo

    # Si es 'n', asignar marcador 0 para ignorar
    beq $t6, $t0, marcar_para_ignorar

    # Si no es ni 'x' ni 'n', verificar si es un valor numérico
    li $v0, 5
    syscall
    move $t6, $v0  # Guardar el valor ingresado en $t6

    # Verificar si el valor es negativo
    bltz $t6, error_dato_invalido  # Si $t6 < 0, error

    # Guardar el valor como numérico y marcarlo como tal
    li $t7, 1       # Marcar como valor numérico
    move $v0, $t6   # Devolver el valor ingresado
    jr $ra

marcar_para_calculo:
    li $v0, 0       # Valor temporal
    li $t7, 2       # Marcar para cálculo
    jr $ra

marcar_para_ignorar:
    li $v0, 0       # Valor temporal
    li $t7, 0       # Marcar para ignorar
    jr $ra

# Mensaje de error si el dato ingresado es inválido
error_dato_invalido:
    la $a0, error
    li $v0, 4
    syscall
    li $v0, 10      # Salir del programa
    syscall

# Verificar cuál variable tiene 'x' y es la única para cálculo
verificar_x:
    # Contar cuántas variables están marcadas para cálculo
    li $t7, 0
    add $t7, $t7, $t1  # Suma el valor de $t1 al acumulador $t7
    add $t7, $t7, $t2  # Suma el valor de $t2 al acumulador $t7
    add $t7, $t7, $t3  # Suma el valor de $t3 al acumulador $t7
    add $t7, $t7, $t4  # Suma el valor de $t4 al acumulador $t7
    add $t7, $t7, $t5  # Suma el valor de $t5 al acumulador $t7

    # Si no hay ninguna variable con 'x', mostrar mensaje y calcular aceleración
    beq $t7, 0, calcular_a_defecto

    # Si solo hay una variable con 'x', hacer el cálculo de esa variable
    li $t8, 2
    beq $t1, $t8, calcular_vi
    beq $t2, $t8, calcular_vf
    beq $t3, $t8, calcular_a
    beq $t4, $t8, calcular_d
    beq $t5, $t8, calcular_t

    # Si hay más de una 'x', mostrar mensaje de error
    la $a0, error
    li $v0, 4
    syscall
    jr $ra

calcular_a_defecto:
    la $a0, msgCalculoA
    li $v0, 4
    syscall
    # Lógica para calcular aceleración como valor predeterminado
    # Aquí iría el código para calcular 'a'
    jr $ra

calcular_vi:
    # Lógica para calcular Vi
    jr $ra

calcular_vf:
    # Lógica para calcular Vf
    jr $ra

calcular_a:
    # Lógica para calcular A
    jr $ra

calcular_d:
    # Lógica para calcular D
    jr $ra

calcular_t:
    # Lógica para calcular T
    jr $ra
