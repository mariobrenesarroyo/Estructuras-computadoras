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
    # Verificar si el carácter es un dígito numérico (ASCII '0' a '9') o una letra 'n' o 'x'
    li $t1, 48                 # ASCII de '0' es 48
    li $t2, 57                 # ASCII de '9' es 57
    li $t3, 120                # ASCII de 'x' es 120
    li $t4, 110                # ASCII de 'n' es 110
    blt $t0, $t1, error        # Si el carácter es menor que '0', es un error
    bgt $t0, $t2, not_number   # Si el carácter es mayor que '9', no es un número

    # Convertir el carácter ASCII a un valor numérico
    sub $t0, $t0, $t1          # Restar 48 para obtener el valor numérico
    bgt $t0, $zero, pos_num    # Si es mayor que 0, es positivo
    blt $t0, $zero, neg_num    # Si es menor que 0, es negativo
    li $v0, 4                  # Si el número es 0
    la $a0, zero_msg
    syscall
    j end_process

not_number:
    # Verificar si es una letra 'x' o 'n'
    beq $t0, $t3, pos_num      # Si es 'x', es positivo
    beq $t0, $t4, neg_num      # Si es 'n', es negativo

    # Si no es ni número ni 'x' ni 'n', es un error
    li $v0, 4                  # Imprimir mensaje de error
    la $a0, error_msg
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
