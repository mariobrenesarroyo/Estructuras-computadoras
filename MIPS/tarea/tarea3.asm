.data
    prompt1: .asciiz "¡Bienvenido a la calculadora MRUA!\n\n"
    prompt2: .asciiz "Por favor ingrese los datos siguientes:\n"
    prompt3: .asciiz "Velocidad inicial (m/s): "
    prompt4: .asciiz "Velocidad final (m/s): "
    prompt5: .asciiz "Aceleracion (m/s²): "
    prompt6: .asciiz "Distancia (m): "
    prompt7: .asciiz "Tiempo (s): "
    prompt8: .asciiz "Ingrese una 'x' para el dato que desea calcular y una 'n' para el dato excluido: "
    result: .asciiz "\nResultados:\n"
    vel_init_msg: .asciiz "Velocidad inicial: "
    vel_final_msg: .asciiz "Velocidad final: "
    acceleration_msg: .asciiz "Aceleracion: "
    distance_msg: .asciiz "Distancia: "
    time_msg: .asciiz "Tiempo: "
    input_error: .asciiz "Error en la entrada. Por favor ingrese un valor correcto.\n"
    negative_error: .asciiz "ADVERTENCIA: NO PUEDE INGRESAR VALORES NEGATIVOS. INTÉNTELO DE NUEVO.\n"
    exclusion_error: .asciiz "ADVERTENCIA: NO PUEDE EXCLUIR LA VELOCIDAD INICIAL. INTÉNTELO DE NUEVO.\n"

    # Variables para almacenar los datos ingresados por el usuario
    Vi: .float 0.0
    Vf: .float 0.0
    a: .float 0.0
    d: .float 0.0
    t: .float 0.0
    exclusion_flag: .word 0  # Flag de exclusión (0 = no hay exclusión, 1 = exclusión incorrecta)

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

    # Pedir Velocidad Inicial
    li $v0, 4
    la $a0, prompt3
    syscall

    li $v0, 6  # Leer float
    syscall
    s.s $f0, Vi  # Guardar el valor de Vi

    # Verificar si el valor de Vi es negativo
    l.s $f1, Vi
    li.s $f2, 0.0  # 0.0 para comparación
    c.lt.s $f1, $f2
    bc1t input_error_check  # Si Vi es negativo, error

    # Pedir Velocidad Final
    li $v0, 4
    la $a0, prompt4
    syscall

    li $v0, 6  # Leer float
    syscall
    s.s $f0, Vf  # Guardar el valor de Vf

    # Verificar si el valor de Vf es negativo
    l.s $f1, Vf
    li.s $f2, 0.0  # 0.0 para comparación
    c.lt.s $f1, $f2
    bc1t input_error_check  # Si Vf es negativo, error

    # Pedir Aceleración
    li $v0, 4
    la $a0, prompt5
    syscall

    li $v0, 6  # Leer float
    syscall
    s.s $f0, a  # Guardar el valor de a

    # Verificar si el valor de a es negativo
    l.s $f1, a
    li.s $f2, 0.0  # 0.0 para comparación
    c.lt.s $f1, $f2
    bc1t input_error_check  # Si a es negativo, error

    # Pedir Distancia
    li $v0, 4
    la $a0, prompt6
    syscall

    li $v0, 6  # Leer float
    syscall
    s.s $f0, d  # Guardar el valor de d

    # Verificar si el valor de d es negativo
    l.s $f1, d
    li.s $f2, 0.0  # 0.0 para comparación
    c.lt.s $f1, $f2
    bc1t input_error_check  # Si d es negativo, error

    # Pedir Tiempo
    li $v0, 4
    la $a0, prompt7
    syscall

    li $v0, 6  # Leer float
    syscall
    s.s $f0, t  # Guardar el valor de t

    # Verificar si el valor de t es negativo
    l.s $f1, t
    li.s $f2, 0.0  # 0.0 para comparación
    c.lt.s $f1, $f2
    bc1t input_error_check  # Si t es negativo, error

    # Pedir el dato a calcular
    li $v0, 4
    la $a0, prompt8
    syscall

    li $v0, 12  # Leer carácter
    syscall
    move $t0, $v0  # Guardar la opción de cálculo ('x' o 'n')

    # Decidir qué calcular
    # Verificar combinaciones de exclusión incorrectas
    li $t1, 120  # ASCII de 'x'
    beq $t0, $t1, verificar_exclusion
    j calcular_dato

verificar_exclusion:
    # Comprobar si la exclusión es válida, no se puede excluir la Velocidad Inicial
    li $v0, 4
    la $a0, exclusion_error
    syscall
    j main  # Volver a pedir los datos

input_error_check:
    # Si hay un error de entrada, mostrar mensaje de error y volver a pedir los datos
    li $v0, 4
    la $a0, input_error
    syscall
    j main  # Volver a pedir los datos

calcular_dato:
    # Aquí vendrían los cálculos según el dato que falta (como se mostró en la primera parte)
    # El flujo de cálculos depende de qué variable esté faltando

    # Imprimir los resultados finales
    li $v0, 4
    la $a0, result
    syscall

    li $v0, 4
    la $a0, vel_init_msg
    syscall
    l.s $f0, Vi
    li $v0, 2  # Imprimir float
    syscall

    # Continuar con el resto de los resultados (Velocidad Final, Aceleración, Distancia, Tiempo)
    # ...
    
    j fin

fin:
    li $v0, 10  # Salir del programa
    syscall
