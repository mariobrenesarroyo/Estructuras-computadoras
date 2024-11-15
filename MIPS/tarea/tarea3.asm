.data
promptVi: .asciiz "Ingrese velocidad inicial (Vi): "
promptVf: .asciiz "Ingrese velocidad final (Vf): "
promptA: .asciiz "Ingrese aceleración (a): "
promptD: .asciiz "Ingrese distancia (d): "
promptT: .asciiz "Ingrese tiempo (t): "
msgError: .asciiz "Error: No se puede calcular, valor inválido.\n"
msgCalculoA: .asciiz "Calculando aceleración...\n"
msgCalculoVi: .asciiz "Calculando velocidad inicial...\n"
msgCalculoVf: .asciiz "Calculando velocidad final...\n"
msgCalculoD: .asciiz "Calculando distancia...\n"
msgCalculoT: .asciiz "Calculando tiempo...\n"
buffer: .space 2  # Espacio para un carácter

# Definir cadenas "x" y "n"
x: .asciiz "x"
n: .asciiz "n"

.text
.globl main
main:
    # Pedir los valores y almacenarlos
    jal leer_valor_Vi
    jal leer_valor_Vf
    jal leer_valor_A
    jal leer_valor_D
    jal leer_valor_T

    # Verificar cuál valor es 'x' para calcular
    jal verificar_calculo

    # Salir del programa
    li $v0, 10
    syscall

# Función para leer el valor de Vi
leer_valor_Vi:
    la $a0, promptVi
    jal leer_valor
    move $t0, $v0  # Guardar Vi en $t0
    jr $ra

# Función para leer el valor de Vf
leer_valor_Vf:
    la $a0, promptVf
    jal leer_valor
    move $t1, $v0  # Guardar Vf en $t1
    jr $ra

# Función para leer el valor de A
leer_valor_A:
    la $a0, promptA
    jal leer_valor
    move $t2, $v0  # Guardar A en $t2
    jr $ra

# Función para leer el valor de D
leer_valor_D:
    la $a0, promptD
    jal leer_valor
    move $t3, $v0  # Guardar D en $t3
    jr $ra

# Función para leer el valor de T
leer_valor_T:
    la $a0, promptT
    jal leer_valor
    move $t4, $v0  # Guardar T en $t4
    jr $ra

# Función para leer un valor general
leer_valor:
    li $v0, 4      # Mostrar mensaje
    syscall
    li $v0, 8      # Leer cadena
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t5, buffer # Leer primer carácter

    # Comprobar si es 'n' o 'x'
    la $t6, n       # Cargar 'n' en $t6
    lb $t7, ($t6)   # Leer 'n' (valor ASCII)
    beq $t5, $t7, valor_invalido

    la $t6, x       # Cargar 'x' en $t6
    lb $t7, ($t6)   # Leer 'x' (valor ASCII)
    beq $t5, $t7, valor_invalido

    # Si no es 'x' ni 'n', leer número
    li $v0, 5      # Leer entero
    syscall
    move $v0, $t6  # Guardar el número ingresado en $v0
    jr $ra

valor_invalido:
    li $v0, 4      # Mostrar error
    la $a0, msgError
    syscall
    li $v0, 10     # Salir del programa
    syscall

# Función para verificar qué cálculo hacer
verificar_calculo:
    # Comprobamos si cada valor es 'x' para determinar qué calcular

    # Verificar Vi
    beq $t0, 'x', calcular_Vi

    # Verificar Vf
    beq $t1, 'x', calcular_Vf

    # Verificar A
    beq $t2, 'x', calcular_A

    # Verificar D
    beq $t3, 'x', calcular_D

    # Verificar T
    beq $t4, 'x', calcular_T

    jr $ra

# Función para calcular Vi
calcular_Vi:
    la $a0, msgCalculoVi
    li $v0, 4
    syscall
    # Lógica para calcular Vi
    jr $ra

# Función para calcular Vf
calcular_Vf:
    la $a0, msgCalculoVf
    li $v0, 4
    syscall
    # Lógica para calcular Vf
    jr $ra

# Función para calcular A
calcular_A:
    la $a0, msgCalculoA
    li $v0, 4
    syscall
    # Lógica para calcular A
    jr $ra

# Función para calcular D
calcular_D:
    la $a0, msgCalculoD
    li $v0, 4
    syscall
    # Lógica para calcular D
    jr $ra

# Función para calcular T
calcular_T:
    la $a0, msgCalculoT
    li $v0, 4
    syscall
    # Lógica para calcular T
    jr $ra
