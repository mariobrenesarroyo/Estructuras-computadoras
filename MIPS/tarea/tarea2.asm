.data
mensaje_solicitud: .asciiz "Ingrese una frase: "
vocales: .asciiz "aeiou"
buffer: .asciiz "Hoy es Domingo"  # Frase predefinida
mensaje_contador_palabras: .asciiz "Cantidad de palabras: "
mensaje_contador_caracteres: .asciiz "Cantidad de caracteres: "
mensaje_contador_vocales: .asciiz "Cantidad de vocales: "
mensaje_contador_consonantes: .asciiz "Cantidad de consonantes: "
contador_palabras: .word 0
contador_caracteres: .word 0
contador_vocales: .word 0
contador_consonantes: .word 0

.text
main:
    # Imprimir el mensaje de solicitud (ya no es necesario ingresar frase)
    addi $v0, $zero, 4
    lui $a0, 0x1001             # Parte alta de la dirección de 'mensaje_solicitud'
    ori $a0, $a0, 0x0000        # Parte baja de la dirección
    syscall

    # Inicializar registros
    lui $t0, 0x1001
    ori $t0, $t0, 0x0020        # Dirección de 'buffer' (donde está la frase)
    lui $t1, 0x1001
    ori $t1, $t1, 0x0030        # Dirección de 'vocales'
    addi $t2, $zero, 0          # Contador de palabras
    addi $t3, $zero, 0          # Contador de caracteres
    addi $t4, $zero, 0          # Contador de vocales
    addi $t5, $zero, 0          # Contador de consonantes

    # Contar palabras, caracteres, vocales y consonantes
bucle_conteo:
    lb $t6, 0($t0)              # Leer el siguiente carácter
    beq $t6, $zero, fin_bucle    # Si es el fin de la cadena, salir del bucle

    # Contar palabras
    beq $t6, 32, espacio_detectado # Si es un espacio
    addi $t2, $t2, 1            # Incrementar contador de palabras
    j caracter_detectado

espacio_detectado:
    addi $t0, $t0, 1            # Avanzar al siguiente carácter
    j bucle_conteo

caracter_detectado:
    # Contar caracteres (ignorando espacios y signos de puntuación)
    addi $t7, $zero, 97         # 'a'
    slt $t8, $t6, $t7           # $t8 = ($t6 < 'a')
    bne $t8, $zero, siguiente_caracter
    addi $t7, $zero, 123        # 'z' + 1
    slt $t8, $t6, $t7           # $t8 = ($t6 < 'z' + 1)
    beq $t8, $zero, siguiente_caracter
    addi $t3, $t3, 1            # Incrementar contador de caracteres

    # Contar vocales y consonantes
    lui $t1, 0x1001
    ori $t1, $t1, 0x0030        # Dirección de 'vocales'
verificar_vocal:
    lb $t7, 0($t1)
    beq $t7, $zero, detectar_consonante
    beq $t6, $t7, detectar_vocal
    addi $t1, $t1, 1
    j verificar_vocal

detectar_vocal:
    addi $t4, $t4, 1            # Incrementar contador de vocales
    j siguiente_caracter

detectar_consonante:
    addi $t5, $t5, 1            # Incrementar contador de consonantes

siguiente_caracter:
    addi $t0, $t0, 1            # Avanzar al siguiente carácter
    j bucle_conteo

fin_bucle:
    # Guardar los resultados en memoria
    sw $t2, contador_palabras
    sw $t3, contador_caracteres
    sw $t4, contador_vocales
    sw $t5, contador_consonantes

    # Imprimir resultados
    addi $v0, $zero, 4
    lui $a0, 0x1001
    ori $a0, $a0, 0x0040        # Dirección de 'mensaje_contador_palabras'
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_palabras
    syscall

    addi $v0, $zero, 4
    lui $a0, 0x1001
    ori $a0, $a0, 0x0050        # Dirección de 'mensaje_contador_caracteres'
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_caracteres
    syscall

    addi $v0, $zero, 4
    lui $a0, 0x1001
    ori $a0, $a0, 0x0060        # Dirección de 'mensaje_contador_vocales'
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_vocales
    syscall

    addi $v0, $zero, 4
    lui $a0, 0x1001
    ori $a0, $a0, 0x0070        # Dirección de 'mensaje_contador_consonantes'
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_consonantes
    syscall

    # Salir del programa
    addi $v0, $zero, 10
    syscall
