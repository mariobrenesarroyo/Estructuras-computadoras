.data
A: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32

.text
.globl main
main:
    la $s0, A          # Cargar la dirección base del arreglo A en $s0
    addi $t0, $zero, 1 # Inicializa $t0 con el valor 1
    addi $t1, $zero, 129 # Inicializa $t1 con el valor 129

for:
    bge $t0, $t1, end_for  # Si i es mayor o igual a 129, termina el bucle

    sll $t2, $t0, 2       # $t2 = i * 4 (desplazamiento en bytes)
    sub $t3, $t2, 4       # $t3 = (i-1) * 4
    add $t4, $s0, $t2     # $t4 = dirección de A[i]
    add $t5, $s0, $t3     # $t5 = dirección de A[i-1]
    lw $t6, 4($t4)        # $t6 = A[i+1]
    lw $t7, 0($t5)        # $t7 = A[i-1]
    add $t8, $t7, $t6     # $t8 = A[i-1] + A[i+1]
    sw $t8, 0($t4)        # Guarda el resultado en A[i]

    sll $t0, $t0, 1       # i = i * 2
    j for                 # Salta al inicio del bucle

end_for:
    # Termina el programa
    li $v0, 10
    syscall
