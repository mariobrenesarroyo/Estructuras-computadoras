.data
    msg1: .asciiz "Ingrese (1, 2, 3, 4, 5) para calcular Vi, Vf, A, D, T: "
    msg2: .asciiz "Ingrese Velocidad inicial (Vi) en m/s: "
    msg3: .asciiz "Ingrese Velocidad final (Vf) en m/s: "
    msg4: .asciiz "Ingrese Aceleracion (A) en m/s^2: "
    msg5: .asciiz "Ingrese Distancia (D) en metros: "
    msg6: .asciiz "Ingrese Tiempo (T) en segundos: "
    msg_error: .asciiz "Error: Valor negativo o nulo no permitido.\n"

    Vi: .float 0.0
    Vf: .float 0.0
    A: .float 0.0
    D: .float 0.0
    T: .float 0.0

.text
    .globl main
main:
    # Mostrar mensaje para seleccionar cálculo
    li $v0, 4
    la $a0, msg1
    syscall

    # Leer opción
    li $v0, 5
    syscall
    move $t0, $v0 # Guardar la opción (1-5) en $t0

    # Dependiendo de la opción, proceder con la entrada de datos
    beq $t0, 1, opcion_1
    beq $t0, 2, opcion_2
    beq $t0, 3, opcion_3
    beq $t0, 4, opcion_4
    beq $t0, 5, opcion_5
    j main

# Opción 1: Calcular Vi
opcion_1:
    # Pedir valores de Vf, A y T
    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 6
    syscall
    move $f1, $f0 # Guardar Vf en $f1

    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 6
    syscall
    move $f2, $f0 # Guardar A en $f2

    li $v0, 4
    la $a0, msg6
    syscall
    li $v0, 6
    syscall
    move $f3, $f0 # Guardar T en $f3

    # Comprobar si los valores son negativos o cero
    blez.s $f1, error
    blez.s $f2, error
    blez.s $f3, error

    # Calcular Vi = Vf - A*T
    sub.s $f4, $f1, $f2 # $f4 = Vf - A
    mul.s $f4, $f4, $f3 # $f4 = (Vf - A) * T

    # Mostrar resultado
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 6
    move $f12, $f4 # Mostrar Vi
    syscall
    j main

# Opción 2: Calcular Vf
opcion_2:
    # Pedir valores de Vi, A y T
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 6
    syscall
    move $f1, $f0 # Guardar Vi en $f1

    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 6
    syscall
    move $f2, $f0 # Guardar A en $f2

    li $v0, 4
    la $a0, msg6
    syscall
    li $v0, 6
    syscall
    move $f3, $f0 # Guardar T en $f3

    # Comprobar si los valores son negativos o cero
    blez.s $f1, error
    blez.s $f2, error
    blez.s $f3, error

    # Calcular Vf = Vi + A*T
    mul.s $f4, $f2, $f3 # $f4 = A*T
    add.s $f5, $f1, $f4 # $f5 = Vi + (A*T)

    # Mostrar resultado
    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 6
    move $f12, $f5 # Mostrar Vf
    syscall
    j main

# Opción 3: Calcular A
opcion_3:
    # Pedir valores de Vi, Vf y T
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 6
    syscall
    move $f1, $f0 # Guardar Vi en $f1

    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 6
    syscall
    move $f2, $f0 # Guardar Vf en $f2

    li $v0, 4
    la $a0, msg6
    syscall
    li $v0, 6
    syscall
    move $f3, $f0 # Guardar T en $f3

    # Comprobar si los valores son negativos o cero
    blez.s $f1, error
    blez.s $f2, error
    blez.s $f3, error

    # Calcular A = (Vf - Vi) / T
    sub.s $f4, $f2, $f1 # $f4 = Vf - Vi
    div.s $f5, $f4, $f3 # $f5 = (Vf - Vi) / T

    # Mostrar resultado
    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 6
    move $f12, $f5 # Mostrar A
    syscall
    j main

# Opción 4: Calcular D
opcion_4:
    # Pedir valores de Vi, Vf y A
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 6
    syscall
    move $f1, $f0 # Guardar Vi en $f1

    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 6
    syscall
    move $f2, $f0 # Guardar Vf en $f2

    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 6
    syscall
    move $f3, $f0 # Guardar A en $f3

    # Comprobar si los valores son negativos o cero
    blez.s $f1, error
    blez.s $f2, error
    blez.s $f3, error

    # Calcular D = (Vf^2 - Vi^2) / (2 * A)
    mul.s $f4, $f1, $f1 # $f4 = Vi^2
    mul.s $f5, $f2, $f2 # $f5 = Vf^2
    sub.s $f6, $f5, $f4 # $f6 = Vf^2 - Vi^2
    mul.s $f7, $f3, $f3 # $f7 = 2 * A
    div.s $f8, $f6, $f7 # $f8 = (Vf^2 - Vi^2) / (2 * A)

    # Mostrar resultado
    li $v0, 4
    la $a0, msg5
    syscall
    li $v0, 6
    move $f12, $f8 # Mostrar D
    syscall
    j main

# Opción 5: Calcular T
opcion_5:
    # Pedir valores de Vi, Vf y A
    li $v0, 4
    la $a0, msg2
    syscall
    li $v0, 6
    syscall
    move $f1, $f0 # Guardar Vi en $f1

    li $v0, 4
    la $a0, msg3
    syscall
    li $v0, 6
    syscall
    move $f2, $f0 # Guardar Vf en $f2

    li $v0, 4
    la $a0, msg4
    syscall
    li $v0, 6
    syscall
    move $f3, $f0 # Guardar A en $f3

    # Comprobar si los valores son negativos o cero
    blez.s $f1, error
    blez.s $f2, error
    blez.s $f3, error

    # Calcular T = (Vf - Vi) / A
    sub.s $f4, $f2, $f1 # $f4 = Vf - Vi
    div.s $f5, $f4, $f3 # $f5 = (Vf - Vi) / A

    # Mostrar resultado
    li $v0, 4
    la $a0, msg6
    syscall
    li $v0, 6
    move $f12, $f5 # Mostrar T
    syscall
    j main

# Manejo de error
error:
    li $v0, 4
    la $a0, msg_error
    syscall
    j main
