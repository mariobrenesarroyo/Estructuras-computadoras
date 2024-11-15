.data
prompt_vi:   .asciiz "Introduce Vi: "
prompt_vf:   .asciiz "Introduce Vf: "
prompt_a:    .asciiz "Introduce A: "
prompt_d:    .asciiz "Introduce D: "
prompt_t:    .asciiz "Introduce t: "
error_msg:  .asciiz "Error: No es un numero valido.\n"
pos_msg:    .asciiz " es positivo\n"
neg_msg:    .asciiz " es negativo\n"
zero_msg:   .asciiz " es cero\n"
x:          .asciiz "x"
n:          .asciiz "n"

.text
.globl main

main:
    # Pedir Vi
    li $v0, 4                  # Imprimir mensaje
    la $a0, prompt_vi
    syscall
    li $v0, 12                 # Leer un carácter ASCII
    syscall
    move $t0, $v0              # Guardar el valor en $t0
    jal process_input          # Procesar la entrada

    # Pedir Vf
    li $v0, 4                  # Imprimir mensaje
    la $a0, prompt_vf
    syscall
    li $v0, 12                 # Leer un carácter ASCII
    syscall
    move $t0, $v0              # Guardar el valor en $t0
    jal process_input          # Procesar la entrada

    # Pedir A
    li $v0, 4                  # Imprimir mensaje
    la $a0, prompt_a
    syscall
    li $v0, 12                 # Leer un carácter ASCII
    syscall
    move $t0, $v0              # Guardar el valor en $t0
    jal process_input          # Procesar la entrada

    # Pedir D
    li $v0, 4                  # Imprimir mensaje
    la $a0, prompt_d
    syscall
    li $v0, 12                 # Leer un carácter ASCII
    syscall
    move $t0, $v0              # Guardar el valor en $t0
    jal process_input          # Procesar la entrada

    # Pedir t
    li $v0, 4                  # Imprimir mensaje
    la $a0, prompt_t
    syscall
    li $v0, 12                 # Leer un carácter ASCII
    syscall
    move $t0, $v0              # Guardar el valor en $t0
    jal process_input          # Procesar la entrada

    # Finalizar programa
    li $v0, 10                 # Salir
    syscall

# Subrutina para procesar cada entrada
process_input:
    # Verificar si el carácter es un dígito numérico (ASCII '0' a '9')
    li $t1, 48                 # ASCII de '0' es 48
    li $t2, 57                 # ASCII de '9' es 57
    blt $t0, $t1, error        # Si el carácter es menor que '0', es un error
    bgt $t0, $t2, error        # Si el carácter es mayor que '9', es un error

    # Convertir el carácter ASCII a un valor numérico
    sub $t0, $t0, $t1          # Restar 48 para obtener el valor numérico

    # Verificar si el número es positivo, negativo o cero
    li $t3, 0                  # Cargar 0 en $t3 (para comparación)
    bgt $t0, $t3, pos_num      # Si el número es mayor que 0
    blt $t0, $t3, neg_num      # Si el número es menor que 0
    li $v0, 4                  # Si el número es 0
    la $a0, zero_msg
    syscall
    j end_process

pos_num:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j end_process

neg_num:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

end_process:
    jr $ra                     # Regresar a la función principal

error:
    li $v0, 4                  # Imprimir mensaje de error
    la $a0, error_msg
    syscall
    jr $ra                     # Regresar a la función principal
