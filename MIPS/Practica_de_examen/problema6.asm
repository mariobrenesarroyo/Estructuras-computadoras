sum_array:
    addi $sp, $sp, -12      # Reservar espacio en la pila
    sw   $ra, 8($sp)        # Guardar la dirección de retorno
    sw   $s0, 4($sp)        # Guardar $s0 en la pila
    sw   $s1, 0($sp)        # Guardar $s1 en la pila

    add  $s0, $a0, $zero    # Copiar la dirección base del arreglo A a $s0
    add  $s1, $a1, $zero    # Copiar el tamaño N a $s1

    addi $t0, $zero, 0      # Inicializar índice i en $t0
    addi $t1, $zero, 0      # Inicializar suma en $t1

loop: 
    slt  $t2, $t0, $s1      # $t2 = 1 si i < N
    beq  $t2, $zero, end    # Si i >= N, salir del bucle

    sll  $t2, $t0, 2        # Calcular la dirección de A[i] (i * 4)
    add  $t3, $s0, $t2      # $t3 = dirección de A[i]
    lw   $t4, 0($t3)        # Cargar A[i] en $t4

    add  $t1, $t1, $t4      # Sumar A[i] a la suma total
    addi $t0, $t0, 1        # Incrementar i
    j    loop                # Volver al inicio del bucle

end: 
    add  $v0, $t1, $zero     # Devolver la suma total en $v0
    lw   $ra, 8($sp)         # Restaurar dirección de retorno
    lw   $s0, 4($sp)         # Restaurar $s0
    lw   $s1, 0($sp)         # Restaurar $s1
    addi $sp, $sp, 12        # Restaurar el puntero de pila
    jr   $ra                 # Regresar
