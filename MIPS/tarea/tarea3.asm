.data
prompt:     .asciiz "Introduce un numero en formato ASCII: "
pos_msg:    .asciiz " es positivo\n"
neg_msg:    .asciiz " es negativo\n"
zero_msg:   .asciiz " es cero\n"
x:          .asciiz "x"
n:          .asciiz "n"

.text
.globl main

main:
    # Imprimir mensaje de introducción
    li $v0, 4                  # Imprimir cadena
    la $a0, prompt
    syscall

    # Leer un carácter ASCII (número en forma de texto)
    li $v0, 12                 # Leer un carácter ASCII
    syscall
    move $t0, $v0              # Guardar el carácter en $t0

    # Convertir el carácter ASCII a un valor numérico
    li $t1, 48                 # ASCII de '0' es 48
    sub $t0, $t0, $t1          # Restar 48 para obtener el valor numérico

    # Verificar si el número es positivo, negativo o cero
    li $t2, 0                  # Cargar 0 en $t2 (para comparación)
    bgt $t0, $t2, pos_num      # Si el número es mayor que 0
    blt $t0, $t2, neg_num      # Si el número es menor que 0
    li $v0, 4                  # Si el número es 0
    la $a0, zero_msg
    syscall
    j end_program

pos_num:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j end_program

neg_num:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

end_program:
    li $v0, 10         # Salir del programa
    syscall
