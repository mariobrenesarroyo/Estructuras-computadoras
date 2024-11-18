.data
# Mensajes
bienvenida: .asciiz "Bienvenido, ingrese valores x, n, x para calcular, n para excluir:\n"
ingreseA:    .asciiz "Ingrese valor A "
ingreseB:    .asciiz "Ingrese valor B "
ingreseC:    .asciiz "Ingrese valor C "
ingreseD:    .asciiz "Ingrese valor D "
ingreseE:    .asciiz "Ingrese valor E "
error:      .asciiz "Error: el valor "
es_n:       .asciiz " es n y no se puede realizar el cálculo.\n"
exitosoA:    .asciiz "Éxito, el cálculo de A es: "
exitosoB:    .asciiz "Éxito, el cálculo de B es: "
exitosoC:    .asciiz "Éxito, el cálculo de C es: "
exitosoD:    .asciiz "Éxito, el cálculo de D es: "
exitosoE:    .asciiz "Éxito, el cálculo de E es: "
valA:        .asciiz "Se ingresó A como: "
valB:        .asciiz "Se ingresó B como: "
valC:        .asciiz "Se ingresó C como: "
valD:        .asciiz "Se ingresó D como: "
valE:        .asciiz "Se ingresó E como: "

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
    jal  pedir_valores

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


pedir:
    beqz $t5, fin_pedir       # Si ya se ingresaron 5 valores, terminar

    # Seleccionar mensaje según índice
    li $t0, 0
    beq $t7, $t0, mostrar_ingreseA
    li $t0, 1
    beq $t7, $t0, mostrar_ingreseB
    li $t0, 2
    beq $t7, $t0, mostrar_ingreseC
    li $t0, 3
    beq $t7, $t0, mostrar_ingreseD
    li $t0, 4
    beq $t7, $t0, mostrar_ingreseE

mostrar_ingreseA:
    la $a0, ingreseA
    j mostrar_mensaje
mostrar_ingreseB:
    la $a0, ingreseB
    j mostrar_mensaje
mostrar_ingreseC:
    la $a0, ingreseC
    j mostrar_mensaje
mostrar_ingreseD:
    la $a0, ingreseD
    j mostrar_mensaje
mostrar_ingreseE:
    la $a0, ingreseE

mostrar_mensaje:
    li $v0, 4                 # Syscall para imprimir mensaje
    syscall

    # Leer valor del usuario
    li $v0, 8                 # Leer cadena del usuario
    la $a0, input_buffer      # Buffer para entrada
    li $a1, 20                # Tamaño máximo de entrada
    syscall

    # Validar si es un carácter especial ('x' o 'n')
    lb $t0, input_buffer      # Leer primer carácter
    li $t1, 'x'
    beq $t0, $t1, almacenar_caracter
    li $t1, 'n'
    beq $t0, $t1, almacenar_caracter

    # Convertir a flotante o entero
    jal convertir_a_flotante  # Intentar conversión a flotante
    mov.s $f12, $f0           # Guardar flotante convertido en $f12
    j almacenar_numero        # Ir a almacenar el valor

almacenar_caracter:
    sb $t0, 0($t6)            # Almacenar carácter ASCII en memoria
    j guardar_registro

almacenar_numero:
    s.s $f12, 0($t6)          # Almacenar flotante en memoria

guardar_registro:
    # Guardar en registros específicos según índice
    li $t0, 0
    beq $t7, $t0, guardar_s3
    li $t0, 1
    beq $t7, $t0, guardar_s4
    li $t0, 2
    beq $t7, $t0, guardar_s5
    li $t0, 3
    beq $t7, $t0, guardar_s6
    li $t0, 4
    beq $t7, $t0, guardar_s7
    j siguiente

guardar_s3:
    lw $s3, 0($t6)            # Almacenar en $s3
    j siguiente
guardar_s4:
    lw $s4, 0($t6)            # Almacenar en $s4
    j siguiente
guardar_s5:
    lw $s5, 0($t6)            # Almacenar en $s5
    j siguiente
guardar_s6:
    lw $s6, 0($t6)            # Almacenar en $s6
    j siguiente
guardar_s7:
    lw $s7, 0($t6)            # Almacenar en $s7

siguiente:
    addi $t6, $t6, 4          # Mover a la siguiente posición en input
    addi $t7, $t7, 1          # Incrementar índice
    subi $t5, $t5, 1          # Decrementar contador
    j pedir                   # Repetir para el siguiente valor

fin_pedir:
    jr $ra                    # Regresar al llamador

# Función para convertir cadena a flotante
convertir_a_flotante:
    li $v0, 2                 # Syscall para convertir cadena a flotante
    la $a0, input_buffer      # Dirección de la cadena
    syscall
    jr $ra                    # Regresar

# Revisar si alguno de los otros valores es 'n'
# En cada función (calcular_a, calcular_b, etc.), se revisan los valores excluyendo el actual.

calcular_a:
    la $t0, input             # Dirección base de valores
    addi $t0, $t0, 4          # Dirección de B (input[1])
    lb $t1, 0($t0)            # Cargar B
    addi $t0, $t0, 4          # Dirección de C (input[2])
    lb $t2, 0($t0)            # Cargar C
    addi $t0, $t0, 4          # Dirección de E (input[4])
    lb $t3, 0($t0)            # Cargar E

    #errores
    la $t5, n                  # Dirección de 'n'
    lb $t6, 0($t5)             # Cargar el carácter 'n'
    beq $t1, $t6, print_error  # Si B es 'n', imprimir mensaje de error
    beq $t2, $t6, print_error  # Si C es 'n', imprimir mensaje de error
    beq $t3, $t6, print_error  # Si E es 'n', imprimir mensaje de error

    mul $t4, $t2, $t3         # t4 = C * E
    sub $t5, $t1, $t4         # t5 = B - C * E

    la $t0, input             # Dirección de A (input[0])
    sb $t5, 0($t0)            # Guardar A en memoria

    # Mostrar mensaje exitoso
    li $v0, 4                 # Llamada para imprimir cadena
    la $a0, exitosoA          # Mensaje: "Éxito, el cálculo de A es: "
    syscall

    # Mostrar valor de A
    li $v0, 1                 # Llamada para imprimir entero
    move $a0, $t5             # Mover resultado a $a0
    syscall

    # Finalizar programa
    li $v0, 10                # Llamada para terminar el programa
    syscall

calcular_b:
    # Cargar los valores de los registros correspondientes
    lw $t1, 0($s3)           # Cargar A (desde $s3)
    lw $t2, 0($s5)           # Cargar C (desde $s5)
    lw $t3, 0($s7)           # Cargar E (desde $s7)

    # Mostrar el valor ingresado de A
    li $v0, 4                # Llamada para imprimir cadena
    la $a0, valA             # Mensaje: "Se ingresó A como: "
    syscall
    li $v0, 1                # Llamada para imprimir entero
    move $a0, $t1            # Mover A a $a0
    syscall
    li $v0, 11               # Imprimir salto de línea
    li $a0, '\n'
    syscall

    # Mostrar el valor ingresado de C
    li $v0, 4                # Llamada para imprimir cadena
    la $a0, valC             # Mensaje: "Se ingresó C como: "
    syscall
    li $v0, 1                # Llamada para imprimir entero
    move $a0, $t2            # Mover C a $a0
    syscall
    li $v0, 11               # Imprimir salto de línea
    li $a0, '\n'
    syscall

    # Mostrar el valor ingresado de E
    li $v0, 4                # Llamada para imprimir cadena
    la $a0, valE             # Mensaje: "Se ingresó E como: "
    syscall
    li $v0, 1                # Llamada para imprimir entero
    move $a0, $t3            # Mover E a $a0
    syscall
    li $v0, 11               # Imprimir salto de línea
    li $a0, '\n'
    syscall

    # Verificar si hay errores (valores 'n')
    la $t5, n                # Dirección de 'n'
    lb $t6, 0($t5)           # Cargar el carácter 'n'
    beq $t1, $t6, print_error  # Si A es 'n', imprimir mensaje de error
    beq $t2, $t6, print_error  # Si C es 'n', imprimir mensaje de error
    beq $t3, $t6, print_error  # Si E es 'n', imprimir mensaje de error

    # Realizar el cálculo de B: B = A + C * E
    mul $t4, $t2, $t3         # t4 = C * E
    add $t5, $t1, $t4         # t5 = A + C * E

    # Mostrar mensaje exitoso
    li $v0, 4                 # Llamada para imprimir cadena
    la $a0, exitosoB          # Mensaje: "Éxito, el cálculo de B es: "
    syscall

    # Mostrar valor de B
    li $v0, 1                 # Llamada para imprimir entero
    move $a0, $t5             # Mover resultado a $a0
    syscall
    li $v0, 11                # Imprimir salto de línea
    li $a0, '\n'
    syscall

    # Finalizar programa
    li $v0, 10                # Llamada para terminar el programa
    syscall



calcular_c:
    la $t0, input             # Dirección base de valores
    addi $t0, $t0, 4          # Dirección de B (input[1])
    lb $t1, 0($t0)            # Cargar B
    la $t0, input             # Dirección de A (input[0])
    lb $t2, 0($t0)            # Cargar A
    addi $t0, $t0, 12         # Dirección de E (input[4])
    lb $t3, 0($t0)            # Cargar E

    # Manejo de errores
    la $t5, n                 # Dirección de 'n'
    lb $t6, 0($t5)            # Cargar el carácter 'n'
    beq $t1, $t6, print_error # Si B es 'n', imprimir mensaje de error
    beq $t2, $t6, print_error # Si A es 'n', imprimir mensaje de error
    beq $t3, $t6, print_error # Si E es 'n', imprimir mensaje de error

    # Evitar división por cero
    beqz $t3, print_error     # Si E es 0, error

    sub $t4, $t1, $t2         # t4 = B - A
    div $t5, $t4, $t3         # t5 = (B - A) / E

    la $t0, input             # Dirección de C (input[2])
    addi $t0, $t0, 8
    sb $t5, 0($t0)            # Guardar C en memoria

    # Mostrar mensaje exitoso
    li $v0, 4                 # Llamada para imprimir cadena
    la $a0, exitosoC          # Mensaje: "Éxito, el cálculo de C es: "
    syscall

    # Mostrar valor de C
    li $v0, 1                 # Llamada para imprimir entero
    move $a0, $t5             # Mover resultado a $a0
    syscall

    # Finalizar programa
    li $v0, 10                # Llamada para terminar el programa
    syscall

calcular_d:
    la $t0, input             # Dirección base de valores
    lb $t1, 0($t0)            # Cargar A (input[0])
    addi $t0, $t0, 4          # Dirección de B (input[1])
    lb $t2, 0($t0)            # Cargar B
    addi $t0, $t0, 12         # Dirección de E (input[4])
    lb $t3, 0($t0)            # Cargar E

    # Manejo de errores
    la $t5, n                 # Dirección de 'n'
    lb $t6, 0($t5)            # Cargar el carácter 'n'
    beq $t1, $t6, print_error # Si A es 'n', imprimir mensaje de error
    beq $t2, $t6, print_error # Si B es 'n', imprimir mensaje de error
    beq $t3, $t6, print_error # Si E es 'n', imprimir mensaje de error

    add $t4, $t1, $t2         # t4 = A + B
    mul $t5, $t4, $t3         # t5 = (A + B) * E
    sra $t5, $t5, 1           # t5 = ((A + B) * E) / 2 (división rápida por 2)

    la $t0, input             # Dirección de D (input[3])
    addi $t0, $t0, 12
    sb $t5, 0($t0)            # Guardar D en memoria

    # Mostrar mensaje exitoso
    li $v0, 4                 # Llamada para imprimir cadena
    la $a0, exitosoD          # Mensaje: "Éxito, el cálculo de D es: "
    syscall

    # Mostrar valor de D
    li $v0, 1                 # Llamada para imprimir entero
    move $a0, $t5             # Mover resultado a $a0
    syscall

    # Finalizar programa
    li $v0, 10                # Llamada para terminar el programa
    syscall

calcular_e:
    la $t0, input             # Dirección base de valores
    addi $t0, $t0, 4          # Dirección de B (input[1])
    lb $t1, 0($t0)            # Cargar B
    la $t0, input             # Dirección de A (input[0])
    lb $t2, 0($t0)            # Cargar A
    addi $t0, $t0, 8          # Dirección de C (input[2])
    lb $t3, 0($t0)            # Cargar C

    # Manejo de errores
    la $t5, n                 # Dirección de 'n'
    lb $t6, 0($t5)            # Cargar el carácter 'n'
    beq $t1, $t6, print_error # Si B es 'n', imprimir mensaje de error
    beq $t2, $t6, print_error # Si A es 'n', imprimir mensaje de error
    beq $t3, $t6, print_error # Si C es 'n', imprimir mensaje de error

    # Evitar división por cero
    beqz $t3, print_error     # Si C es 0, error

    sub $t4, $t1, $t2         # t4 = B - A
    div $t5, $t4, $t3         # t5 = (B - A) / C

    la $t0, input             # Dirección de E (input[4])
    addi $t0, $t0, 12
    sb $t5, 0($t0)            # Guardar E en memoria

    # Mostrar mensaje exitoso
    li $v0, 4                 # Llamada para imprimir cadena
    la $a0, exitosoE          # Mensaje: "Éxito, el cálculo de E es: "
    syscall

    # Mostrar valor de E
    li $v0, 1                 # Llamada para imprimir entero
    move $a0, $t5             # Mover resultado a $a0
    syscall

    # Finalizar programa
    li $v0, 10                # Llamada para terminar el programa
    syscall


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
