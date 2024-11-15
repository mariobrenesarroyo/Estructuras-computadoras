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
flagVi: .word 1    # 1 si es válido, 0 si es "n"
flagVf: .word 1
flagA: .word 1
flagD: .word 1
flagT: .word 1

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
    li $t2, 'n'
    beq $t0, $t1, calcular_vi
    beq $t0, $t2, ignorar_vi
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
    beq $t0, $t2, ignorar_vf
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
    beq $t0, $t2, ignorar_a
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
    beq $t0, $t2, ignorar_d
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
    beq $t0, $t2, ignorar_t
    li $v0, 5
    syscall
    sw $v0, t
    j realizar_calculo

# Manejar 'n' para ignorar variables
ignorar_vi:
    li $t0, 0
    sw $t0, flagVi
    j main

ignorar_vf:
    li $t0, 0
    sw $t0, flagVf
    j main

ignorar_a:
    li $t0, 0
    sw $t0, flagA
    j main

ignorar_d:
    li $t0, 0
    sw $t0, flagD
    j main

ignorar_t:
    li $t0, 0
    sw $t0, flagT
    j main

# Realizar cálculo basado en los valores ingresados
realizar_calculo:
    lw $t0, flagVi
    lw $t1, flagVf
    lw $t2, flagA
    lw $t3, flagD
    lw $t4, flagT

    # Verificar si solo una variable tiene 'x'
    add $t5, $t0, $t1
    add $t5, $t5, $t2
    add $t5, $t5, $t3
    add $t5, $t5, $t4
    li $t6, 4
    bne $t5, $t6, error_msg   # Si no hay exactamente una 'x', error

    # Calcular la variable desconocida
    bne $t0, 1, calcular_vi
    bne $t1, 1, calcular_vf
    bne $t2, 1, calcular_a
    bne $t3, 1, calcular_d
    bne $t4, 1, calcular_t

error_msg:
    la $a0, error
    li $v0, 4
    syscall
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
