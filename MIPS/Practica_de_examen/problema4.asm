    la   $t1, 0x20202020        # Cargar la dirección de N
    lw   $t2, 0($t1)            # Cargar N en $t2
    add  $t0, $0, $0            # Inicializar i en 0
    add  $t9, $0, $0            # Variable igual a 0 en t9 (se usa para comparar con A[i])
    
for:
    beq  $t0, $t2, end_for      # Si i == N, salir del bucle

    # Calcular la dirección de A[i]
    sll  $t3, $t0, 2            # Multiplicar i por 4 (tamaño de palabra)
    add  $t4, $s0, $t3          # Dirección de A[i] en $t4

    # if(A[i] < 0)
    lw   $t5, 0($t4)            # Cargar A[i] en $t5
    slt  $t6, $t5, $0           # Comparar A[i] < 0, si sí $t6 = 1
    beq  $t6, $0, check_next    # Si A[i] >= 0, saltar a check_next

    # A[i] = -A[i]
    sub  $t5, $0, $t5           # A[i] = -A[i]
    sw   $t5, 0($t4)            # Guardar -A[i] de nuevo en A[i]

check_next:
    addi $t6, $t0, 1            # Calcular i + 1
    bge  $t6, $t2, increment_i  # Si i+1 >= N, saltar a incrementar i

    # A[i] = A[i] + 2*A[i+1]
    sll  $t6, $t6, 2            # Multiplicar (i + 1) por 4
    add  $t7, $s0, $t6          # Dirección de A[i+1] en $t7
    lw   $t8, 0($t7)            # Cargar A[i+1] en $t8
    sll  $t8, $t8, 1            # Multiplicar A[i+1] por 2
    add  $t5, $t5, $t8          # A[i] = A[i] + 2*A[i+1]
    sw   $t5, 0($t4)            # Guardar el resultado en A[i]

increment_i:
    addi $t0, $t0, 1            # Incrementar i
    j    for                    # Saltar al inicio del bucle

end_for:
    # Fin del bucle
    nop
