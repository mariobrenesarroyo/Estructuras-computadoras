.data
# Mensajes
bienvenida:    .asciiz "Bienvenido, ingrese valores 110, 120 y flotantes  (110 para calcular, 120 para excluir):\n"
ingreseA:      .asciiz "Ingrese valor Vi (m/s): "
ingreseB:      .asciiz "Ingrese valor Vf (m/s): "
ingreseC:      .asciiz "Ingrese valor A (m/s^2): "
ingreseD:      .asciiz "Ingrese valor D (m): "
ingreseE:      .asciiz "Ingrese valor T (s): "
error_120:     .asciiz "Error: el valor %d es 120 y no se puede realizar el cálculo.\n"
error_neg:     .asciiz "Error: el valor %d es negativo y no se puede realizar el cálculo.\n"
exitosoA:      .asciiz "Éxito, el cálculo de Vi es: %d\n"
exitosoB:      .asciiz "Éxito, el cálculo de Vf es: %d\n"
exitosoC:      .asciiz "Éxito, el cálculo de A es: %d\n"
exitosoD:      .asciiz "Éxito, el cálculo de D es: %d\n"
exitosoE:      .asciiz "Éxito, el cálculo de T es: %d\n"
ingrese_salir: .asciiz "Ingrese 1 para un nuevo cálculo o 0 para salir: "
newline:       .asciiz "\n"

# Espacio para almacenar valores
Vi:    .word 0
Vf:    .word 0
A:     .word 0
D:     .word 0
T:     .word 0

.text
.globl main

main:
    # Mensaje de bienvenida
    li $v0, 4
    la $a0, bienvenida
    syscall

nuevo_calculo:
    # Leer los valores de Vi, Vf, A, D, y T
    jal leer_valor   # Vi
    sw $v0, Vi
    jal leer_valor   # Vf
    sw $v0, Vf
    jal leer_valor   # A
    sw $v0, A
    jal leer_valor   # D
    sw $v0, D
    jal leer_valor   # T
    sw $v0, T

    # Validar valores y realizar cálculos
    jal validar_y_calcular

    # Preguntar si el usuario quiere salir o repetir
    li $v0, 4
    la $a0, ingrese_salir
    syscall

    li $v0, 5
    syscall
    beq $v0, 0, salir
    beq $v0, 1, nuevo_calculo
    j salir

leer_valor:
    # Mostrar el mensaje adecuado
    li $v0, 4
    la $a0, ingreseA # Mensaje genérico
    syscall

    # Leer el valor ingresado
    li $v0, 5
    syscall
    move $t0, $v0  # Guardar valor en $t0

    jr $ra         # Retornar el valor en $v0

validar_y_calcular:
    # Cargar los valores
    lw $t1, Vi
    lw $t2, Vf
    lw $t3, A
    lw $t4, D
    lw $t5, T

    # Validar si hay un valor 120 o negativo
    jal validar_valores

    # Realizar cálculos según el valor desconocido
    # Ejemplo para calcular Vi
    li $t6, 110
    beq $t1, $t6, calcular_Vi

    # Calcular otros valores si corresponden
    jr $ra

validar_valores:
    # Revisar si hay un valor 120
    li $t6, 120
    beq $t1, $t6, error_es_120
    beq $t2, $t6, error_es_120
    beq $t3, $t6, error_es_120
    beq $t4, $t6, error_es_120
    beq $t5, $t6, error_es_120

    # Revisar si hay un valor negativo
    bltz $t1, error_es_neg
    bltz $t2, error_es_neg
    bltz $t3, error_es_neg
    bltz $t4, error_es_neg
    bltz $t5, error_es_neg

    jr $ra

calcular_Vi:
    # Vi = Vf - A*T
    mul $t7, $t3, $t5    # A*T
    sub $t0, $t2, $t7    # Vf - A*T
    sw $t0, Vi           # Guardar resultado

    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, exitosoA
    syscall
    li $v0, 1
    move $a0, $t0
    syscall
    j validar_y_calcular

error_es_120:
    # Mostrar mensaje de error para 120
    li $v0, 4
    la $a0, error_120
    syscall
    j salir

error_es_neg:
    # Mostrar mensaje de error para valores negativos
    li $v0, 4
    la $a0, error_neg
    syscall
    j salir

salir:
    # Finalizar el programa
    li $v0, 10
    syscall
