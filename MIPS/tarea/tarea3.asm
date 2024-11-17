.data
# Mensajes
bienvenida: .asciiz "Bienvenido, ingrese valores x, n, o numeros entre 0 y 100:\n"
ingreseA:    .asciiz "Ingrese valor A "
ingreseB:    .asciiz "Ingrese valor B "
ingreseC:    .asciiz "Ingrese valor C "
ingreseD:    .asciiz "Ingrese valor D "
ingreseE:    .asciiz "Ingrese valor E "
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

    # Verificar si B es 'x'
    la $t1, input               # Dirección del valor B (segundo valor)
    lb $t2, 4($t1)             # Cargar el carácter de B (el segundo valor se encuentra a 4 bytes de 'input')
    beq $t2, $t4, calcular_b    # Si B es 'x', ir a calcular_b

    # Verificar si C es 'x'
    la $t1, input               # Dirección del valor C (tercer valor)
    lb $t2, 8($t1)             # Cargar el carácter de C (el tercer valor está a 8 bytes de 'input')
    beq $t2, $t4, calcular_c    # Si C es 'x', ir a calcular_c

    # Verificar si D es 'x'
    la $t1, input               # Dirección del valor D (cuarto valor)
    lb $t2, 12($t1)             # Cargar el carácter de D (el cuarto valor está a 12 bytes de 'input')
    beq $t2, $t4, calcular_d    # Si D es 'x', ir a calcular_d

    # Verificar si E es 'x'
    la $t1, input               # Dirección del valor E (quinto valor)
    lb $t2, 16($t1)             # Cargar el carácter de E (el quinto valor está a 16 bytes de 'input')
    beq $t2, $t4, calcular_e    # Si E es 'x', ir a calcular_e
    

    # Fin del programa si no es 'x'
    li $v0, 10                  # Terminar
    syscall

pedir_valores:
    # Pedir cinco valores al usuario
    li $t5, 5                  # Contador de valores
    la $t6, input              # Dirección base para almacenar valores

pedir_loop:
    beqz $t5, return_pedir     # Si ya se ingresaron 5 valores, regresar
    li $v0, 4
    la $a0, ingreseA            # Mostrar "Ingrese valor"
    syscall

    li $v0, 8                  # Leer valor del usuario
    la $a0, 0($t6)             # Dirección para almacenar el valor
    li $a1, 20                 # Tamaño máximo de entrada
    syscall

    addi $t6, $t6, 4           # Mover a la siguiente posición en input
    subi $t5, $t5, 1           # Decrementar contador
    j pedir_B                  # Repetir

pedir_B:
    beqz $t5, return_pedir     # Si ya se ingresaron 5 valores, regresar
    li $v0, 4
    la $a0, ingreseB            # Mostrar "Ingrese valor"
    syscall

    li $v0, 8                  # Leer valor del usuario
    la $a0, 0($t6)             # Dirección para almacenar el valor
    li $a1, 20                 # Tamaño máximo de entrada
    syscall

    addi $t6, $t6, 4           # Mover a la siguiente posición en input
    subi $t5, $t5, 1           # Decrementar contador
    j pedir_C                  # Repetir

pedir_C:
    beqz $t5, return_pedir     # Si ya se ingresaron 5 valores, regresar
    li $v0, 4
    la $a0, ingreseC            # Mostrar "Ingrese valor"
    syscall

    li $v0, 8                  # Leer valor del usuario
    la $a0, 0($t6)             # Dirección para almacenar el valor
    li $a1, 20                 # Tamaño máximo de entrada
    syscall

    addi $t6, $t6, 4           # Mover a la siguiente posición en input
    subi $t5, $t5, 1           # Decrementar contador
    j pedir_D               # Repetir

pedir_D:
    beqz $t5, return_pedir     # Si ya se ingresaron 5 valores, regresar
    li $v0, 4
    la $a0, ingreseD            # Mostrar "Ingrese valor"
    syscall

    li $v0, 8                  # Leer valor del usuario
    la $a0, 0($t6)             # Dirección para almacenar el valor
    li $a1, 20                 # Tamaño máximo de entrada
    syscall

    addi $t6, $t6, 4           # Mover a la siguiente posición en input
    subi $t5, $t5, 1           # Decrementar contador
    j pedir_E               # Repetir

pedir_E:
    beqz $t5, return_pedir     # Si ya se ingresaron 5 valores, regresar
    li $v0, 4
    la $a0, ingreseE            # Mostrar "Ingrese valor"
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

# Revisar si alguno de los otros valores es 'n'
# En cada función (calcular_a, calcular_b, etc.), se revisan los valores excluyendo el actual.

calcular_a:
    # Revisar si B, C, D o E son 'n'
    la $t0, input              # Dirección base de valores
    addi $t0, $t0, 4           # Dirección del valor B
    li $t5, 4                  # Contador de valores restantes (B, C, D, E)
    j verificar_n

calcular_b:
    # Revisar si A, C, D o E son 'n'
    la $t0, input              # Dirección base de valores
    li $t5, 4                  # Contador de valores restantes (A, C, D, E)
    j verificar_n

calcular_c:
    # Revisar si A, B, D o E son 'n'
    la $t0, input              # Dirección base de valores
    li $t5, 4                  # Contador de valores restantes (A, B, D, E)
    j verificar_n

calcular_d:
    # Revisar si A, B, C o E son 'n'
    la $t0, input              # Dirección base de valores
    li $t5, 4                  # Contador de valores restantes (A, B, C, E)
    j verificar_n

calcular_e:
    # Revisar si A, B, C o D son 'n'
    la $t0, input              # Dirección base de valores
    li $t5, 4                  # Contador de valores restantes (A, B, C, D)
    j verificar_n

verificar_n:
    li $t6, 0                  # Bandera de error (0: no error, 1: error encontrado)
verificar_loop:
    beqz $t5, calcular_suma    # Si ya se revisaron todos, ir a la suma

    lb $t1, 0($t0)             # Cargar carácter actual
    la $t2, n                  # Dirección de 'n'
    lb $t3, 0($t2)             # Cargar el carácter 'n'
    beq $t1, $t3, print_error  # Si es 'n', imprimir mensaje de error

    addi $t0, $t0, 4           # Mover a la siguiente posición
    subi $t5, $t5, 1           # Decrementar contador
    j verificar_loop           # Repetir


calcular_suma:
    # Sumar los valores excluyendo el actual
    li $t7, 0                  # Inicializar la suma en 0
    la $t0, input              # Dirección de inicio de valores
    li $t5, 5                  # Total de valores (A, B, C, D, E)

suma_loop:
    beqz $t5, mostrar_resultado # Si se sumaron todos, mostrar el resultado

    lb $t1, 0($t0)             # Cargar el valor actual
    add $t7, $t7, $t1          # Sumar el valor

    addi $t0, $t0, 4           # Mover a la siguiente posición
    subi $t5, $t5, 1           # Decrementar el contador
    j suma_loop                # Repetir

mostrar_resultado:
    # Mostrar mensaje de éxito
    li $v0, 4
    la $a0, exitoso
    syscall

    # Mostrar la suma
    li $v0, 1
    move $a0, $t7
    syscall

    j return_calcular          # Retornar al flujo principal


    # Mostrar salto de línea
    li $v0, 4
    la $a0, newline
    syscall

    # Terminar el programa después de imprimir el resultado
    li $v0, 10                  # Terminar
    syscall

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

    # Terminar el programa después de imprimir el error
    li $v0, 10                  # Terminar
    syscall
