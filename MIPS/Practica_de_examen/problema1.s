# Cargar 0xAAAA en $t2 y realizar AND con $t0
lui $t2, 0xAAAA       # Carga 0xAAAA en los 16 bits superiores de $t2
ori $t2, $t2, 0xAAAA  # Completa los 16 bits inferiores con 0xAAAA
and $t4, $t0, $t2     # Realiza AND entre $t0 y $t2, y almacena el resultado en $t4

# Cargar 0x5555 en $t5 y realizar AND con $t1
lui $t5, 0x5555       # Carga 0x5555 en los 16 bits superiores de $t5
ori $t5, $t5, 0x5555  # Completa los 16 bits inferiores con 0x5555
and $t6, $t1, $t5     # Realiza AND entre $t1 y $t5, y almacena el resultado en $t6

# Realizar OR entre los resultados de las dos operaciones AND y almacenar en $t3
or $t3, $t4, $t6      # Realiza OR entre $t4 y $t6, y almacena el resultado en $t3
