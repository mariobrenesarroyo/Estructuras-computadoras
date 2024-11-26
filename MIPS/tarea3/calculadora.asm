.data
# Mensajes
bienvenida:    .asciiz "Bienvenido, ingrese valores flotantes (110 para calcular, 120 para excluir):\n"
ingreseA:      .asciiz "Ingrese valor Vi (m/s): "
ingreseB:      .asciiz "Ingrese valor Vf (m/s): "
ingreseC:      .asciiz "Ingrese valor A (m/s^2): "
ingreseD:      .asciiz "Ingrese valor D (m): "
ingreseE:      .asciiz "Ingrese valor T (s): "
error_120:     .asciiz "Error: el valor es 120.0 y no se puede realizar el cálculo.\n"
error_neg:     .asciiz "Error: el valor es negativo y no se puede realizar el cálculo.\n"
exitosoA:      .asciiz "Éxito, el cálculo de Vi (m/s) es: %f\n"
exitosoB:      .asciiz "Éxito, el cálculo de Vf (m/s) es: %f\n"
exitosoC:      .asciiz "Éxito, el cálculo de A (m/s^2) es: %f\n"
exitosoD:      .asciiz "Éxito, el cálculo de D (m) es: %f\n"
exitosoE:      .asciiz "Éxito, el cálculo de T (s) es: %f\n"
ingrese_salir: .asciiz "Ingrese cualquier tecla  para un nuevo cálculo o  la palabra salir para salir: "
salir_opcion:  .asciiz "salir"
newline:       .asciiz "\n"

buffer: .space 20 # Espacio para almacenar la cadena de entrada

.text
.globl main

main:
    # Mensaje de bienvenida
    li $v0, 4
    la $a0, bienvenida
    syscall

nuevo_calculo:
    # Leer los valores de Vi, Vf, A, D, y T

    # leer Vi
    li $v0, 6
    la $a0, ingreseA
    syscall
    mov.s $f2, $f0  # Vi -> $f2

    # leer vf
    li $v0, 6
    la $a0, ingreseB
    syscall
    mov.s $f3, $f0  # Vf -> $f3   

    # leer A
    li $v0, 6
    la $a0, ingreseC
    syscall
    mov.s $f4, $f0   # A -> $f4

    #leer D
    li $v0, 6
    la $a0, ingreseD
    syscall
    mov.s $f5, $f0   # D -> $f5

    # leer t
    li $v0, 6
    la $a0, ingreseE
    syscall
    mov.s $f6, $f0   # T -> $f6
    
    jal validar_y_calcular
    

    



validar_y_calcular:

    # Realizar cálculos según el valor desconocido
    li.s $f7, 110.0
    c.eq.s $f2, $f7
    bc1t calcular_Vi
    c.eq.s $f3, $f7
    bc1t calcular_Vf
    c.eq.s $f4, $f7
    bc1t calcular_A
    c.eq.s $f5, $f7
    bc1t calcular_D
    c.eq.s $f6, $f7
    bc1t calcular_T

    # Preguntar si el usuario quiere salir o repetir
    li $v0, 4
    la $a0, ingrese_salir
    syscall

    li $v0, 5
    syscall
    beq $v0, 0, salir
    beq $v0, 1, nuevo_calculo
    jal salir



calcular_Vi:
#verifico que tengan los valores necesarios no excuidos
    li.s $f7, 120.0
    c.eq.s $f3, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    li.s $f7, 0.0           # Cargo 0.0 en $f7 para comparar
    c.lt.s $f3, $f7         # ¿$f3 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error




    # Vi = Vf - A * T
    mul.s $f10, $f4, $f6  # A * T
    sub.s $f9, $f3, $f10  # Vf - A * T

    
    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, exitosoA                # Carga la dirección del mensaje "Éxito, el cálculo de Vi (m/s) es: %f\n" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f9                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante

    jal desea_salir




calcular_Vf:

    #verifico que tengan los valores necesarios no excuidos

    li.s $f7, 120.0
    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    li.s $f7, 0.0           # Cargo 0.0 en $f7 para comparar
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # Vf = Vi + A * T
    mul.s $f10, $f4, $f6
    add.s $f9, $f2, $f10
    
    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, exitosoB                # Carga la dirección del mensaje "Éxito, el cálculo de Vf (m/s) es:" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f9                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante

    jal desea_salir

calcular_A:
    #verifico que tengan los valores necesarios no excuidos

    li.s $f7, 120.0
    c.eq.s $f3, $f7
    bc1t error_es_120

    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    li.s $f7, 0.0           # Cargo 0.0 en $f7 para comparar
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f3, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # A = (Vf - Vi) / T
    sub.s $f10, $f3, $f2
    div.s $f9, $f10, $f6
    
    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, exitosoC                # Carga la dirección del mensaje "Éxito, el cálculo de A (m/s^2) es:" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f9                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante

    jal desea_salir

calcular_D:
    #verifico que tengan los valores necesarios no excuidos

    li.s $f7, 120.0
    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    li.s $f7, 0.0           # Cargo 0.0 en $f7 para comparar
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # D = Vi * T + 0.5 * A * T^2
    mul.s $f0, $f2, $f6       # Vi * T
    mul.s $f1, $f4, $f6       # A * T
    mul.s $f1, $f1, $f6       # A * T^2
    li.s $f7, 0.5
    mul.s $f1, $f1, $f7       # 0.5 * A * T^2
    add.s $f9, $f0, $f1       # D = Vi * T + 0.5 * A * T^2
    
    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, exitosoD                # Carga la dirección del mensaje "Éxito, el cálculo de A (m) es:" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f9                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante

    jal desea_salir

calcular_T:
    #verifico que tengan los valores necesarios no excuidos

    li.s $f7, 120.0
    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    li.s $f7, 0.0           # Cargo 0.0 en $f7 para comparar
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # T = (Vf - Vi) / A
    sub.s $f10, $f3, $f2
    div.s $f9, $f10, $f4
    
    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, exitosoD                # Carga la dirección del mensaje "Éxito, el cálculo de A (m) es:" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f9                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante

    jal desea_salir

error_es_120:
    li $v0, 4
    la $a0, error_120
    syscall
    j salir

error_es_neg:
    li $v0, 4
    la $a0, error_neg
    syscall
    j salir

desea_salir:
    li $v0, 8               # Leer cadena de entrada
    la $a0, buffer          # Dirección de almacenamiento
    li $a1, 20              # Tamaño máximo
    syscall

    # Remover salto de línea del buffer (si está presente)
    la $t0, buffer          # Dirección del buffer
    li $t1, 0               # Índice
remover_salto:
    lb $t2, 0($t0)          # Leer byte actual
    beq $t2, 10, fin_remover # Si es '\n', termina
    beq $t2, 0, fin_remover # Si es '\0', termina
    addi $t0, $t0, 1        # Incrementar posición en buffer
    j remover_salto
fin_remover:
    sb $zero, 0($t0)        # Reemplazar '\n' por '\0'

    # Comparar cadenas
    la $t0, salir_opcion    # Dirección de la palabra "salir"
    la $t1, buffer          # Dirección de la entrada
comparar_cadenas:
    lb $t2, 0($t0)          # Leer byte de "salir"
    lb $t3, 0($t1)          # Leer byte de buffer
    beq $t2, $t3, continuar # Si coinciden, continuar
    bne $t2, $zero, nuevo_calculo # Si no coinciden y no es fin de cadena, ir a nuevo_calculo
    b nuevo_calculo         # No coincide la cadena
continuar:
    beq $t2, $zero, salir   # Si ambos son '\0', es igual
    addi $t0, $t0, 1        # Siguiente byte en "salir"
    addi $t1, $t1, 1        # Siguiente byte en buffer
    j comparar_cadenas

salir:
    # Salir del programa
    li $v0, 10
    syscall
