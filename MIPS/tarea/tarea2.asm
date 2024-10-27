.data
mensaje_solicitud: .asciiz "¡Hola!\nPor favor ingrese una frase o palabra para analizarla: "
vocales: .asciiz "aeiouAEIOU"  # Agregar mayúsculas para contar vocales
buffer: .space 100
mensaje_resultados: .asciiz "Resultados:\n\n"
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
    la $a0, mensaje_solicitud  # Cargar dirección de 'mensaje_solicitud'
    syscall

    # Leer la entrada del usuario
    addi $v0, $zero, 8
    la $a0, buffer              # Cargar dirección de 'buffer'
    addi $a1, $zero, 100
    syscall

    # Inicializar registros
    la $t0, buffer              # Dirección de 'buffer'
    la $t1, vocales             # Dirección de 'vocales'
    addi $t2, $zero, 0          # Contador de palabras
    addi $t3, $zero, 0          # Contador de caracteres
    addi $t4, $zero, 0          # Contador de vocales
    addi $t5, $zero, 0          # Contador de consonantes
    addi $t6, $zero, 0          # Indicador de palabra (0 = fuera de palabra, 1 = en palabra)

    # Contar palabras, caracteres, vocales y consonantes
bucle_conteo:
    lb $t7, 0($t0)              # Leer el siguiente carácter
    beq $t7, $zero, fin_bucle    # Si es el fin de la cadena, salir del bucle

    # Contar caracteres
    addi $t3, $t3, 1            # Incrementar contador de caracteres

    # Comprobar si el carácter es un espacio
    beq $t7, 32, espacio_detectado

    # Si no es un espacio
    beq $t6, $zero, nueva_palabra  # Si no estamos en una palabra, estamos en una nueva
    j caracter_detectado          # Si ya estamos en una palabra, solo contamos

nueva_palabra:
    addi $t2, $t2, 1            # Incrementar contador de palabras
    addi $t6, $zero, 1          # Establecer que estamos en una palabra
    j caracter_detectado

espacio_detectado:
    addi $t6, $zero, 0          # Establecer que estamos fuera de una palabra
    j bucle_conteo

caracter_detectado:
    # Contar vocales y consonantes
    la $t1, vocales             # Dirección de 'vocales'
verificar_vocal:
    lb $t8, 0($t1)              # Cargar vocal
    beq $t8, $zero, detectar_consonante
    beq $t7, $t8, detectar_vocal
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
    la $a0, mensaje_resultados
    syscall

    # Contador de palabras
    addi $v0, $zero, 4
    la $a0, mensaje_contador_palabras
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_palabras
    syscall

    # Contador de caracteres
    addi $v0, $zero, 4
    la $a0, mensaje_contador_caracteres
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_caracteres
    syscall

    # Contador de vocales
    addi $v0, $zero, 4
    la $a0, mensaje_contador_vocales
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_vocales
    syscall

    # Contador de consonantes
    addi $v0, $zero, 4
    la $a0, mensaje_contador_consonantes
    syscall
    addi $v0, $zero, 1
    lw $a0, contador_consonantes
    syscall

    # Salir del programa
    addi $v0, $zero, 10
    syscall
