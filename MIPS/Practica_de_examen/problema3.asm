.data
A: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11
.text
.globl main
main:
    la $s0, A          # Cargar la dirección base del arreglo A en $s0
    addi $t0, $zero, 1 # Inicializa $t0 con el valor 1

while:
    sll $t1, $t0, 1         # $t1 = i * 2
    sll $t2, $t1, 2         # $t2 = (i * 2) * 4 (desplazamiento en bytes)
    add $t3, $s0, $t2       # $t3 = dirección de A[2 * i]
    lw $t4, 0($t3)          # Carga A[2 * i] en $t4

    beq $t4, $zero, end_while  # Si A[2 * i] == 0, termina el bucle

    sub $t5, $t2, 4         # $t5 = (i * 2) * 4 - 4 (dirección de A[2 * i - 1])
    lw $t6, 0($t5)          # Carga A[2 * i - 1] en $t6
    add $t7, $t2, 4         # $t7 = (i * 2) * 4 + 4 (dirección de A[2 * i + 1])
    lw $t8, 0($t7)          # Carga A[2 * i + 1] en $t8

    add $t9, $t6, $t8       # $t9 = A[2 * i - 1] + A[2 * i + 1]

    sll $t10, $t0, 2        # $t10 = i * 4 (desplazamiento en bytes para A[i])
    add $t11, $s0, $t10     # $t11 = dirección de A[i]
    sw $t9, 0($t11)         # Guarda el resultado en A[i]

    addi $t0, $t0, 1        # i++
    j while                 # Salta al inicio del bucle

end_while:
    # Termina el programa
