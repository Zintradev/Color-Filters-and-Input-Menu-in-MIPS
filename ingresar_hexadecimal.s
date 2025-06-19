.data
result:       .space 7                     # Espacio para almacenar el resultado hexadecimal (máximo 6 dígitos)
prompt:       .asciiz "Introduce un número hexadecimal (máximo 6 dígitos): "  # Mensaje de solicitud

.text
.globl leer_hexadecimal

leer_hexadecimal:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Mostrar mensaje pidiendo un número hexadecimal
    li $v0, 4                    # Código de syscall para imprimir string
    la $a0, prompt               # Dirección del mensaje
    syscall

    # Leer el número hexadecimal introducido por el usuario
    li $v0, 8                    # Código de syscall para leer una cadena
    la $a0, result               # Dirección donde se almacenará la cadena
    li $a1, 8                    # Tamaño máximo de 6 caracteres (7 incluye el nulo)
    syscall

    # Convertir la cadena hexadecimal en número entero
    la $a0, result               # Dirección de la cadena de entrada
    li $t1, 0                    # Inicializar $t1 a 0 (almacenará el valor entero)
    li $t2, 0                    # t2 = índice para recorrer la cadena

convert_to_int:
    lb $t3, 0($a0)               # Cargar el siguiente byte de la cadena (carácter)
    beqz $t3, done_conversion    # (Branch if equal to zero)

    # Comprobar si el carácter es un dígito (0-9)
    li $t4, 48                   # Valor ASCII de '0'
    li $t5, 57                   # Valor ASCII de '9'
    blt $t3, $t4, check_alpha    # Si es menor que '0', ir a comprobar si es letra (Branch if less than)
    ble $t3, $t5, convert_digit  # Si está entre '0' y '9', es un dígito (Branch if less or equal)

check_alpha:
    # Comprobar si el carácter es una letra (A-F o a-f)
    li $t4, 65                   # Valor ASCII de 'A'
    li $t5, 70                   # Valor ASCII de 'F'
    blt $t3, $t4, done_conversion #(Branch if Less Than)
    ble $t3, $t5, convert_uppercase #(Branch if Less Than or Equal to)

    # Si el carácter no es válido, saltar
    j done_conversion

convert_digit:
    li $t4, 48                   # Valor ASCII de '0'
    sub $t3, $t3, $t4            # Restar '0' al carácter (para obtener el valor numérico)('0' -> 0, '1' -> 1, ..., '9' -> 9)
    j add_to_result

convert_uppercase:
    li $t4, 65                   # Valor ASCII de 'A'
    sub $t3, $t3, $t4            # Restar 'A' al carácter (para obtener el valor numérico)
    addi $t3, $t3, 10            # Ajuste para A=10, B=11,...F=15
    j add_to_result

add_to_result:
    mul $t1, $t1, 16             # Multiplicar el número acumulado por 16
    add $t1, $t1, $t3            # Sumar el valor del carácter al número acumulado
    addi $a0, $a0, 1             # Avanzar a la siguiente posición de la cadena
    j convert_to_int

done_conversion:
    lw $ra, 0($sp)               # Restaurar $ra
    addi $sp, $sp, 4             # Liberar espacio en la pila
    jr $ra                       # Regresar al punto de llamada

