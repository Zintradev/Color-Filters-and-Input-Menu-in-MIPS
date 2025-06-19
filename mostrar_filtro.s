    .data
# Datos compartidos
rgb_output:   .asciiz "RGB Niveles: "      
rgb_output_float: .asciiz "RGB Flotante: "
cmyk_output: .asciiz "Color CMYK: "
hex_output: .asciiz "Color Hexadecimal: "

open_paren:   .asciiz "("                  
closing_paren: .asciiz ")"                 
comma:        .asciiz ","                  
newline:      .asciiz "\n"                 

hex_chars:    .asciiz "0123456789ABCDEF"   
result:       .space 24                    # Espacio para resultado hexadecimal

    .text
    .globl consulta

consulta:
    # Entrada del programa principal
    # Dependiendo de una condición o entrada del usuario, realiza los saltos
    # Aquí elige a cuál subrutina saltar.
    jal show_rgb           # RGB enteros
    jal show_rgb_float     # RGB flotantes
    jal convert_to_cmyk    # CMYK
    jal prep_space       # Hexadecimal
    j main

# SUBRUTINAS INDIVIDUALES



# --- RGB en niveles enteros ---
show_rgb:
    addi $sp, $sp, -16      # Reservar espacio para $ra y registros temporales
    sw $ra, 12($sp)
    sw $t2, 8($sp)
    sw $t3, 4($sp)
    sw $t4, 0($sp)

    # Procesar componentes RGB
    # Extraer componente rojo (R) desplazando 16 bits a la derecha
    srl $t2, $t1, 16         # R
    # Mantener solo los 8 bits del componente rojo
    andi $t2, $t2, 0xFF
    # Extraer componente verde (G) desplazando 8 bits a la derecha
    srl $t3, $t1, 8          # G
    # Mantener solo los 8 bits del componente verde
    andi $t3, $t3, 0xFF
    # Extraer componente azul (B) manteniendo los 8 bits menos significativos
    andi $t4, $t1, 0xFF      # B

    # Imprimir resultado
    li $v0, 4
    la $a0, rgb_output
    syscall

    li $v0, 4
    la $a0, open_paren
    syscall

    move $a0, $t2
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    move $a0, $t3
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    move $a0, $t4
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, closing_paren
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Restaurar registros y salir
    lw $ra, 12($sp)
    lw $t2, 8($sp)
    lw $t3, 4($sp)
    lw $t4, 0($sp)
    addi $sp, $sp, 16
    jr $ra




# --- RGB en coma flotante ---
show_rgb_float:
    # Procesar componentes RGB
    srl $t2, $t1, 16         # R
    andi $t2, $t2, 0xFF
    srl $t3, $t1, 8          # G
    andi $t3, $t3, 0xFF
    andi $t4, $t1, 0xFF      # B

    addi $sp, $sp, -16      # Reservar espacio para $ra y registros flotantes
    sw $ra, 12($sp)
    swc1 $f0, 8($sp)
    swc1 $f2, 4($sp)
    swc1 $f4, 0($sp)

    # Conversión y cálculo
    # Convertir valor de $t2 (rojo) a float y normalizar (dividir entre 255)
    mtc1 $t2, $f0              # Cargar $t2 en el registro de punto flotante $f0
    cvt.s.w $f0, $f0           # Convertir el valor entero a float (precisión simple)
    li.s $f1, 255.0            # Cargar el valor 255.0 en $f1 (normalización)
    div.s $f0, $f0, $f1        # Dividir el valor de $f0 entre 255.0 (normalizado)

    # Convertir valor de $t3 (verde) a float y normalizar (dividir entre 255)
    mtc1 $t3, $f2              # Cargar $t3 en el registro de punto flotante $f2
    cvt.s.w $f2, $f2           # Convertir el valor entero a float (precisión simple)
    div.s $f2, $f2, $f1        # Dividir el valor de $f2 entre 255.0 (normalizado)

    # Convertir valor de $t4 (azul) a float y normalizar (dividir entre 255)
    mtc1 $t4, $f4              # Cargar $t4 en el registro de punto flotante $f4
    cvt.s.w $f4, $f4           # Convertir el valor entero a float (precisión simple)
    div.s $f4, $f4, $f1        # Dividir el valor de $f4 entre 255.0 (normalizado)


    # Imprimir resultado
    li $v0, 4
    la $a0, rgb_output_float
    syscall

    li $v0, 4
    la $a0, open_paren
    syscall

    li $v0, 2
    mov.s $f12, $f0
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 2
    mov.s $f12, $f2
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 2
    mov.s $f12, $f4
    syscall

    li $v0, 4
    la $a0, closing_paren
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Restaurar registros y salir
    lw $ra, 12($sp)
    lwc1 $f0, 8($sp)
    lwc1 $f2, 4($sp)
    lwc1 $f4, 0($sp)
    addi $sp, $sp, 16
    jr $ra





# --- Conversión a CMYK ---
convert_to_cmyk:
    addi $sp, $sp, -28
    sw $ra, 24($sp)             # Guardar $ra
    swc1 $f0, 20($sp)           # Guardar $f0 (R)
    swc1 $f2, 16($sp)           # Guardar $f2 (G)
    swc1 $f4, 12($sp)           # Guardar $f4 (B)
    swc1 $f6, 8($sp)            # Guardar $f6 (max)
    swc1 $f10, 4($sp)           # Guardar $f10 (K)

    # Convertir R, G, B a flotantes y normalizarlos dividiendo por 255
    # Convertir valor de $t2 (rojo) a float y normalizar (R = R / 255.0)
    mtc1 $t2, $f0              # Cargar $t2 en $f0
    cvt.s.w $f0, $f0           # Convertir entero a float
    li.s $f1, 255.0            # Cargar 255.0 en $f1
    div.s $f0, $f0, $f1        # Dividir $f0 entre 255.0 (R = R / 255.0)

    # Convertir valor de $t3 (verde) a float y normalizar (G = G / 255.0)
    mtc1 $t3, $f2              # Cargar $t3 en $f2
    cvt.s.w $f2, $f2           # Convertir entero a float
    div.s $f2, $f2, $f1        # Dividir $f2 entre 255.0 (G = G / 255.0)

    # Convertir valor de $t4 (azul) a float y normalizar (B = B / 255.0)
    mtc1 $t4, $f4              # Cargar $t4 en $f4
    cvt.s.w $f4, $f4           # Convertir entero a float
    div.s $f4, $f4, $f1        # Dividir $f4 entre 255.0 (B = B / 255.0)

    # Calcular el valor máximo entre R, G, B
    c.lt.s $f0, $f2            # Comparar si R < G
    bc1f no_swap_r_g           # Si R < G, saltar al siguiente paso
    mov.s $f6, $f2             # Si R >= G, el máximo hasta ahora es G
    j compare_with_b           # Saltar a comparar con B


no_swap_r_g:
    mov.s $f6, $f0              # Si R >= G, máximo es R

compare_with_b:
    c.lt.s $f6, $f4             # Comparar el máximo actual (R o G) con B
    bc1f no_swap_max_b          # Si el máximo no es menor que B, saltar
    mov.s $f6, $f4              # Si max(R, G) < B, máximo es B

no_swap_max_b:
    # Calcular K (negro)
    li.s $f1, 1.0               # Cargar 1.0 en $f1
    sub.s $f10, $f1, $f6        # K = 1.0 - max(R, G, B)

    # Si K == 1, asignar C, M, Y a 0
    c.eq.s $f1, $f10            # Comparar si K == 1.0
    bc1t k_equals_1             # Si K == 1.0, saltar a k_equals_1

    # Calcular C
    sub.s $f9, $f6, $f0         # C = (max - R)
    sub.s $f6, $f6, $f10        # (max - K)
    div.s $f9, $f9, $f6         # C = (max - R) / (max - K)

    # Calcular M
    sub.s $f7, $f6, $f2         # M = (max - G)
    div.s $f7, $f7, $f6         # M = (max - G) / (max - K)

    # Calcular Y
    sub.s $f8, $f6, $f4         # Y = (max - B)
    div.s $f8, $f8, $f6         # Y = (max - B) / (max - K)
    j print_values

k_equals_1:
    li.s $f9, 0.0               # C = 0
    li.s $f7, 0.0               # M = 0
    li.s $f8, 0.0               # Y = 0

print_values:
    # Imprimir los valores CMYK
    li $v0, 4
    la $a0, cmyk_output
    syscall

    li $v0, 4
    la $a0, open_paren
    syscall

    li $v0, 2
    mov.s $f12, $f9             # Imprimir C
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 2
    mov.s $f12, $f7             # Imprimir M
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 2
    mov.s $f12, $f8             # Imprimir Y
    syscall

    li $v0, 4
    la $a0, comma
    syscall

    li $v0, 2
    mov.s $f12, $f10            # Imprimir K
    syscall

    li $v0, 4
    la $a0, closing_paren
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    # Restaurar registros desde la pila
    lw $ra, 24($sp)
    lwc1 $f0, 20($sp)
    lwc1 $f2, 16($sp)
    lwc1 $f4, 12($sp)
    lwc1 $f6, 8($sp)
    lwc1 $f10, 4($sp)
    addi $sp, $sp, 28          # Liberar espacio en la pila

    jr $ra                     # Regresar al llamador







# --- Conversión a hexadecimal ---
prep_space:
    addi $sp, $sp, -20          # Reservar espacio en la pila para las variables locales
    sw $ra, 16($sp)             # Guardar $ra (dirección de retorno) en la pila
    sw $t1, 12($sp)             # Guardar $t1 (valor que se convertirá a hexadecimal) en la pila
    sw $t2, 8($sp)              # Guardar $t2 (contador de dígitos) en la pila
    sw $t3, 4($sp)              # Guardar $t3 (base hexadecimal, 16) en la pila

    li $v0, 4                   # Preparar para imprimir el mensaje "hex_output"
    la $a0, hex_output         
    syscall                     

    li $t2, 0                   # Inicializar contador de dígitos a 0
    li $t3, 16                  # Establecer la base hexadecimal (16)

    la $a0, result              # Cargar la dirección de "result"
    addi $a0, $a0, 6            # Ajustar para empezar a escribir en el final de la cadena
    addi $a0, $a0, -1           # Ajustar para empezar en la última posición

convert:
    div $t1, $t3                # Dividir el valor en $t1 entre 16 (base hexadecimal)
    mfhi $t4                     # Obtener el resto (último dígito hexadecimal)
    mflo $t1                     # Obtener el cociente (nuevo valor de $t1)

    la $t5, hex_chars           # Cargar la dirección de los caracteres hexadecimales
    add $t5, $t5, $t4           # Ajustar la dirección según el valor del resto
    lb $t5, 0($t5)              # Cargar el carácter hexadecimal correspondiente
    sb $t5, 0($a0)              # Almacenar el carácter hexadecimal en el resultado

    addi $a0, $a0, -1           # Moverse hacia la izquierda en la cadena
    addi $t2, $t2, 1            # Incrementar el contador de dígitos
    bnez $t1, convert           # Si el cociente no es 0, continuar la conversión

fill_zeros:
    li $t5, 6                   # Establecer el número total de dígitos hexadecimales (6)
    sub $t6, $t5, $t2           # Calcular cuántos ceros agregar
    bgtz $t6, add_zeros         # Si faltan ceros, saltar a la sección de añadir ceros (Branch if greater than zero)

print_hex:
    la $a0, result              # Cargar la dirección del resultado
    li $v0, 4                   # Preparar para imprimir la cadena hexadecimal
    syscall                     # Imprimir el valor hexadecimal

    li $v0, 4                   # Preparar para imprimir una nueva línea
    la $a0, newline             # Cargar la dirección de "newline"
    syscall                     # Imprimir nueva línea

    # Restaurar registros desde la pila
    lw $ra, 16($sp)             # Restaurar el valor de $ra
    lw $t1, 12($sp)             # Restaurar el valor de $t1
    lw $t2, 8($sp)              # Restaurar el valor de $t2
    lw $t3, 4($sp)              # Restaurar el valor de $t3
    addi $sp, $sp, 20           # Liberar espacio en la pila

    jr $ra                      # Regresar al punto de llamada

add_zeros:
    li $t7, 48                  # Cargar el valor ASCII de '0'
    sb $t7, 0($a0)              # Almacenar '0' en el resultado
    addi $a0, $a0, -1           # Moverse hacia la izquierda en la cadena
    addi $t2, $t2, 1            # Incrementar el contador de dígitos
    bnez $t6, fill_zeros        # Si no se han añadido todos los ceros, repetir

