.data
promptVi: .asciiz "Velocidad inicial (m/s) o 'x' si desconocida o 'n' si no disponible: "
promptVf: .asciiz "Velocidad final (m/s) o 'x' si desconocida o 'n' si no disponible: "
promptA: .asciiz "Aceleracion (m/s^2) o 'x' si desconocida o 'n' si no disponible: "
promptD: .asciiz "Distancia (m) o 'x' si desconocida o 'n' si no disponible: "
promptT: .asciiz "Tiempo (s) o 'x' si desconocido o 'n' si no disponible: "
msgVi: .asciiz "Velocidad inicial calculada: "
msgVf: .asciiz "Velocidad final calculada: "
msgA: .asciiz "Aceleracion calculada: "
msgD: .asciiz "Distancia calculada: "
msgT: .asciiz "Tiempo calculado: "
error: .asciiz "Error: No se puede calcular con los valores ingresados."
buffer: .space 2
Vi: .word 0
Vf: .word 0
a: .word 0
d: .word 0
t: .word 0
flagVi: .word 1
flagVf: .word 1
flagA: .word 1
flagD: .word 1
flagT: .word 1

.text
.global start

start:
    jal main

macro_leer_variable prompt, variable:
    la $a0, prompt
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t0, buffer
    beqz $t0, calcular_ignorar
    beq $t0, 'n', ignorar_variable
    li $v0, 5
    syscall
    sw $v0, variable
    return

macro_calcular variable:
    lw $t0, flagVi
    lw $t1, flagVf
    lw $t2, flagA
    lw $t3, flagD
    lw $t4, flagT
    
    li $t5, 4
    add $t6, $t0, $t1
    add $t6, $t6, $t2
    add $t6, $t6, $t3
    add $t6, $t6, $t4
    li $t7, 4
    sub $t6, $t6, $t7
    beqz $t6, error_msg

    bnez $t0, calcular_vi
    bnez $t1, calcular_vf
    bnez $t2, calcular_a
    bnez $t3, calcular_d
    bnez $t4, calcular_t

manejar_error:
    la $a0, error
    li $v0, 4
    syscall
    j end

calcular_vi:
    # Vi = Vf - a * t
    lw $t1, Vf
    lw $t2, a
    lw $t3, t
    mul $t2, $t2, $t3
    sub $t0, $t1, $t2
    la $a0, msgVi
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    j end

calcular_vf:
    # Vf = Vi + a * t
    lw $t1, Vi
    lw $t2, a
    lw $t3, t
    mul $t2, $t2, $t3
    add $t0, $t1, $t2
    la $a0, msgVf
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    j end

calcular_a:
    # a = (Vf - Vi) / t
    lw $t1, Vf
    lw $t2, Vi
    sub $t1, $t1, $t2
    lw $t3, t
    div $t1, $t3
    mflo $t0
    la $a0, msgA
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    j end

calcular_d:
    # d = Vi * t + (1/2) * a * t^2
    lw $t1, Vi
    lw $t2, t
    mul $t1, $t1, $t2
    lw $t3, a
    mul $t3, $t3, $t2
    srl $t3, $t3, 1
    add $t0, $t1, $t3
    la $a0, msgD
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    j end

calcular_t:
    # t = (Vf - Vi) / a
    lw $t1, Vf
    lw $t2, Vi
    sub $t1, $t1, $t2
    lw $t3, a
    div $t1, $t3
    mflo $t0
    la $a0, msgT
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    j end

main:
    macro_leer_variable promptVi, Vi
    macro_leer_variable promptVf, Vf
    macro_leer_variable promptA, a
    macro_leer_variable promptD, d
    macro_leer_variable promptT, t
    j realizar_calculo

realizar_calculo:
    jal macro_calcular

end:
    li $v0, 10
    syscall
