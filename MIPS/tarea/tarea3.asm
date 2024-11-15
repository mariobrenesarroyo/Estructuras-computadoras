.data
x: .asciiz "x"
n: .asciiz "n"
msg_v_inicial: .asciiz "Velocidad inicial (m/s): "
msg_v_final: .asciiz "Velocidad final (m/s): "
msg_aceleracion: .asciiz "Aceleracion (m/s^2): "
msg_distancia: .asciiz "Distancia (m): "
msg_tiempo: .asciiz "Tiempo (s): "
msg_invalid: .asciiz "Valor no valido. Ingrese un numero flotante o un caracter ASCII.\n"
msg_result: .asciiz "Resultados:\n"

.text
.globl main

main:
    # Pedir velocidad inicial
    li $v0, 4
    la $a0, msg_v_inicial
    syscall
    
    # Leer entrada de velocidad inicial
    li $v0, 5
    syscall
    move $t0, $v0  # Guardar velocidad inicial en $t0
    
    # Pedir velocidad final
    li $v0, 4
    la $a0, msg_v_final
    syscall
    
    # Leer entrada de velocidad final
    li $v0, 5
    syscall
    move $t1, $v0  # Guardar velocidad final en $t1
    
    # Pedir aceleración
    li $v0, 4
    la $a0, msg_aceleracion
    syscall
    
    # Leer entrada de aceleración
    li $v0, 5
    syscall
    move $t2, $v0  # Guardar aceleración en $t2
    
    # Pedir distancia
    li $v0, 4
    la $a0, msg_distancia
    syscall
    
    # Leer entrada de distancia
    li $v0, 5
    syscall
    move $t3, $v0  # Guardar distancia en $t3
    
    # Pedir tiempo
    li $v0, 4
    la $a0, msg_tiempo
    syscall
    
    # Leer entrada de tiempo
    li $v0, 5
    syscall
    move $t4, $v0  # Guardar tiempo en $t4
    
    # Inicializar contadores
    li $t5, 0  # Contador de "x" o "n"
    li $t6, 0  # Contador de números <= 0
    
    # Verificar los valores
    # Verificar si la velocidad inicial contiene 'x' o 'n'
    jal check_value
    
    # Verificar si la velocidad final contiene 'x' o 'n'
    jal check_value
    
    # Verificar si la aceleración contiene 'x' o 'n'
    jal check_value
    
    # Verificar si la distancia contiene 'x' o 'n'
    jal check_value
    
    # Verificar si el tiempo contiene 'x' o 'n'
    jal check_value
    
    # Imprimir resultados
    li $v0, 4
    la $a0, msg_result
    syscall
    
    # Imprimir contador de "x" o "n"
    move $a0, $t5
    li $v0, 1
    syscall
    
    # Imprimir contador de números <= 0
    move $a0, $t6
    li $v0, 1
    syscall

    # Salir
    li $v0, 10
    syscall

# Subrutina para verificar si un valor contiene 'x' o 'n' o es <= 0
check_value:
    # Verificar si el valor es "x" o "n"
    li $t7, 120  # ASCII de 'x'
    li $t8, 110  # ASCII de 'n'
    beq $t0, $t7, increment_xn
    beq $t0, $t8, increment_xn
    
    # Verificar si el valor es <= 0
    blez $t0, increment_zero_or_negative
    jr $ra
    
increment_xn:
    addi $t5, $t5, 1  # Incrementar el contador de 'x' o 'n'
    jr $ra
    
increment_zero_or_negative:
    addi $t6, $t6, 1  # Incrementar el contador de valores <= 0
    jr $ra
