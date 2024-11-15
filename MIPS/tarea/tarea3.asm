.data
promptVi: .asciiz "Velocidad inicial (Vi) (m/s): "   # Mensaje para solicitar Vi
promptVf: .asciiz "Velocidad final (Vf) (m/s): "     # Mensaje para solicitar Vf
promptA: .asciiz "Aceleracion (a) (m/s^2): "         # Mensaje para solicitar a
promptD: .asciiz "Distancia (d) (m): "               # Mensaje para solicitar d
promptT: .asciiz "Tiempo (t) (s): "                  # Mensaje para solicitar t
msgInvalid: .asciiz "Valor invalido, intente de nuevo.\n"  # Mensaje para valores inválidos
msgResult: .asciiz "Resultado: "                     # Mensaje para mostrar resultado
Vi: .word 0                                          # Variable para almacenar Vi
Vf: .word 0                                          # Variable para almacenar Vf
a: .word 0                                           # Variable para almacenar a
d: .word 0                                           # Variable para almacenar d
t: .word 0                                           # Variable para almacenar t

.text
main:
    # Pedir Velocidad inicial (Vi)
    la $a0, promptVi          # Cargar dirección del mensaje de Vi en $a0
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    li $v0, 5                 # Código de syscall para leer entero
    syscall                   # Llamar al sistema para leer
    sw $v0, Vi                # Guardar el valor de Vi

    # Pedir Velocidad final (Vf)
    la $a0, promptVf          # Cargar dirección del mensaje de Vf en $a0
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    li $v0, 5                 # Código de syscall para leer entero
    syscall                   # Llamar al sistema para leer
    sw $v0, Vf                # Guardar el valor de Vf

    # Pedir Aceleracion (a)
    la $a0, promptA           # Cargar dirección del mensaje de a en $a0
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    li $v0, 5                 # Código de syscall para leer entero
    syscall                   # Llamar al sistema para leer
    sw $v0, a                 # Guardar el valor de a

    # Pedir Distancia (d)
    la $a0, promptD           # Cargar dirección del mensaje de d en $a0
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    li $v0, 5                 # Código de syscall para leer entero
    syscall                   # Llamar al sistema para leer
    sw $v0, d                 # Guardar el valor de d

    # Pedir Tiempo (t)
    la $a0, promptT           # Cargar dirección del mensaje de t en $a0
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    li $v0, 5                 # Código de syscall para leer entero
    syscall                   # Llamar al sistema para leer
    sw $v0, t                 # Guardar el valor de t

    # Validación de entradas (simple)
    lw $t0, Vi                # Cargar Vi en $t0
    blez $t0, invalid         # Si Vi <= 0, saltar a invalid
    lw $t0, Vf                # Cargar Vf en $t0
    blez $t0, invalid         # Si Vf <= 0, saltar a invalid
    lw $t0, a                 # Cargar a en $t0
    blez $t0, invalid         # Si a <= 0, saltar a invalid
    lw $t0, d                 # Cargar d en $t0
    blez $t0, invalid         # Si d <= 0, saltar a invalid
    lw $t0, t                 # Cargar t en $t0
    blez $t0, invalid         # Si t <= 0, saltar a invalid

    # Cálculo de distancia (simplificado a enteros)
    lw $t1, Vi                # Cargar Vi en $t1
    lw $t2, t                 # Cargar t en $t2
    mul $t3, $t1, $t2         # t3 = Vi * t
    lw $t1, a                 # Cargar a en $t1
    mul $t4, $t2, $t2         # t4 = t^2
    div $t4, $t4, 2           # t4 = t^2 / 2
    mul $t4, $t4, $t1         # t4 = a * t^2 / 2
    add $t3, $t3, $t4         # t3 = Vi * t + (a * t^2 / 2)

    # Imprimir resultado
    la $a0, msgResult         # Cargar dirección de mensaje de resultado
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    move $a0, $t3             # Colocar el resultado en $a0 para imprimir
    li $v0, 1                 # Código de syscall para imprimir entero
    syscall                   # Llamar al sistema para imprimir el resultado

    j end                     # Saltar a fin

invalid:
    la $a0, msgInvalid        # Cargar dirección de mensaje de error
    li $v0, 4                 # Código de syscall para imprimir cadena
    syscall                   # Llamar al sistema para imprimir
    j main                    # Volver al inicio para reiniciar

end:
    li $v0, 10                # Código de syscall para salir del programa
    syscall                   # Llamar al sistema para terminar
