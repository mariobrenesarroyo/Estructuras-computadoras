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
    
    # Variables para las opciones "x" y "n"
    optionVi: .asciiz "n"
    optionVf: .asciiz "n"
    optionA: .asciiz "n"
    optionD: .asciiz "n"
    optionT: .asciiz "n"

    tempInput: .asciiz "Temp input buffer\n"

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

    # Leer la entrada para la Velocidad Inicial (Vi)
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 8  # Syscall para leer una cadena de caracteres
    la $a0, tempInput
    li $a1, 20  # Leer hasta 20 caracteres
    syscall
    la $t0, optionVi   # Almacenar la opción de la Velocidad inicial
    lb $t1, tempInput  # Leer la primera letra de la entrada

    beq $t1, 120, skipVi  # Si la entrada es "x" (ASCII 120), saltar la lectura de la Velocidad inicial
    beq $t1, 110, skipVi  # Si la entrada es "n" (ASCII 110), saltar la lectura de la Velocidad inicial

    # Leer el valor de la Velocidad Inicial (si no es "x" ni "n")
    li $v0, 6  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, Vi  # Guardar el valor de Vi

skipVi:
    # Leer la entrada para la Velocidad Final (Vf)
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 8  # Syscall para leer una cadena de caracteres
    la $a0, tempInput
    li $a1, 20  # Leer hasta 20 caracteres
    syscall
    la $t0, optionVf   # Almacenar la opción de la Velocidad final
    lb $t1, tempInput  # Leer la primera letra de la entrada

    beq $t1, 120, skipVf  # Si la entrada es "x" (ASCII 120), saltar la lectura de la Velocidad final
    beq $t1, 110, skipVf  # Si la entrada es "n" (ASCII 110), saltar la lectura de la Velocidad final

    # Leer el valor de la Velocidad Final (si no es "x" ni "n")
    li $v0, 6  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, Vf  # Guardar el valor de Vf

skipVf:
    # Leer la entrada para la Aceleración (a)
    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 8  # Syscall para leer una cadena de caracteres
    la $a0, tempInput
    li $a1, 20  # Leer hasta 20 caracteres
    syscall
    la $t0, optionA   # Almacenar la opción de Aceleración
    lb $t1, tempInput  # Leer la primera letra de la entrada

    beq $t1, 120, skipA  # Si la entrada es "x" (ASCII 120), saltar la lectura de la Aceleración
    beq $t1, 110, skipA  # Si la entrada es "n" (ASCII 110), saltar la lectura de la Aceleración

    # Leer el valor de la Aceleración (si no es "x" ni "n")
    li $v0, 6  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, a  # Guardar el valor de a

skipA:
    # Leer la entrada para la Distancia (d)
    li $v0, 4
    la $a0, prompt6
    syscall

    li $v0, 8  # Syscall para leer una cadena de caracteres
    la $a0, tempInput
    li $a1, 20  # Leer hasta 20 caracteres
    syscall
    la $t0, optionD   # Almacenar la opción de Distancia
    lb $t1, tempInput  # Leer la primera letra de la entrada

    beq $t1, 120, skipD  # Si la entrada es "x" (ASCII 120), saltar la lectura de la Distancia
    beq $t1, 110, skipD  # Si la entrada es "n" (ASCII 110), saltar la lectura de la Distancia

    # Leer el valor de la Distancia (si no es "x" ni "n")
    li $v0, 6  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, d  # Guardar el valor de d

skipD:
    # Leer la entrada para el Tiempo (t)
    li $v0, 4
    la $a0, prompt7
    syscall

    li $v0, 8  # Syscall para leer una cadena de caracteres
    la $a0, tempInput
    li $a1, 20  # Leer hasta 20 caracteres
    syscall
    la $t0, optionT   # Almacenar la opción de Tiempo
    lb $t1, tempInput  # Leer la primera letra de la entrada

    beq $t1, 120, skipT  # Si la entrada es "x" (ASCII 120), saltar la lectura del Tiempo
    beq $t1, 110, skipT  # Si la entrada es "n" (ASCII 110), saltar la lectura del Tiempo

    # Leer el valor de Tiempo (si no es "x" ni "n")
    li $v0, 6  # Syscall para leer un número de punto flotante
    syscall
    s.s $f0, t  # Guardar el valor de t

skipT:
    # Aquí calcularemos el valor faltante según las opciones "x" y "n"

    # Finalizar el programa
    li $v0, 10
    syscall
