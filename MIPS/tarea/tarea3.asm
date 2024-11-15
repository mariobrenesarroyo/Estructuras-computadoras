.data
    prompt1: .asciiz "¡Bienvenido a la calculadora MRUA!\n\n"
    prompt2: .asciiz "Por favor ingrese los datos siguientes:\n"
    prompt3: .asciiz "Velocidad inicial (m/s): "
    prompt4: .asciiz "Velocidad final (m/s): "
    prompt5: .asciiz "Aceleración (m/s²): "
    prompt6: .asciiz "Distancia (m): "
    prompt7: .asciiz "Tiempo (s): "

    # Variables para almacenar los datos ingresados por el usuario
    Vi: .float 0.0
    Vf: .float 0.0
    a: .float 0.0
    d: .float 0.0
    t: .float 0.0

.text
    .globl main

main:
    # Imprimir bienvenida
    li $v0, 4
    la $a0, prompt1
    syscall

    li $v0, 4
    la $a0, prompt2
    syscall

    # Pedir Velocidad Inicial (en punto flotante)
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 7  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, Vi  # Guardar el valor de Vi

    # Pedir Velocidad Final (en punto flotante)
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 7  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, Vf  # Guardar el valor de Vf

    # Pedir Aceleración (en punto flotante)
    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 7  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, a  # Guardar el valor de a

    # Pedir Distancia (en punto flotante)
    li $v0, 4
    la $a0, prompt6
    syscall

    li $v0, 7  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, d  # Guardar el valor de d

    # Pedir Tiempo (en punto flotante)
    li $v0, 4
    la $a0, prompt7
    syscall

    li $v0, 7  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, t  # Guardar el valor de t

    # Realiza los cálculos, por ejemplo, calcula la Velocidad Final
    # Fórmula para la Velocidad Final: Vf = Vi + a * t
    l.s $f1, Vi    # Cargar Vi
    l.s $f2, a     # Cargar a
    l.s $f3, t     # Cargar t

    mul.s $f4, $f2, $f3     # a * t
    add.s $f5, $f1, $f4     # Vi + (a * t)

    # Imprimir el resultado de la Velocidad Final
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 2  # Syscall para imprimir número de punto flotante
    mov.s $f12, $f5
    syscall

    # Finalizar el programa
    li $v0, 10
    syscall
