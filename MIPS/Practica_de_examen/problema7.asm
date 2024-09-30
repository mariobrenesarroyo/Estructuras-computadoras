.data
A:      .word 1, 2, -3, 6, 5, -7, 9   # Definición del arreglo A
N:      .word 7                      # Número de elementos en el arreglo

.text
.globl main

main:
    la $a0, A                      # Cargar la dirección base del arreglo A en $a0
    lw $a1, N                      # Cargar el número de elementos N en $a1
    jal find_min_max               # Llamar a la función find_min_max

    li $v0, 10                     # Código de servicio para terminar el programa
    syscall

find_min_max:
    addi $sp, $sp, -16             # Reservar espacio en la pila
    sw $ra, 12($sp)                # Guardar el valor de $ra
    sw $s0, 8($sp)                 # Guardar el valor de $s0
    sw $s1, 4($sp)                 # Guardar el valor de $s1
    sw $s2, 0($sp)                 # Guardar el valor de $s2

    add $s0, $a0, $zero            # $s0 = dirección base del array A
    add $s1, $a1, $zero            # $s1 = N (número de elementos)
    lw $t0, 0($s0)                 # Cargar el primer elemento del array en $t0
    add $t7, $t0, $zero            # Inicializar $t7 con el primer elemento (máximo)
    add $t3, $t0, $zero            # Inicializar $t3 con el primer elemento (mínimo)
    addi $s2, $zero, 1             # Inicializar el índice en 1

# Bucle para encontrar el máximo
loop_max:
    beq $s2, $s1, end_loop_max     # Si el índice es igual a N, salir del bucle
    sll $t1, $s2, 2                 # Calcular el desplazamiento: índice * 4
    add $t2, $s0, $t1               # Calcular la dirección de A[indice]
    lw $t4, 0($t2)                  # Cargar A[indice] en $t4

    jal check_max                   # Llamar a la función check_max

    addi $s2, $s2, 1                # Incrementar el índice
    j loop_max                      # Repetir el bucle

end_loop_max:
    add $v0, $t7, $zero             # Guardar el valor máximo en $v0
    addi $s2, $zero, 1              # Reiniciar el índice para el siguiente bucle

# Bucle para encontrar el mínimo
loop_min:
    beq $s2, $s1, end_loop_min      # Si el índice es igual a N, salir del bucle
    sll $t1, $s2, 2                  # Calcular el desplazamiento: índice * 4
    add $t2, $s0, $t1                # Calcular la dirección de A[indice]
    lw $t4, 0($t2)                   # Cargar A[indice] en $t4

    jal check_min                   # Llamar a la función check_min

    addi $s2, $s2, 1                # Incrementar el índice
    j loop_min                      # Repetir el bucle

end_loop_min:
    add $v1, $t3, $zero             # Guardar el valor mínimo en $v1

    lw $ra, 12($sp)                 # Restaurar el valor de $ra
    lw $s0, 8($sp)                  # Restaurar el valor de $s0
    lw $s1, 4($sp)                  # Restaurar el valor de $s1
    lw $s2, 0($sp)                  # Restaurar el valor de $s2
    addi $sp, $sp, 16               # Restaurar el puntero de pila
    jr $ra                          # Retornar

check_max:
    addi $sp, $sp, -8               # Reservar espacio en la pila
    sw $ra, 4($sp)                  # Guardar el valor de $ra
    sw $t4, 0($sp)                  # Guardar el valor de $t4

    slt $t5, $t7, $t4               # Si $t7 < $t4, $t5 = 1
    beq $t5, $zero, end_check_max   # Si $t7 >= $t4, saltar a end_check_max
    add $t7, $t4, $zero             # Actualizar el máximo

end_check_max:
    lw $t4, 0($sp)                  # Restaurar el valor de $t4
    lw $ra, 4($sp)                  # Restaurar el valor de $ra
    addi $sp, $sp, 8                # Restaurar el puntero de pila
    jr $ra                          # Retornar

check_min:
    addi $sp, $sp, -8               # Reservar espacio en la pila
    sw $ra, 4($sp)                  # Guardar el valor de $ra
    sw $t4, 0($sp)                  # Guardar el valor de $t4

    slt $t6, $t4, $t3               # Si $t4 < $t3, $t6 = 1
    beq $t6, $zero, end_check_min   # Si $t4 >= $t3, saltar a end_check_min
    add $t3, $t4, $zero             # Actualizar el mínimo

end_check_min:
    lw $t4, 0($sp)                  # Restaurar el valor de $t4
    lw $ra, 4($sp)                  # Restaurar el valor de $ra
    addi $sp, $sp, 8                # Restaurar el puntero de pila
    jr $ra                          # Retornar
