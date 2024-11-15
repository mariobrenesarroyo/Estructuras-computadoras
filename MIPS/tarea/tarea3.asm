.data
prompt: .asciiz "¡Bienvenido a la calculadora MRUA!\n\nPor favor ingrese los datos siguientes datos:\n(ingrese una 'x' para el dato que desea calcular y una 'n' para el dato excluido)\n\n"
velocidad_inicial_prompt: .asciiz "Velocidad inicial (m/s): "
velocidad_final_prompt: .asciiz "Velocidad final (m/s): "
aceleracion_prompt: .asciiz "Aceleración (m/s²): "
distancia_prompt: .asciiz "Distancia (m): "
tiempo_prompt: .asciiz "Tiempo (s): "
error_valores_negativos: .asciiz "ADVERTENCIA: NO PUEDE INGRESAR VALORES NEGATIVOS. INTÉNTELO DE NUEVO.\n"

# Variables
vel_inicial: .float 0.0
vel_final: .float 0.0
aceleracion: .float 0.0
distancia: .float 0.0
tiempo: .float 0.0
dato_excluido: .byte 0

.text
.globl main

main:
    # Bienvenida
    li $v0, 4
    la $a0, prompt
    syscall

    # Entrada para velocidad inicial
    li $v0, 4
    la $a0, velocidad_inicial_prompt
    syscall
    li $v0, 12          # lee carácter (para 'n' o 'x')
    syscall
    move $t0, $v0       # guarda el carácter
    sb $t0, dato_excluido

    # Validación para asegurarse que no se excluya la velocidad inicial
    lb $t0, dato_excluido
    li $t1, 110          # valor ASCII de 'n'
    beq $t0, $t1, error_no_excluir_vel_inicial

    # Entrada para velocidad final
    li $v0, 4
    la $a0, velocidad_final_prompt
    syscall
    li $v0, 6           # lee flotante
    syscall
    swc1 $f0, vel_final

    # Entrada para aceleración
    li $v0, 4
    la $a0, aceleracion_prompt
    syscall
    li $v0, 6           # lee flotante
    syscall
    swc1 $f0, aceleracion

    # Entrada para distancia
    li $v0, 4
    la $a0, distancia_prompt
    syscall
    li $v0, 6           # lee flotante
    syscall
    swc1 $f0, distancia

    # Entrada para tiempo
    li $v0, 4
    la $a0, tiempo_prompt
    syscall
    li $v0, 6           # lee flotante
    syscall
    swc1 $f0, tiempo

    # Calcular el dato faltante
    lb $t0, dato_excluido
    li $t1, 120          # valor ASCII de 'x'
    beq $t0, $t1, calcular_velocidad_inicial
    li $t1, 110          # valor ASCII de 'n'
    beq $t0, $t1, calcular_tiempo

calcular_velocidad_inicial:
    # Fórmula para calcular la velocidad inicial: Vi = Vf - a * t
    lwc1 $f0, vel_final    # carga Vf
    lwc1 $f1, aceleracion  # carga a
    lwc1 $f2, tiempo       # carga t
    mul.s $f3, $f1, $f2    # a * t
    sub.s $f4, $f0, $f3    # Vf - a * t
    swc1 $f4, vel_inicial  # almacena el resultado en Vi

    # Imprimir el resultado
    li $v0, 4
    la $a0, "Resultados:\n"
    syscall

    li $v0, 4
    la $a0, "Velocidad inicial: "
    syscall
    li $v0, 2           # imprime flotante
    lwc1 $f12, vel_inicial
    syscall
    li $v0, 4
    la $a0, " m/s\n"
    syscall
    j fin

calcular_tiempo:
    # Fórmula para calcular el tiempo: t = (Vf - Vi) / a
    lwc1 $f0, vel_final    # carga Vf
    lwc1 $f1, vel_inicial  # carga Vi
    sub.s $f2, $f0, $f1    # Vf - Vi
    lwc1 $f3, aceleracion  # carga a
    div.s $f4, $f2, $f3    # (Vf - Vi) / a
    swc1 $f4, tiempo       # almacena el resultado en t

    # Imprimir el resultado
    li $v0, 4
    la $a0, "Resultados:\n"
    syscall

    li $v0, 4
    la $a0, "Tiempo: "
    syscall
    li $v0, 2           # imprime flotante
    lwc1 $f12, tiempo
    syscall
    li $v0, 4
    la $a0, " s\n"
    syscall
    j fin

error_no_excluir_vel_inicial:
    li $v0, 4
    la $a0, "ADVERTENCIA: NO PUEDE EXCLUIR LA VELOCIDAD INICIAL. INTÉNTELO DE NUEVO.\n"
    syscall
    j main

fin:
    # Salida
    li $v0, 10
    syscall
