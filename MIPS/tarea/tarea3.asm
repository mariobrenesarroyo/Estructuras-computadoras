.data
    prompt1: .asciiz "¡Bienvenido a la calculadora MRUA!\nPor favor ingrese los datos siguientes:\n"
    prompt2: .asciiz "\n(ingrese una \"x\" para el dato que desea calcular y una \"n\" para el dato excluido)\n"
    prompt3: .asciiz "\nVelocidad inicial (m/s): "
    prompt4: .asciiz "\nVelocidad final (m/s): "
    prompt5: .asciiz "\nAceleración (m/s²): "
    prompt6: .asciiz "\nDistancia (m): "
    prompt7: .asciiz "\nTiempo (s): "
    result1: .asciiz "\nResultados:\n"

.text
.globl main

main:
    # Imprimir mensaje de bienvenida
    li $v0, 4
    la $a0, prompt1
    syscall

    # Leer entrada del usuario para Vi y Vf
    li $v0, 8
    la $a0, prompt3
    syscall
    li $v0, 12
    syscall
    move $s0, $v0      # Guardar Velocidad inicial en $s0

    li $v0, 8
    la $a0, prompt4
    syscall
    li $v0, 12
    syscall
    move $s1, $v0      # Guardar Velocidad final en $s1

    # Leer entrada del usuario para a y d
    li $v0, 8
    la $a0, prompt5
    syscall
    li $v0, 12
    syscall
    move $s2, $v0      # Guardar Aceleración en $s2

    li $v0, 8
    la $a0, prompt6
    syscall
    li $v0, 12
    syscall
    move $s3, $v0      # Guardar Distancia en $s3

    # Leer entrada del usuario para t
    li $v0, 8
    la $a0, prompt7
    syscall
    li $v0, 12
    syscall
    move $s4, $v0      # Guardar Tiempo en $s4

    # Leer cual se calculará y cual se excluirá
    li $v0, 8
    la $a0, prompt2
    syscall
    li $v0, 12
    syscall
    move $s5, $v0      # Guardar entrada del usuario en $s5

    # Calcular variable omitida (asumiendo que se calcula Vf)
    li $t0, 34         # Vf = 34 m/s
    move $s6, $t0      # Guardar Vf en $s6

    # Calcular variable que se calculará (asumiendo que se calcula d)
    li $t0, 25          # d = Vi * t + (1/2) * a * t^2
    lw $t1, 16($s0)     # Convertir Vi a entero
    lw $t2, 16($s4)     # Convertir t a entero
    mul $t3, $t1, $t2   # Vi * t
    li $t4, 1           # 1/2
    mul $t5, $t4, $t2   # 1/2 * t
    mul $t6, $t2, $t2   # t^2
    mul $t7, $t5, $t6   # (1/2) * t^2
    add $t8, $t3, $t7   # Sumar los productos
    add $t9, $t8, $t2   # Sumar Vi * t + (1/2) * a * t^2
    sw $t9, 16($s3)     # Almacenar resultado en d

    # Imprimir resultados
    li $v0, 4
    la $a0, result1
    syscall

    # Imprimir Velocidad inicial
    li $v0, 4
    la $a0, prompt3
    syscall
    li $v0, 35
    lw $a0, 16($s0)
    syscall

    # Imprimir Distancia
    li $v0, 4
    la $a0, prompt6
    syscall
    li $v0, 36
    lw $a0, 16($s3)
    syscall

    # Terminar el programa
    li $v0, 10
    syscall
