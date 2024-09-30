.data
A:      .word 1, 2, -3, 6, 5, -7, 9   # Definición del arreglo A
N:      .word 7                      # Número de elementos en el arreglo

.text
.globl main

main:
    la $a0, A                      # Cargar la dirección base del arreglo A en $a0
    lw $a1, N                      # Cargar el número de elementos N en $a1
    jal find_min_max               # Llamar a la función find_min_max

    # Imprimir el valor máximo
    move $a0, $v0                  # Mover el valor máximo a $a0 para imprimir
    li $v0, 1                      # Servicio para imprimir entero
    syscall                        # Imprimir el valor máximo

    # Imprimir el valor mínimo
    move $a0, $v1                  # Mover el valor mínimo a $a0 para imprimir
    li $v0, 1                      # Servicio para imprimir entero
    syscall                        # Imprimir el valor mínimo

    # Finalizar el programa
    li $v0, 10                     # Código de servicio para terminar el programa
    syscall

find_min_max:
    addi $sp, $sp, -16             # Reservar espacio en la pila
    sw $ra, 12($sp)                # Guardar el valor de $ra
    sw $s0, 8($sp)                 # Guardar el valor de $s0
    sw $s1, 4($sp)                 # Guardar el valor de $s1
    sw $s2, 0($sp)                 # Guardar el valor de $s2

    add $s0, $a0, $zero            # $s0 = dirección base del array A
    lw $s1, 0($s0)                 # Cargar el primer elemento del array en $s1
    add $t7, $s1, $zero            # Inicializar $t7 con el primer elemento (máximo)
    add $t3, $s1, $zero            # Inicializar $t3 con el primer elemento (mínimo)
    addi $s2, $zero, 1             # Inicializar el índice i en 1
    lw $t8, N                       # Cargar el número de elementos en $t8

loop:
    beq $s2, $t8, end_loop         # Si el índice i es igual a N, salir del bucle
    sll $t1, $s2, 2                # Calcular el desplazamiento: índice i * 4
    add $t2, $s0, $t1              # Calcular la dirección de A[i]
    lw $t4, 0($t2)                 # Cargar A[i] en $t4

    # Verificar máximo
    slt $t5, $t7, $t4              # Si $t7 < $t4, $t5 = 1
    beq $t5, $zero, check_min      # Si $t7 >= $t4, saltar a check_min
    add $t7, $t4, $zero            # Actualizar el máximo

check_min:
    # Verificar mínimo
    slt $t6, $t4, $t3              # Si $t4 < $t3, $t6 = 1
    beq $t6, $zero, next           # Si $t4 >= $t3, saltar a next
    add $t3, $t4, $zero            # Actualizar el mínimo

next:
    addi $s2, $s2, 1               # Incrementar el índice i
    j loop                         # Repetir el bucle

end_loop:
    move $v0, $t7                  # Guardar el valor máximo en $v0
    move $v1, $t3                  # Guardar el valor mínimo en $v1

    lw $ra, 12($sp)                # Restaurar el valor de $ra
    lw $s0, 8($sp)                 # Restaurar el valor de $s0
    lw $s1, 4($sp)                 # Restaurar el valor de $s1
    lw $s2, 0($sp)                 # Restaurar el valor de $s2
    addi $sp, $sp, 16              # Restaurar el puntero de pila
    jr $ra                         # Retornar
