.data
A: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
.text
.globl main
main:
    la $s0, A          # Cargar la dirección base del arreglo A en $s0
    addi $t0, $zero, 1 # Inicializa $t0 con el valor 1

while:
    sll $t1, $t0, 1    # $t1 = 2 * i
    sll $t1, $t1, 2    # Multiplicamos por 4 para el desplazamiento en bytes: $t1 = 2 * i * 4
    add $t2, $s0, $t1  # $t2 = Dirección de A[2*i]

    lw $t3, 0($t2)     # Carga A[2*i] en $t3
    beq $t3, $zero, end_while # Si A[2*i] == 0, termina el bucle

    addi $t4, $t1, -4  # Calcula la dirección de A[2*i-1]
    add $t4, $t4, $s0  # Ajusta la dirección base: A[2*i-1]
    lw $t5, 0($t4)     # Carga A[2*i-1] en $t5

    addi $t6, $t1, 4   # Calcula la dirección de A[2*i+1]
    add $t6, $t6, $s0  # Ajusta la dirección base: A[2*i+1]
    lw $t7, 0($t6)     # Carga A[2*i+1] en $t7

    add $t8, $t5, $t7  # Suma A[2*i-1] + A[2*i+1]

    sll $t9, $t0, 2    # Calcula el desplazamiento para A[i], $t9 = i * 4
    add $t9, $s0, $t9  # $t9 = Dirección de A[i]
    sw $t8, 0($t9)     # Guarda el resultado en A[i]

    addi $t0, $t0, 1   # Incrementa i: i++

    j while            # Salta al inicio del bucle

end_while:
<<<<<<< HEAD
    # Termina el programa
=======
    # Fin del bucle

>>>>>>> origin/main
