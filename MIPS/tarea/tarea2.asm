.data
mensaje_solicitud: .asciiz "¡Hola!\nPor favor ingrese una frase o palabra para analizarla: "
vocales: .asciiz "aeiouAEIOU"
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
    la $t0, buffer
    la $t1, vocales
    addi $t2, $zero, 0          # Contador de palabras
    addi $t3, $zero, 0          # Contador de caracteres
    addi $t4, $zero, 0          # Contador de vocales
    addi $t5, $zero, 0          # Contador de consonantes
    addi $t6, $zero, 0          # Indicador de palabra (0 = fuera de palabra, 1 = en palabra)
    addi $t7, $zero, 32         # Código ASCII para espacio

    # Contar palabras, caracteres, vocales y consonantes
bucle_conteo:
    lb $t8, 0($t0)              # Leer el siguiente carácter
    beqz $t8, fin_bucle         # Si es el fin de la cadena, salir del bucle

    # Comprobar si el carácter es un espacio
    bnez $t8, verificar_letra

    # Si es un espacio, contar como caracter y continuar
    addi $t3, $t3, 1            # Incrementar contador de caracteres
    j bucle_conteo

verificar_letra:
    # Comprobar si el carácter es una letra
    blt $t8, 65, verificar_minuscuela
    ble $t8, 91, verificar_minuscuela
    bleu $t8, 122, verificar_minuscuela
    j siguiente_caracter

verificar_minuscuela:
    blt $t8, 97, siguiente_caracter
    ble $t8, 123, siguiente_caracter
    j verificar_mayusculas

verificar_mayusculas:
    blt $t8, 65, siguiente_caracter
    ble $t8, 90, siguiente_caracter
    j siguiente_caracter

siguiente_caracter:
    # Contar vocales y consonantes
    la $t9, vocales             # Dirección de 'vocales'
    addi $t9, $t9, 0           # Preparar para loop
    addi $t10, $zero, 0        # Contador interno para verificar vocales

verificar_vocal:
    lb $t11, 0($t9)            # Cargar vocal
    beqz $t11, detectar_consonante
    beq $t8, $t11, detectar_vocal
    addi $t9, $t9, 1
    j verificar_vocal

detectar_vocal:
    addi $t4, $t4, 1            # Incrementar contador de vocales
    j siguiente_caracter

detectar_consonante:
    addi $t5, $t5, 1            # Incrementar contador de consonantes

    # Actualizar indicadores de palabra
    beq $t6, $zero, nueva_palabra
    j siguiente_caracter

nueva_palabra:
    addi $t2, $t2, 1            # Incrementar contador de palabras
    addi $t6, $zero, 1          # Establecer que estamos en una palabra
    j siguiente_caracter

fin_bucle:
    # Guardar los resultados en memoria
    sw $t2, contador_palabras
    sw $t3, contador_caracteres
    sw $t4, contador_vocales
    sw $t5, contador_consonantes

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
    li $a0, 10
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
