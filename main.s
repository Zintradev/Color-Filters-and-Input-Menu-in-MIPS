.data
     men_num: .asciiz "\nPrograma COLORES\n
                Pulse la inicial para seleccionar operación:\n
                <H> Leer color en formato hexadecimal (ej: FF00FF)\n
                <N> Leer color con niveles r-g-b (ej: 0.5 1.0 0.0)\n
                <I> Consulta\n
                <R> Aplicar filtro rojo\n
                <V> Aplicar filtro verde\n
                <A> Aplicar filtro azul\n
                <Y> Aplicar filtro amarillo\n
                <C> Aplicar filtro cian\n
                <M> Aplicar filtro magenta\n
                <S> Salir\n
                Ingrese su eleccion(minuscula):"
    invalid_option: .asciiz "\nOpción inválida. Por favor, seleccione una opción válida.\n"
    filter_applied: .asciiz "\nFiltro aplicado con éxito.\n"
    newline: .asciiz "\n"

.text
.globl main

main:
    addi $sp, $sp, -8        # Reservar espacio en la pila para guardar $ra y $t0, $sp stack pointer que apunta a la cima de la pila
    sw $ra, 4($sp)           # Guardar el valor de $ra en la pila
    sw $t0, 0($sp)           # Guardar el valor de $t0 en la pila

    # Mostrar el menú en pantalla
    li $v0, 4               # Código de syscall para imprimir string
    la $a0, men_num         # Dirección del mensaje
    syscall                 # Llamada al sistema

    # Leer el carácter de la opción seleccionada
    li $v0, 12              # Código de syscall para leer carácter
    syscall                 # Llamada al sistema
    move $t0, $v0           # Guardar el carácter leído en $t0

    # Esperar a que el usuario presione "Enter"
    li $v0, 12              # Código de syscall para leer carácter
    syscall                 # Llamada al sistema (se espera que el usuario presione Enter)

    # Verificar la opción seleccionada
    beq $t0, 'h', call_leer_hexadecimal
    beq $t0, 'n', call_leer_coma_flotante
    beq $t0, 'i', call_consulta
    beq $t0, 'r', call_aplicar_filtro_rojo
    beq $t0, 'v', call_aplicar_filtro_verde
    beq $t0, 'a', call_aplicar_filtro_azul
    beq $t0, 'y', call_aplicar_filtro_amarillo
    beq $t0, 'c', call_aplicar_filtro_cian
    beq $t0, 'm', call_aplicar_filtro_magenta
    beq $t0, 's', exit      

    # Si la opción es inválida, mostrar mensaje de error
    j invalid_option_message

call_leer_hexadecimal:
    jal leer_hexadecimal
    j return_to_main

call_leer_coma_flotante:
    jal leer_coma_flotante
    j return_to_main

call_consulta:
    jal consulta
    j return_to_main

call_aplicar_filtro_rojo:
    jal aplicar_filtro_rojo
    j return_to_main

call_aplicar_filtro_verde:
    jal aplicar_filtro_verde
    j return_to_main

call_aplicar_filtro_azul:
    jal aplicar_filtro_azul
    j return_to_main

call_aplicar_filtro_amarillo:
    jal aplicar_filtro_amarillo
    j return_to_main

call_aplicar_filtro_cian:
    jal aplicar_filtro_cian
    j return_to_main

call_aplicar_filtro_magenta:
    jal aplicar_filtro_magenta
    j return_to_main

return_to_main:
    lw $t0, 0($sp)           # Restaurar el valor de $t0
    lw $ra, 4($sp)           # Restaurar el valor de $ra
    addi $sp, $sp, 8         # Liberar espacio en la pila
    j main                   # Regresar al menú principal

invalid_option_message:
    # Mostrar mensaje de error
    li $v0, 4               # Código de syscall para imprimir string
    la $a0, invalid_option   # Mensaje de opción inválida
    syscall                 # Llamada al sistema

    # Volver al inicio del ciclo para mostrar el menú nuevamente
    j main

exit:
    li $v0, 10               # syscall para terminar
    syscall                  # Llamada al sistema
