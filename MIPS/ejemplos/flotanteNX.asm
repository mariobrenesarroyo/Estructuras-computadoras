.data
    ingreso: .asciiz "\n Ingrese un numero flotante: "   # Mensaje para solicitar un flotante
    mensaje_four: .asciiz "El flotante ingresado es:  " # Mensaje antes de mostrar el flotante
    x: .asciiz "x"
    n: .asciiz "n"
    ms1: .asciiz "el valor ingresado es una n"
    ms2: .asciiz "el valor ingresado es una x"
    buffer: .space 20 # Espacio para almacenar la cadena de entrada

.text
main:
    # Mostrar mensaje de solicitud
    la $a0, ingreso         # Carga la dirección del mensaje "Ingrese un número flotante"
    addiu $v0,$zero,4            # Llamada al sistema para imprimir string
    syscall

    # Leer número flotante ingresado
    li $v0, 8               # Llamada al sistema para leer una cadena
    la $a0, buffer          # Dirección de almacenamiento de la cadena leída
    li $a1, 20              # Longitud máxima de la cadena
    syscall

    # Llamar a la función de verificación
    jal verificar_entrada

    # Llamar a la función para convertir la cadena a flotante
    jal convertir_cadena_a_float
 

    # Mostrar mensaje antes de imprimir el flotante 
    la $a0, mensaje_four            # Carga la dirección del mensaje "El flotante ingresado es:" 
    addiu $v0,$zero, 4              # Llamada al sistema para imprimir string 
    syscall                         # Imprimir el número flotante ingresado 
    mov.s $f12, $f0                 # Mover el valor flotante al registro $f12 
    li $v0, 2                       # Llamada al sistema para imprimir un número flotante 

    syscall                         # Terminar el programa 
    li $v0, 10                      # Llamada al sistema para salir del programa 
    syscall

verificar_entrada:
    # Verificar si la entrada es 'n' o 'x'
    la $t0, n               # Cargar dirección de "n"
    la $t1, x               # Cargar dirección de "x"
    lb $t2, 0($a0)          # Cargar el primer carácter de la entrada

    # Comparar con 'n'
    lb $t3, 0($t0)
    beq $t2, $t3, es_n

    # Comparar con 'x'
    lb $t4, 0($t1)
    beq $t2, $t4, es_x

    # Si no es 'n' ni 'x', asumir que es un número
    jr $ra

es_n:
    la $a0, ms1             # Cargar dirección del mensaje "el valor ingresado es una n"
    addiu $v0,$zero,4            # Llamada al sistema para imprimir string
    syscall

    # Terminar el programa
    li $v0, 10              # Llamada al sistema para salir del programa
    syscall

es_x:
    la $a0, ms2             # Cargar dirección del mensaje "el valor ingresado es una x"
    addiu $v0,$zero,4            # Llamada al sistema para imprimir string
    syscall

    # Terminar el programa
    li $v0, 10              # Llamada al sistema para salir del programa
    syscall


# Función convertir_cadena_a_float
# Entrada: Dirección de la cadena en $a0
# Salida: Número flotante en $f0

convertir_cadena_a_float:
    # $a0: address of the string
    # Returns: $f0 - the floating-point number

    # Initialize variables
    li $t0, 0       # Integer part
    li $t1, 0       # Fractional part
    li $t2, 0       # Decimal point flag
    li $t3, 10      # For multiplication
    mtc1 $t0, $f0   # Move integer part to $f0
    cvt.s.w $f0, $f0 # Convert to single-precision float
    
loop:
    lb $t4, 0($a0)   # Load a byte from the string
    beqz $t4, end   # If it's null terminator, exit loop
    beq $t4, '.', decimal_point # Check for decimal point
    
    blt $t4, '0', invalid_input  # Check for invalid character
    bgt $t4, '9', invalid_input  # Check for invalid character
    
    sub $t4, $t4, '0'  # Convert ASCII to integer
    
    # If before decimal point (or no decimal point yet)
    bnez $t2, fractional_part 
    
    mul $t0, $t0, $t3 # Multiply current integer part by 10
    add $t0, $t0, $t4 # Add the new digit
    
    # Move updated integer part to $f0
    mtc1 $t0, $f0
    cvt.s.w $f0, $f0  
    
    b next_char
    
fractional_part:
    mul $t1, $t1, $t3 # Multiply current fractional part by 10
    add $t1, $t1, $t4 # Add the new digit
    addi $t2, $t2, 1   # Increment decimal place counter

next_char:
    addi $a0, $a0, 1   # Move to the next character in the string
    j loop
    
decimal_point:
    li $t2, 1       # Set decimal point flag
    j next_char
    
invalid_input:
    # Handle invalid input (e.g., print error message)
    # ...
    jr $ra

end:
    # If no decimal point was found, assume .0
    beqz $t2, assume_decimal_zero 
    
    # Convert fractional part to float and add to integer part
    mtc1 $t1, $f1       # Move fractional part to $f1
    cvt.s.w $f1, $f1   # Convert to single-precision float
    
    # Divide by 10 raised to the power of decimal places
    # (You might need a loop or a separate function for this)
    # Example for 1 decimal place: div.s $f1, $f1, 10.0
    # Adjust for actual number of decimal places using $t2
    # ...
    # For Simplicity assuming one decimal place
    li.s $f2, 10.0
    div.s $f1, $f1, $f2
    
    add.s $f0, $f0, $f1  # Add integer and fractional parts
    
    jr $ra              # Return
    
assume_decimal_zero:
    # If no decimal was found in the string, $f0 already contains the integer part.
    # We don't need to add anything to it as it is implicitly .0
    jr $ra