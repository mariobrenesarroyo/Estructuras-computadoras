.data
# Mensajes
bienvenida: .asciiz "Bienvenido, ingrese valores x, n, o numeros entre 0 y 100:\n"
ingrese:    .asciiz "Ingrese valor "
error:      .asciiz "Error: el valor "
es_n:       .asciiz " es n y no se puede realizar el cálculo.\n"
exitoso:    .asciiz "Éxito, el cálculo de A es: "
input:      .space 20            # Espacio para almacenar cada entrada
newline:    .asciiz "\n"

# Valores predefinidos
x: .asciiz "x"                   # Representación de 'x'
n: .asciiz "n"                   # Representación de 'n'

.text
main:
    # Mostrar mensaje de bienvenida
    li $v0, 4
    la $a0, bienvenida
    syscall

    # Pedir valores al usuario
    la $t0, input               # Dirección para guardar las entradas
    jal pedir_valores

    # Verificar si A es 'x'
    la $t1, input               # Dirección del valor A (primer valor)
    lb $t2, 0($t1)             # Cargar el carácter de A
    la $t3, x                   # Dirección de 'x'
    lb $t4, 0($t3)             # Cargar el carácter 'x'
    beq $t2, $t4, calcular_a    # Si A es 'x', ir a calcular_a

    # Fin del programa
    li $v0, 10                  # Terminar
    syscall

pedir_valores:
    # Pedir cinco valores al usuario
    li $t5, 5                  # Contador de valores
    la $t6, input              # Dirección base para almacenar valores

pedir_loop:
    beqz $t5, return_pedir     # Si ya se ingresaron 5 valores, regresar
    li $v0, 4
    la $a0, ingrese            # Mostrar "Ingrese valor"
    syscall

    li $v0, 8                  # Leer valor del usuario
    la $a0, 0($t6)             # Dirección para almacenar el valor
    li $a1, 20                 # Tamaño máximo de entrada
    syscall

    addi $t6, $t6, 4           # Mover a la siguiente posición en input
    subi $t5, $t5, 1           # Decrementar contador
    j pedir_loop               # Repetir

return_pedir:
    jr $ra                     # Regresar al llamador

calcular_a:
    # Revisar si B, C, D o E son 'n'
    la $t0, input              # Dirección base de valores
    addi $t0, $t0, 4           # Dirección del valor B
    li $t5, 4                  # Contador de valores restantes (B, C, D, E)

    li $t6, 0                  # Bandera de error (0: no error, 1: error encontrado)

calcular_loop:
    beqz $t5, check_all_values # Si ya se revisaron todos, ir a la comprobación final

    lb $t1, 0($t0)             # Cargar carácter actual
    la $t2, n                  # Dirección de 'n'
    lb $t3, 0($t2)             # Cargar el carácter 'n'
    beq $t1, $t3, print_error  # Si es 'n', imprimir mensaje de error

    addi $t0, $t0, 4           # Mover a la siguiente posición
    subi $t5, $t5, 1           # Decrementar contador
    j calcular_loop            # Repetir

check_all_values:
    # Si no hubo error (t6 == 0), sumar los valores B, C, D, E
    beqz $t6, sum_values       # Si no hubo error, continuar con la suma

    # Si hubo error, retornar
    j return_calcular

sum_values:
    # Sumar los valores B, C, D, E
    li $t7, 0                  # Inicializar la suma en 0
    la $t0, input              # Dirección de inicio de valores

    addi $t0, $t0, 4           # Dirección de B
    lb $t1, 0($t0)             # Cargar B
    sub $t7, $t7, $t7          # Asegurarse de que la suma sea 0 inicialmente
    add $t7, $t7, $t1          # Sumar B

    addi $t0, $t0, 4           # Dirección de C
    lb $t1, 0($t0)             # Cargar C
    add $t7, $t7, $t1          # Sumar C

    addi $t0, $t0, 4           # Dirección de D
    lb $t1, 0($t0)             # Cargar D
    add $t7, $t7, $t1          # Sumar D

    addi $t0, $t0, 4           # Dirección de E
    lb $t1, 0($t0)             # Cargar E
    add $t7, $t7, $t1          # Sumar E

    # Mostrar mensaje de éxito con el cálculo de A
    li $v0, 4
    la $a0, exitoso
    syscall

    # Mostrar el resultado de la suma (A + B + C + D + E)
    li $v0, 1
    move $a0, $t7              # Mover la suma a $a0
    syscall

    # Mostrar salto de línea
    li $v0, 4
    la $a0, newline
    syscall

    j return_calcular          # Regresar después de mostrar el mensaje

return_calcular:
    jr $ra                     # Regresar al llamador

print_error:
    # Mostrar mensaje de error
    li $v0, 4
    la $a0, error
    syscall

    li $v0, 4
    move $a0, $t0              # Mostrar el valor conflictivo (n)
    syscall

    li $v0, 4
    la $a0, es_n
    syscall

    j return_calcular          # Regresar después del error
