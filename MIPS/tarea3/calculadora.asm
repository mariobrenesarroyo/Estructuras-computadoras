.data
# Mensajes
bienvenida:    .asciiz "Bienvenido, ingrese valores flotantes (110 para calcular, 120 para excluir):\n formulas usadas Vi = Vf - A * T \n Vf = Vi + A * T \n A = (Vf - Vi) / T \n D = Vi * T + 0.5 * A * T^2 \n T = (Vf - Vi) / A \n"
ingreseA:      .asciiz "Ingrese valor Vi (m/s): "
ingreseB:      .asciiz "Ingrese valor Vf (m/s): "
ingreseC:      .asciiz "Ingrese valor A (m/s^2): "
ingreseD:      .asciiz "Ingrese valor D (m): "
ingreseE:      .asciiz "Ingrese valor T (s): "
error_120:     .asciiz "Error: el valor es 120.0 y no se puede realizar el cálculo.\n"
error_neg:     .asciiz "Error: el valor es negativo y no se puede realizar el cálculo.\n"
exitosoA:      .asciiz "Éxito, el cálculo de Vi (m/s) es:"
exitosoB:      .asciiz "Éxito, el cálculo de Vf (m/s) es: "
exitosoC:      .asciiz "Éxito, el cálculo de A (m/s^2) es: "
exitosoD:      .asciiz "Éxito, el cálculo de D (m) es: "
exitosoE:      .asciiz "Éxito, el cálculo de T (s) es: "
ingrese_salir: .asciiz "Ingrese cualquier tecla  para un nuevo cálculo o  la palabra salir para salir: "
salir_opcion:  .asciiz "salir"
newline:       .asciiz "\n"

buffer: .space 20 # Espacio para almacenar la cadena de entrada
valor_0: .float 0.0             # Definir 0.0 en la sección de datos
valor_120: .float 120.0         # Definir 120.0 en la sección de datos
valor_110: .float 110.0         # Definir 120.0 en la sección de datos
valor_05:  .float 0.5           # Definir 120.0 en la sección de datos


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
    li $v0, 4       # Print string
    la $a0, ingreseA  # Load address of prompt message
    syscall
    li $v0, 6       # Read float
    syscall
    mov.s $f2, $f0  # Vi -> $f2

    # leer vf
    li $v0, 4       # Print string
    la $a0, ingreseB  # Load address of prompt message
    syscall
    li $v0, 6       # Read float
    syscall
    mov.s $f3, $f0  # Vf -> $f3   

    # leer A
    li $v0, 4       # Print string
    la $a0, ingreseC  # Load address of prompt message
    syscall
    li $v0, 6       # Read float
    syscall
    mov.s $f4, $f0   # A -> $f4

    #leer D
    li $v0, 4       # Print string
    la $a0, ingreseD  # Load address of prompt message
    syscall
    li $v0, 6       # Read float
    syscall
    mov.s $f5, $f0   # D -> $f5

    # leer t
    li $v0, 4       # Print string
    la $a0, ingreseE  # Load address of prompt message
    syscall
    li $v0, 6       # Read float
    syscall
    mov.s $f6, $f0   # T -> $f6
    
    j validar_y_calcular
    

    



validar_y_calcular:

    # Realizar cálculos según el valor desconocido
    la   $a0, valor_110      # Cargar la dirección de la variable "valor_110" en $a0
    l.s  $f7, 0($a0)         # Cargar 0.0 desde la dirección en $a0 a $f7
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
    la   $a0, valor_120      # Cargar la dirección de la variable "valor_120" en $a0
    l.s  $f7, 0($a0)         # Cargar 0.0 desde la dirección en $a0 a $f7
    c.eq.s $f3, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    la   $a0, valor_0      # Cargar la dirección de la variable "valor_0" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.lt.s $f3, $f7         # ¿$f3 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error


    # Vi = Vf - A * T
    mul.s $f10, $f4, $f6   # A * T -> $f10
    sub.s $f9, $f3, $f10   # Vf - (A * T) -> $f9 (Vi)

    # Display the result
    la $a0, exitosoA       # Load address of message into $a0
    li $v0, 4              # System call for printing string
    syscall                # Print the message

    mov.s $f12, $f9        # Move Vi from $f9 to $f12 for printing
    li $v0, 2              # System call for printing float
    syscall                # Print Vi
    j desea_salir




calcular_Vf:

    #verifico que tengan los valores necesarios no excuidos

    la   $a0, valor_120      # Cargar la dirección de la variable "valor_120" en $a0
    l.s  $f7, 0($a0)         # Cargar 0.0 desde la dirección en $a0 a $f7
    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    la   $a0, valor_0      # Cargar la dirección de la variable "valor_0" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # Vf = Vi + A * T
    mul.s $f10, $f4, $f6   # A * T -> $f10
    add.s $f9, $f2, $f10   # Vi + (A * T) -> $f9 (Vf)

    # Display the result
    la $a0, exitosoB       # Load address of message into $a0
    li $v0, 4              # System call for printing string
    syscall                # Print the message

    mov.s $f12, $f9        # Move Vf from $f9 to $f12 for printing
    li $v0, 2              # System call for printing float
    syscall                # Print Vf

    j desea_salir

calcular_A:
    #verifico que tengan los valores necesarios no excuidos

    la   $a0, valor_120      # Cargar la dirección de la variable "valor_120" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.eq.s $f3, $f7
    bc1t error_es_120

    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    la   $a0, valor_0      # Cargar la dirección de la variable "valor_0" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f3, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # A = (Vf - Vi) / T
    sub.s $f10, $f3, $f2   # Vf - Vi -> $f10
    div.s $f9, $f10, $f6   # (Vf - Vi) / T -> $f9 (A)

    # Display the result
    la $a0, exitosoC       # Load address of message into $a0
    li $v0, 4              # System call for printing string
    syscall                # Print the message

    mov.s $f12, $f9        # Move A from $f9 to $f12 for printing
    li $v0, 2              # System call for printing float
    syscall                # Print A

    j desea_salir          # Jump to desea_salir

calcular_D:
    #verifico que tengan los valores necesarios no excuidos

    la   $a0, valor_120      # Cargar la dirección de la variable "valor_120" en $a0
    l.s  $f7, 0($a0)         # Cargar 0.0 desde la dirección en $a0 a $f7
    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    la   $a0, valor_0      # Cargar la dirección de la variable "valor_0" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # D = Vi * T + 0.5 * A * T^2
    mul.s $f10, $f2, $f6       # Vi * T -> $f10
    mul.s $f11, $f4, $f6       # A * T -> $f11
    mul.s $f11, $f11, $f6       # A * T^2 -> $f11

    la   $a0, valor_05      # Load address of valor_05 (0.5) into $a0
    l.s  $f7, 0($a0)         # Load 0.5 from the address in $a0 to $f7

    mul.s $f11, $f11, $f7       # 0.5 * A * T^2 -> $f11
    add.s $f9, $f10, $f11       # D = Vi * T + 0.5 * A * T^2 -> $f9

    # Display the result
    la $a0, exitosoD       # Load address of message into $a0
    li $v0, 4              # System call for printing string
    syscall                # Print the message

    mov.s $f12, $f9        # Move D from $f9 to $f12 for printing
    li $v0, 2              # System call for printing float
    syscall                # Print D

    j desea_salir          # Jump to desea_salir

calcular_T:
    #verifico que tengan los valores necesarios no excuidos

    la   $a0, valor_120      # Cargar la dirección de la variable "valor_120" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.eq.s $f2, $f7
    bc1t error_es_120

    c.eq.s $f4, $f7
    bc1t error_es_120

    c.eq.s $f6, $f7
    bc1t error_es_120

    # Verifico que los valores no sean negativos

    la   $a0, valor_0      # Cargar la dirección de la variable "valor_0" en $a0
    l.s  $f7, 0($a0)       # Cargar 0.0 desde la dirección en $a0 a $f7
    c.lt.s $f2, $f7         # ¿$f2 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f4, $f7         # ¿$f4 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    c.lt.s $f6, $f7         # ¿$f6 < 0.0?
    bc1t error_es_neg       # Si es verdadero, salta a error_es_neg

    # Continúa con el resto del programa si no hay error

    # T = (Vf - Vi) / A
    sub.s $f10, $f3, $f2   # Vf - Vi -> $f10
    div.s $f9, $f10, $f4   # (Vf - Vi) / A -> $f9 (T)
    
    # Display the result
    la $a0, exitosoE       # Load address of message into $a0  (Changed to exitosoE)
    li $v0, 4              # System call for printing string
    syscall                # Print the message

    mov.s $f12, $f9        # Move T from $f9 to $f12 for printing
    li $v0, 2              # System call for printing float
    syscall                # Print T

    j desea_salir          # Jump to desea_salir

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
    li $v0, 4           # Print string
    la $a0, newline     # Load address of newline character
    syscall             # Print newline

    li $v0, 4           # Print string
    la $a0, ingrese_salir # Load address of prompt message
    syscall
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
