# Estudiante: Alex Alberto Varela Quir�s; carn�: B12345; Grupo1; Tarea1

# Explicaci�n del c�digo: 


.data
	# mensajes cargados para imprimir en consola y llamamos car�cteres a usar
	mensaje_one: .asciiz "\n \n PROGRAMA 2 que muestra el uso del SIMULADOR\n"
	mensaje_dos: .asciiz "\n Ingrese entero:  "
	mensaje_three: .asciiz "El entero ingresado es:  "
	
	ingreso: .asciiz "\n Ingrese un numero flotante: "
	mensaje_four: .asciiz "El flotante ingresado es:  "
	
	fin: .asciiz "\n FIN DEL PROGRAMA 2"
	
	fin2: .asciiz "\n FIN DEL PROGRAMA 1"
	#variables ingresadas
	PI: .float 3.14
	
	mensaje_one1: .asciiz "\n\n \t PROGRAMA que muestra el uso de funci�n\n"
	mensajetwo: .asciiz "\n Error! El n�mero N digitado no debe ser negativo (Sucesi�n de Padovan solo contempla positivos) "
	
.text   
	main:   #Funci�n directora, Orquesta la llamada y finaliza
		jal solicitaIN
		
		jal Simulador
		
		
		
		
	
	Simulador:   
		# mensajes mostrar
	 	la $a0, mensaje_one # Carga la direcci�n del dato "mensajeone"
	 	#  Imprimir mensaje sistema
	 	addiu $v0, $zero, 4 # solicita imprimir un string
      	 	syscall
      	   	#jal imprimirString
      	 	
      	 	# mensajes mostrar
	 	la $a0, mensaje_dos # Carga la direcci�n del dato "mensajeone"
	 	jal imprimirString             
      	 
      	 	# Pide entero guarda en v0
	 	li $v0, 5
		syscall
	 	add $t0, $zero, $v0 # Guarda en $a0, $v0 contiene un 1
	 
      	 	# mensajes mostrar
	 	la $a0, mensaje_three # Carga la direcci�n del dato "mensajeone"
	 	# Imprimir mensaje sistema
	 	addiu $v0, $zero, 4 # solicita imprimir un string
      	 	syscall  
      	 
      	 	add $a0, $zero, $t0 # Guarda en $a0, $v0 contiene un 1 
	 	# Imprimir entero sistema
	 	# addiu $v0, $zero, 1 # indica imprimir un entero
	 	# syscall
	 	
	 	jal imprimirEntero
	
	 	# mensajes mostrar
	 	la $a0, ingreso # Carga la direcci�n del dato "ingreso"
	 	addiu $v0, $zero, 4 # solicita imprimir un string
      	 	syscall  
      	 
	 	# Pide flotante guarda en C1 $f0
	 	li $v0, 6
	 	syscall	
	 	mov.s $f12, $f0 #  mueve el n�mero de $f0 a $f12
	 
	 	# mensajes mostrar
	 	la $a0, mensaje_four # Carga la direcci�n del dato "ingreso"
	 	addiu $v0, $zero, 4 # solicita imprimir un string
      	 	syscall  
	 
	 
	 	# Imprimir flotante sistema
	 	# addiu $v0, $zero, 2
	 	# syscall
	 	jal imprimirFlotante
		
		jal Fin_pro
	#**** Funciones con comandos para imprimir string, flotantes, enteros y poner fin del programa
	
	 solicitaIN:
	      addi $sp, $sp, -8 # Pedimos espacio en la pila
              sw $ra, 0($sp)    # Se guarda en pila $ra de la funci�n main
              
              la $a0, mensaje_one1 # Programa 2
              jal  imprimirString 
       	      la $a0, mensaje_dos    # carga en registro $a0 dirrecci�n de memoria referida  mensaje_dos
              jal  imprimirString  # Para imprimir mensaje saltando a la funci�n, imprime mensaje solicitar usuario el ingreso.
        	
	      addiu $v0, $zero, 5 # Para obtener entero int del usuario
	      syscall

              sw $v0, 4($sp) # se guarda en pila el numero entero N solicitado
    
              la $a0, mensaje_three   # Carga la direcci�n del dato "mensaje"
              jal  imprimirString  # Para ejecutar imprimir mensaje saltando a la funci�n, desplegamos strin de mensaje 
        	
              lw $t8, 4($sp)    # se carga en $t8 el n�mero entero que estaba guardado en pila
              addiu $a0, $t8, 0 # Guarda en a0, $t8
              jal  imprimirEntero   # Para ejecutar imprimir entero, mostramos el N ingresado
 
              lw $ra, 0($sp)   # cargamos direccion a main
              lw $v0, 4($sp)   # cargamos direccion a n�mero entero
              addi $sp, $sp, 8 # Restauramos la pila

    	      slti $t9, $t8, 0     # n<0 $t9=1, Hago la comparaci�n para ejecutar la excepci�n
    	      bne $t9, $zero, expt #$t9=0 salte a expt
    	      
       	      jr $ra # Regresamos a funcion main
	
	expt: 
       		la $a0, mensajetwo # para solicitar imprimir un string avisando del error de meter n�meros enteros negativos (excepci�n)
		jal imprimirString    # Para ejecutar imprimir mensaje 
      		j main             #Salto incondicional a main
      	
	Fin_pro:	
		# Fin programa
	 	la $a0, fin # Carga la direcci�n del dato "mensajeone"
	 	addiu $v0, $zero, 4 # solicita imprimir un string
      	 	syscall  	
	 	addiu $v0, $zero, 10 # finaliza el programa
	 	syscall
	 	
	imprimirString:
			addiu $v0, $zero, 4  # imprime str
			syscall
			jr $ra
	imprimirEntero:
			addiu $v0, $zero, 1  # imprime entero
			syscall
			jr $ra
			
	imprimirFlotante: 
			addiu $v0, $zero, 2  # imprime flotante
			syscall
			jr $ra		  
 
