find_min_max:
    addi $sp, $sp, -16             # Reservar espacio en la pila
    sw $ra, 12($sp)                # Guardar el valor de $ra
    sw $s0, 8($sp)                 # Guardar el valor de $s0
    sw $s1, 4($sp)                 # Guardar el valor de $s1
    sw $s2, 0($sp)                 # Guardar el valor de $s2

    add $s0, $a0, $zero            # $s0 = dirección base del array A
    add $s1, $a1, $zero            # $s1 = N (número de elementos)
    lw $t0, 0($s0)                 # Cargar el primer elemento del array en $t0
    add $v0, $t0, $zero            # Inicializar $v0 con el primer elemento (máximo)
    add $v1, $t0, $zero            # Inicializar $v1 con el primer elemento (mínimo)
    addi $s2, $zero, 1             # Inicializar el índice en 1

loop:
    beq $s2, $s1, end_loop         # Si el índice es igual a N, salir del bucle
    sll $t1, $s2, 2                # Calcular el desplazamiento: índice * 4
    add $t2, $s0, $t1              # Calcular la dirección de A[indice]
    lw $t3, 0($t2)                 # Cargar A[indice] en $t3

    # Comparar y actualizar el máximo
    slt $t4, $v0, $t3              # Si $v0 < $t3, $t4 = 1
    beq $t4, $zero, check_min      # Si $v0 >= $t3, saltar a check_min
    add $v0, $t3, $zero            # Actualizar el máximo

check_min:
    # Comparar y actualizar el mínimo
    slt $t5, $t3, $v1              # Si $t3 < $v1, $t5 = 1
    beq $t5, $zero, next           # Si $t3 >= $v1, saltar a next
    add $v1, $t3, $zero            # Actualizar el mínimo

next:
    addi $s2, $s2, 1               # Incrementar el índice
    j loop                         # Repetir el bucle

end_loop:
    lw $ra, 12($sp)                # Restaurar el valor de $ra
    lw $s0, 8($sp)                 # Restaurar el valor de $s0
    lw $s1, 4($sp)                 # Restaurar el valor de $s1
    lw $s2, 0($sp)                 # Restaurar el valor de $s2
    addi $sp, $sp, 16              # Restaurar el puntero de pila
    jr $ra                         # Retornar
