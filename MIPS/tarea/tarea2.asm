.data
mensaje_solicitud: .asciiz "¡Hola!\nPor favor ingrese una frase o palabra para analizarla: "
vocales: .asciiz "aeiouAEIOU"
consonantes: .asciiz "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ"
buffer: .space 100
mensaje_resultados: .asciiz "Resultados:\n"
mensaje_contador_palabras: .asciiz "Cantidad de palabras: "
mensaje_contador_caracteres: .asciiz "Cantidad de caracteres (letras): "
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
    la $t1, vocales             # Dirección de 'vocales'
    la $t9, consonantes         # Dirección de 'consonantes'
    addi $t2, $zero, 0          # Contador de palabras
    addi $t4, $zero, 0          # Contador de vocales
    addi $t5, $zero, 0          # Contador de consonantes
    addi $t6, $zero, 0          # Indicador de palabra (0 = fuera de palabra, 1 = en palabra)

bucle_conteo:
    lb $t7, 0($t0)              # Leer el siguiente carácter
    beq $t7, $zero, fin_bucle   # Si es el fin de la cadena, salir del bucle

    # Comprobar si el carácter es un espacio
    beq $t7, 32, espacio_detectado

    # Contar caracteres (solo letras)
    # Inicialmente se incrementará cuando se detecte una vocal o consonante
    addi $t3, $t3, 1            # Incrementar contador de caracteres

    # Contar vocales
    la $t1, vocales             # Dirección de 'vocales'
verificar_vocal:
    lb $t8, 0($t1)              # Cargar vocal
    beq $t8, $zero, verificar_consonante
    beq $t7, $t8, detectar_vocal
    addi $t1, $t1, 1
    j verificar_vocal

detectar_vocal:
    addi $t4, $t4, 1            # Incrementar contador de vocales
    j palabra_detectada

verificar_consonante:
    la $t9, consonantes         # Dirección de 'consonantes'
verificar_consonante_2:
    lb $t8, 0($t9)              # Cargar consonante
    beq $t8, $zero, palabra_detectada
    beq $t7, $t8, detectar_consonante
    addi $t9, $t9, 1
    j verificar_consonante_2

detectar_consonante:
    addi $t5, $t5, 1            # Incrementar contador de consonantes

palabra_detectada:
    beq $t6, $zero, nueva_palabra
    j siguiente_caracter

nueva_palabra:
    addi $t2, $t2, 1            # Incrementar contador de palabras
    addi $t6, $zero, 1          # Establecer que estamos en una palabra
    j siguiente_caracter

espacio_detectado:
    addi $t6, $zero, 0          # Establecer que estamos fuera de una palabra
    j siguiente_caracter

siguiente_caracter:
    addi $t0, $t0, 1            # Avanzar al siguiente carácter
    j bucle_conteo

fin_bucle:
    # Guardar los resultados en memoria
    sw $t2, contador_palabras
    sw $t4, contador_vocales
    sw $t5, contador_consonantes

    # Calcular el total de caracteres como suma de vocales y consonantes
    add $t3, $t4, $t5            # Total caracteres = vocales + consonantes
    sw $t3, contador_caracteres

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
