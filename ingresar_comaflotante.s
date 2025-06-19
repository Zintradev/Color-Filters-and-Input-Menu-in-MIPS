.data
prompt1: .asciiz "Introduce el valor de rojo (float entre 0 y 1): "
prompt2: .asciiz "Introduce el valor de verde (float entre 0 y 1): "
prompt3: .asciiz "Introduce el valor de azul (float entre 0 y 1): "

.text
.globl leer_coma_flotante

leer_coma_flotante:
    # Guardar $ra en la pila
    addi $sp, $sp, -4         # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)            # Guardar $ra en la pila

    # Imprimir el primer mensaje (introducir rojo)
    li $v0, 4                 # syscall para imprimir texto
    la $a0, prompt1           # cargar la dirección de prompt1
    syscall

    # Leer el valor de rojo (float)
    li $v0, 6                 # syscall para leer float
    syscall
    mov.s $f3, $f0            # almacenar el valor en el registro flotante f3

    # Imprimir el segundo mensaje (introducir verde)
    li $v0, 4                 # syscall para imprimir texto
    la $a0, prompt2           # cargar la dirección de prompt2
    syscall

    # Leer el valor de verde (float)
    li $v0, 6                 # syscall para leer float
    syscall
    mov.s $f1, $f0            # almacenar el valor en el registro flotante f1

    # Imprimir el tercer mensaje (introducir azul)
    li $v0, 4                 # syscall para imprimir texto
    la $a0, prompt3           # cargar la dirección de prompt3
    syscall

    # Leer el valor de azul (float)
    li $v0, 6                 # syscall para leer float
    syscall
    mov.s $f2, $f0            # almacenar el valor en el registro flotante f2

    # Convertir los valores flotantes a enteros (escala de 255)
    li.s $f4, 255.0           # Cargar el valor de 255.0 (escala de color)
    mul.s $f3, $f3, $f4       # multiplicar rojo por 255
    mul.s $f1, $f1, $f4       # multiplicar verde por 255
    mul.s $f2, $f2, $f4       # multiplicar azul por 255

    # Convertir cada valor a entero (eliminando la parte fraccionaria)
    trunc.w.s $f3, $f3        # truncar a entero (rojo)
    trunc.w.s $f1, $f1        # truncar a entero (verde)
    trunc.w.s $f2, $f2        # truncar a entero (azul)

    # Guardar los valores de rojo, verde y azul en la pila
    addi $sp, $sp, -12        # Reservar espacio para los tres valores enteros
    mfc1 $t0, $f3             # Mover valor rojo a $t0
    sw $t0, 8($sp)            # Guardar rojo en la pila
    mfc1 $t1, $f1             # Mover valor verde a $t1
    sw $t1, 4($sp)            # Guardar verde en la pila
    mfc1 $t2, $f2             # Mover valor azul a $t2
    sw $t2, 0($sp)            # Guardar azul en la pila

    # Recuperar los valores de rojo, verde y azul de la pila
    lw $t0, 8($sp)            # Recuperar rojo de la pila
    lw $t1, 4($sp)            # Recuperar verde de la pila
    lw $t2, 0($sp)            # Recuperar azul de la pila
    addi $sp, $sp, 12         # Liberar espacio reservado para los valores

    # Combinar los valores de color en un solo número hexadecimal
    sll $t0, $t0, 16          # mover el valor rojo a los 16 bits más significativos
    sll $t1, $t1, 8           # mover el valor verde a los 8 bits
    or  $t1, $t1, $t0         # combinar rojo y verde
    or  $t1, $t1, $t2         # combinar azul con el resultado anterior

    # Almacenar el resultado final en t1
    # El valor en t1 ahora representa el color en formato hexadecimal.

    # Restaurar $ra y regresar
    lw $ra, 0($sp)            # Restaurar $ra
    addi $sp, $sp, 4          # Liberar espacio en la pila
    jr $ra                    # Regresar al punto de llamada
