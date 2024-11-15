.data
promptVi: .asciiz "Velocidad inicial (m/s) o 'x' si desconocida: "
promptVf: .asciiz "Velocidad final (m/s) o 'x' si desconocida: "
promptA: .asciiz "Aceleracion (m/s^2) o 'x' si desconocida: "
promptD: .asciiz "Distancia (m) o 'x' si desconocida: "
promptT: .asciiz "Tiempo (s) o 'x' si desconocido: "
msgVi: .asciiz "Velocidad inicial calculada: "
msgVf: .asciiz "Velocidad final calculada: "
msgA: .asciiz "Aceleracion calculada: "
msgD: .asciiz "Distancia calculada: "
msgT: .asciiz "Tiempo calculado: "
buffer: .space 2
Vi: .word 0
Vf: .word 0
a: .word 0
d: .word 0
t: .word 0

.text
main:
    # Leer Vi
    la $a0, promptVi
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t0, buffer
    li $t1, 'x'
    beq $t0, $t1, calcular_vi
    li $v0, 5
    syscall
    sw $v0, Vi

    # Leer Vf
    la $a0, promptVf
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t0, buffer
    beq $t0, $t1, calcular_vf
    li $v0, 5
    syscall
    sw $v0, Vf

    # Leer a
    la $a0, promptA
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t0, buffer
    beq $t0, $t1, calcular_a
    li $v0, 5
    syscall
    sw $v0, a

    # Leer d
    la $a0, promptD
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t0, buffer
    beq $t0, $t1, calcular_d
    li $v0, 5
    syscall
    sw $v0, d

    # Leer t
    la $a0, promptT
    li $v0, 4
    syscall
    li $v0, 8
    la $a1, buffer
    li $a2, 2
    syscall
    lb $t0, buffer
    beq $t0, $t1, calcular_t
    li $v0, 5
    syscall
    sw $v0, t
    j end

calcular_vi:
    # Vi = Vf - a * t
    lw $t1, Vf
    lw $t2, a
    lw $t3, t
    mul $t2, $t2, $t3        # a * t
    sub $t0, $t1, $t2         # Vi = Vf - a * t
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
    mul $t2, $t2, $t3        # a * t
    add $t0, $t1, $t2        # Vf = Vi + a * t
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
    sub $t1, $t1, $t2        # Vf - Vi
    lw $t3, t
    div $t1, $t3             # (Vf - Vi) / t
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
    mul $t1, $t1, $t2        # Vi * t
    lw $t3, a
    mul $t3, $t3, $t2        # a * t
    mul $t3, $t3, $t2        # a * t^2
    srl $t3, $t3, 1          # (1/2) * a * t^2
    add $t0, $t1, $t3        # d = Vi * t + (1/2) * a * t^2
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
    sub $t1, $t1, $t2        # Vf - Vi
    lw $t3, a
    div $t1, $t3             # (Vf - Vi) / a
    mflo $t0
    la $a0, msgT
    li $v0, 4
    syscall
    move $a0, $t0
    li $v0, 1
    syscall
    j end

end:
    li $v0, 10
    syscall
