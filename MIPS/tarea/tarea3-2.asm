.data
    prompt: .asciiz "Ingrese un numero flotante o NaN: "   # Mensaje para pedir la entrada
    result_msg: .asciiz "El numero al cuadrado es: "
    error_msg: .asciiz "Error: El numero ingresado es un numero NaN\n"
    newline: .asciiz "\n"
    nan_value: .float 0x7fc00000  # Valor de NaN en formato IEEE 754, usando la directiva .float

.text
    .globl main

main:
    # Solicitar al usuario que ingrese un valor flotante
    li $v0, 4            # Syscall para imprimir string
    la $a0, prompt       # Cargar la dirección del mensaje
    syscall
    
    li $v0, 6            # Syscall para leer número flotante
    syscall
    
    # El valor flotante ingresado se almacena en $f0 (registro de punto flotante)
    
    # Cargar el valor NaN desde la sección de datos
    la $t0, nan_value    # Cargar la dirección de la variable 'nan_value'
    l.s $f2, 0($t0)      # Cargar NaN en $f2
    
    # Comprobar si el número ingresado es NaN
    c.eq.s $f0, $f2      # Comparar el número ingresado con NaN
    bc1t is_nan          # Si es NaN, ir a la etiqueta is_nan
    
    # Si no es NaN, cuadramos el número
    mul.s $f2, $f0, $f0  # $f2 = $f0 * $f0 (cuadrado del número)
    
    # Mostrar el mensaje "El número al cuadrado es: "
    li $v0, 4            # Syscall para imprimir string
    la $a0, result_msg   # Cargar la dirección del mensaje
    syscall
    
    # Imprimir el resultado del cuadrado
    li $v0, 2            # Syscall para imprimir número flotante
    mov.s $f12, $f2      # Cargar el resultado en $f12
    syscall
    
    # Imprimir una nueva línea
    li $v0, 4            # Syscall para imprimir string
    la $a0, newline      # Cargar la dirección de la nueva línea
    syscall
    
    j end_program        # Salir del programa

is_nan:
    # Si se ingresó NaN, imprimir el mensaje de error
    li $v0, 4            # Syscall para imprimir string
    la $a0, error_msg    # Cargar la dirección del mensaje de error
    syscall
    
    # Imprimir una nueva línea
    li $v0, 4            # Syscall para imprimir string
    la $a0, newline      # Cargar la dirección de la nueva línea
    syscall
    
end_program:
    li $v0, 10           # Syscall para terminar el programa
    syscall
