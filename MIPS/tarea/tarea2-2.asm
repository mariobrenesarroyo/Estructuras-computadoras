.data
mensaje_solicitud: .asciiz "¡Hola!\nPor favor ingrese una frase o palabra para analizarla: "
vocales: .asciiz "aeiouAEIOU"
consonantes: .asciiz "bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ"
buffer: .space 100
MAYUSCULAS: .asciiz "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"
minusculas: .asciiz "abcdefghijklmnñopqrstuvwxyz"
signos: .asciiz "!¡?¿.:;"
mensaje_resultados: .asciiz "Resultados:\n"
mensaje_contador_palabras: .asciiz "Cantidad de palabras: "
mensaje_contador_caracteres: .asciiz "Cantidad de caracteres (letras): "
mensaje_contador_vocales: .asciiz "Cantidad de vocales: "
mensaje_contador_consonantes: .asciiz "Cantidad de consonantes: "
mensaje_contador_mayusculas: .asciiz "Cantidad de MAYUSCULAS: "
mensaje_contador_minusculas: .asciiz "Cantidad de minusculas: "
mensaje_contador_signos: .asciiz "Cantidad de signos de puntuación: "

contador_palabras: .word 0
contador_caracteres: .word 0
contador_vocales: .word 0
contador_consonantes: .word 0
contador_mayusculas: .word 0
contador_minusculas: .word 0
contador_signos: .word 0

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
    la $s0, consonantes         # Dirección de 'consonantes'
    la $s1, MAYUSCULAS          # Dirección de 'MAYUSCULAS'
    la $s2, minusculas          # Dirección de 'minusculas'
    la $s5, signos              # Dirección de 'signos'
    addi $t2, $zero, 0          # Contador de palabras
    addi $t4, $zero, 0          # Contador de vocales
    addi $t5, $zero, 0          # Contador de consonantes
    addi $t6, $zero, 0          # Indicador de palabra (0 = fuera de palabra, 1 = en palabra)
    addi $s3, $zero, 0          # Contador de mayúsculas
    addi $s4, $zero, 0          # Contador de minúsculas
    addi $s6, $zero, 0          # Contador de signos

bucle_conteo:
    lb $t7, 0($t0)              # Leer el siguiente carácter
    beq $t7, $zero, fin_bucle   # Si es el fin de la cadena, salir del bucle

    # Comprobar si el carácter es un espacio
    beq $t7, 32, espacio_detectado

    # Contar caracteres (solo letras)
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
    j verificar_mayuscula       # Saltar a verificación de mayúsculas/minúsculas

verificar_consonante:
    la $s0, consonantes         # Dirección de 'consonantes'
verificar_consonante_2:
    lb $t8, 0($s0)              # Cargar consonante
    beq $t8, $zero, verificar_signo
    beq $t7, $t8, detectar_consonante
    addi $s0, $s0, 1
    j verificar_consonante_2

detectar_consonante:
    addi $t5, $t5, 1            # Incrementar contador de consonantes
    j verificar_mayuscula

verificar_mayuscula:
    la $s1, MAYUSCULAS          # Dirección de 'MAYUSCULAS'
verificar_mayuscula_2:
    lb $t8, 0($s1)              # Cargar mayúscula
    beq $t8, $zero, verificar_minuscula
    beq $t7, $t8, detectar_mayuscula
    addi $s1, $s1, 1
    j verificar_mayuscula_2

detectar_mayuscula:
    addi $s3, $s3, 1            # Incrementar contador de mayúsculas
    j palabra_detectada

verificar_minuscula:
    la $s2, minusculas          # Dirección de 'minusculas'
verificar_minuscula_2:
    lb $t8, 0($s2)              # Cargar minúscula
    beq $t8, $zero, verificar_signo
    beq $t7, $t8, detectar_minuscula
    addi $s2, $s2, 1
    j verificar_minuscula_2

detectar_minuscula:
    addi $s4, $s4, 1            # Incrementar contador de minúsculas
    j palabra_detectada

verificar_signo:
    la $s5, signos              # Dirección de 'signos'
verificar_signo_2:
    lb $t8, 0($s5)              # Cargar signo
    beq $t8, $zero, palabra_detectada
    beq $t7, $t8, detectar_signo
    addi $s5, $s5, 1
    j verificar_signo_2

detectar_signo:
    addi $s6, $s6, 1            # Incrementar contador de signos

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
    sw $s3, contador_mayusculas
    sw $s4, contador_minusculas
    sw $s6, contador_signos

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
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Imprimir contador de caracteres
    addi $v0, $zero, 4
    la $a0, mensaje_contador_caracteres
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_caracteres
    syscall
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Contador de vocales
    addi $v0, $zero, 4
    la $a0, mensaje_contador_vocales
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_vocales
    syscall
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Contador de consonantes
    addi $v0, $zero, 4
    la $a0, mensaje_contador_consonantes
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_consonantes
    syscall
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Contador de mayúsculas
    addi $v0, $zero, 4
    la $a0, mensaje_contador_mayusculas
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_mayusculas
    syscall
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Contador de minúsculas
    addi $v0, $zero, 4
    la $a0, mensaje_contador_minusculas
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_minusculas
    syscall
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Contador de signos de puntuación
    addi $v0, $zero, 4
    la $a0, mensaje_contador_signos
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_signos
    syscall
    # Salto de línea
    addi $v0, $zero, 11
    li $a0, 10
    syscall

    # Terminar programa
    addi $v0, $zero, 10
    syscall
