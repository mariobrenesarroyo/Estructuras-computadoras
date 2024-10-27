.data
mensaje_solicitud: .asciiz "¡Hola!\nPor favor ingrese una frase o palabra para analizarla: "
vocales: .asciiz "aeiouAEIOU"  # Vocales en minúsculas y mayúsculas
buffer: .space 100
mensaje_resultados: .asciiz "Resultados:\n"
mensaje_contador_palabras: .asciiz "Cantidad de palabras: "
mensaje_contador_caracteres: .asciiz "Cantidad de caracteres (incluidos espacios): "
mensaje_contador_vocales: .asciiz "Cantidad de vocales: "
mensaje_contador_consonantes: .asciiz "Cantidad de consonantes: "
contador_palabras: .word 0
contador_caracteres: .word 0
contador_vocales: .word 0
contador_consonantes: .word 0

.text
main:
    # Imprimir el mensaje de solicitud
    addi $v0, $zero, 4
    la $a0, mensaje_solicitud
    syscall

    # Leer la entrada del usuario
    addi $v0, $zero, 8
    la $a0, buffer
    addi $a1, $zero, 100
    syscall

    # Inicializar registros
    la $t0, buffer              # Dirección de 'buffer'
    addi $t1, $zero, 0          # Contador de palabras
    addi $t2, $zero, 0          # Contador de caracteres
    addi $t3, $zero, 0          # Contador de vocales
    addi $t4, $zero, 0          # Contador de consonantes
    addi $t5, $zero, 0          # Indicador de palabra (0 = fuera de palabra, 1 = en palabra)

    # Contar palabras, caracteres, vocales y consonantes
bucle_conteo:
    lb $t6, 0($t0)              # Leer el siguiente carácter
    beq $t6, $zero, fin_bucle   # Si es el fin de la cadena, salir del bucle

    # Contar caracteres totales (incluidos espacios)
    addi $t2, $t2, 1            # Incrementar contador de caracteres

    # Comprobar si el carácter es un espacio
    beq $t6, 32, espacio_detectado

    # Comprobar si el carácter es una letra
    blt $t6, 65, verificar_no_letra   # Si es menor que 'A'
    bgt $t6, 122, verificar_no_letra  # Si es mayor que 'z'
    beq $t6, 91, verificar_no_letra   # Si es igual a 'Z'
    beq $t6, 96, verificar_no_letra   # Si es igual a '`'

    # Si es letra, verificar si es vocal
    la $t1, vocales              # Dirección de 'vocales'
verificar_vocal:
    lb $t7, 0($t1)              # Cargar vocal
    beq $t7, $zero, detectar_consonante
    beq $t6, $t7, detectar_vocal
    addi $t1, $t1, 1
    j verificar_vocal

detectar_vocal:
    addi $t3, $t3, 1            # Incrementar contador de vocales
    j siguiente_caracter

detectar_consonante:
    addi $t4, $t4, 1            # Incrementar contador de consonantes

siguiente_caracter:
    addi $t0, $t0, 1            # Avanzar al siguiente carácter
    addi $t5, $zero, 1          # Establecer que estamos en una palabra
    j bucle_conteo

espacio_detectado:
    beq $t5, $zero, bucle_conteo # Si ya está fuera de palabra, seguir
    addi $t1, $t1, 1            # Incrementar contador de palabras
    addi $t5, $zero, 0          # Establecer que estamos fuera de una palabra
    j bucle_conteo

fin_bucle:
    # Al final del bucle, si el último carácter no es espacio, contamos la última palabra
    beq $t5, $zero, finalizar
    addi $t1, $t1, 1            # Contar la última palabra

finalizar:
    # Guardar los resultados en memoria
    sw $t1, contador_palabras
    sw $t2, contador_caracteres
    sw $t3, contador_vocales
    sw $t4, contador_consonantes

    # Imprimir resultados
    addi $v0, $zero, 4
    la $a0, mensaje_resultados
    syscall

    # Contador de palabras
    addi $v0, $zero, 4
    la $a0, mensaje_contador_palabras
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_palabras
    syscall

    # Imprimir salto de línea
    li $v0, 11
    li $a0, 10  # Código ASCII para nueva línea
    syscall

    # Contador de caracteres
    addi $v0, $zero, 4
    la $a0, mensaje_contador_caracteres
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_caracteres
    syscall

    # Imprimir salto de línea
    li $v0, 11
    li $a0, 10
    syscall

    # Contador de vocales
    addi $v0, $zero, 4
    la $a0, mensaje_contador_vocales
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_vocales
    syscall

    # Imprimir salto de línea
    li $v0, 11
    li $a0, 10
    syscall

    # Contador de consonantes
    addi $v0, $zero, 4
    la $a0, mensaje_contador_consonantes
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_consonantes
    syscall

    # Imprimir salto de línea
    li $v0, 11
    li $a0, 10
    syscall

    # Salir del programa
    addi $v0, $zero, 10
    syscall
