.data
prompt_vi:   .asciiz "Introduce Vi (velocidad inicial): "
prompt_vf:   .asciiz "Introduce Vf (velocidad final): "
prompt_a:    .asciiz "Introduce A (aceleracion): "
prompt_d:    .asciiz "Introduce D (distancia): "
prompt_t:    .asciiz "Introduce T (tiempo): "
pos_msg:     .asciiz " es positivo\n"
neg_msg:     .asciiz " es negativo\n"
zero_msg:    .asciiz " es cero\n"
x:           .asciiz "x"
n:           .asciiz "n"

.text
.globl main

main:
    # Pedir Vi
    li $v0, 4                  # Imprimir cadena
    la $a0, prompt_vi
    syscall

    li $v0, 5                  # Leer entero
    syscall
    move $t0, $v0              # Guardar Vi en $t0

    # Pedir Vf
    li $v0, 4                  # Imprimir cadena
    la $a0, prompt_vf
    syscall

    li $v0, 5                  # Leer entero
    syscall
    move $t1, $v0              # Guardar Vf en $t1

    # Pedir A
    li $v0, 4                  # Imprimir cadena
    la $a0, prompt_a
    syscall

    li $v0, 5                  # Leer entero
    syscall
    move $t2, $v0              # Guardar A en $t2

    # Pedir D
    li $v0, 4                  # Imprimir cadena
    la $a0, prompt_d
    syscall

    li $v0, 5                  # Leer entero
    syscall
    move $t3, $v0              # Guardar D en $t3

    # Pedir T
    li $v0, 4                  # Imprimir cadena
    la $a0, prompt_t
    syscall

    li $v0, 5                  # Leer entero
    syscall
    move $t4, $v0              # Guardar T en $t4

    # Verificar Vi
    li $t5, 0                  # Cargar 0 en $t5 (para comparación)
    bgt $t0, $t5, vi_pos       # Si Vi > 0, va a vi_pos
    blt $t0, $t5, vi_neg       # Si Vi < 0, va a vi_neg
    li $v0, 4                  # Si Vi == 0
    la $a0, zero_msg
    syscall
    j next_vi

vi_pos:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j next_vi

vi_neg:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

next_vi:
    # Verificar Vf
    bgt $t1, $t5, vf_pos
    blt $t1, $t5, vf_neg
    li $v0, 4
    la $a0, zero_msg
    syscall
    j next_vf

vf_pos:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j next_vf

vf_neg:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

next_vf:
    # Verificar A
    bgt $t2, $t5, a_pos
    blt $t2, $t5, a_neg
    li $v0, 4
    la $a0, zero_msg
    syscall
    j next_a

a_pos:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j next_a

a_neg:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

next_a:
    # Verificar D
    bgt $t3, $t5, d_pos
    blt $t3, $t5, d_neg
    li $v0, 4
    la $a0, zero_msg
    syscall
    j next_d

d_pos:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j next_d

d_neg:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

next_d:
    # Verificar T
    bgt $t4, $t5, t_pos
    blt $t4, $t5, t_neg
    li $v0, 4
    la $a0, zero_msg
    syscall
    j end_program

t_pos:
    li $v0, 4
    la $a0, pos_msg
    syscall
    li $v0, 4                  # Imprimir "x"
    la $a0, x
    syscall
    j end_program

t_neg:
    li $v0, 4
    la $a0, neg_msg
    syscall
    li $v0, 4                  # Imprimir "n"
    la $a0, n
    syscall

end_program:
    li $v0, 10         # Salir del programa
    syscall
