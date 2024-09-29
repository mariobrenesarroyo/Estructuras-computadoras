    .data
A:  .word 5, 3, -1, 6, 8     # Definir el arreglo A con valores de prueba 

    .text
    .globl main
main:
    la   $s0, A               # Cargar la dirección base de A en $s0
    add  $t0, $0, $0          # Inicializar i en 0

while:
    # while(A[i] >= 0)
    sll  $t2, $t0, 2          # Multiplicar i por 4 (para obtener la dirección A[i])
    add  $t3, $s0, $t2        # Dirección de A[i] en $t3
    lw   $t4, 0($t3)          # Cargar A[i] en $t4
    slt  $t5, $t4, $0         # Comparar si A[i] < 0
    beq  $t5, $0, procedo     # Si A[i] >= 0, continuar el ciclo
    j    end_while            # Si A[i] < 0, salir del while loop

procedo:
    # for (j = 0; j < i; j++)
    add  $t1, $0, $0          # Inicializar j en 0
for:
    beq  $t1, $t0, incremento  # Si j == i, salir del for loop

    # A[i] = A[i] + A[j]
    sll  $t6, $t1, 2          # Multiplicar j por 4 (para obtener la dirección A[j])
    add  $t7, $s0, $t6        # Dirección de A[j] en $t7
    lw   $t8, 0($t7)          # Cargar A[j] en $t8
    add  $t4, $t4, $t8        # A[i] = A[i] + A[j]
    sw   $t4, 0($t3)          # Guardar el nuevo valor de A[i]

    addi $t1, $t1, 1          # j++
    j    for             # Saltar al inicio del for loop

incremento:
    addi $t0, $t0, 1          # i++
    j    while           # Saltar al inicio del while loop

end_while:
    nop                       # Fin del programa
