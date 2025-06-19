.data
    filtro_aplicado: .asciiz "Filtro aplicado\n"
.text

aplicar_filtro_rojo:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Aplicar filtro rojo
    li $t1, 0xFFFFFF         # Inicializa $t1 con el valor 0xFFFFFF (blanco)
    and $t1, $t1, 0xFF0000   # Filtrar rojo

    li $v0, 4                # Mostrar mensaje de filtro aplicado
    la $a0, filtro_aplicado
    syscall

    lw $ra, 0($sp)           # Restaurar $ra
    addi $sp, $sp, 4         # Liberar espacio en la pila
    jr $ra                   # Regresar al punto de llamada

aplicar_filtro_verde:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Aplicar filtro verde
    li $t1, 0xFFFFFF         # Inicializa $t1 con el valor 0xFFFFFF (blanco)
    and $t1, $t1, 0x00FF00   # Filtrar verde

    li $v0, 4                # Mostrar mensaje de filtro aplicado
    la $a0, filtro_aplicado
    syscall

    lw $ra, 0($sp)           # Restaurar $ra
    addi $sp, $sp, 4         # Liberar espacio en la pila
    jr $ra                   # Regresar al punto de llamada

aplicar_filtro_azul:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Aplicar filtro azul
    li $t1, 0xFFFFFF         # Inicializa $t1 con el valor 0xFFFFFF (blanco)
    and $t1, $t1, 0x0000FF   # Filtrar azul

    li $v0, 4                # Mostrar mensaje de filtro aplicado
    la $a0, filtro_aplicado
    syscall

    lw $ra, 0($sp)           # Restaurar $ra
    addi $sp, $sp, 4         # Liberar espacio en la pila
    jr $ra                   # Regresar al punto de llamada

aplicar_filtro_amarillo:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Aplicar filtro amarillo (rojo + verde)
    li $t1, 0xFFFFFF         # Inicializa $t1 con el valor 0xFFFFFF (blanco)
    and $t1, $t1, 0xFFFF00   # Filtrar amarillo

    li $v0, 4                # Mostrar mensaje de filtro aplicado
    la $a0, filtro_aplicado
    syscall

    lw $ra, 0($sp)           # Restaurar $ra
    addi $sp, $sp, 4         # Liberar espacio en la pila
    jr $ra                   # Regresar al punto de llamada

aplicar_filtro_cian:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Aplicar filtro cian (verde + azul)
    li $t1, 0xFFFFFF         # Inicializa $t1 con el valor 0xFFFFFF (blanco)
    and $t1, $t1, 0x00FFFF   # Filtrar cian

    li $v0, 4                # Mostrar mensaje de filtro aplicado
    la $a0, filtro_aplicado
    syscall

    lw $ra, 0($sp)           # Restaurar $ra
    addi $sp, $sp, 4         # Liberar espacio en la pila
    jr $ra                   # Regresar al punto de llamada

aplicar_filtro_magenta:
    addi $sp, $sp, -4        # Reservar espacio en la pila para $ra
    sw $ra, 0($sp)           # Guardar $ra en la pila

    # Aplicar filtro magenta (rojo + azul)
    li $t1, 0xFFFFFF         # Inicializa $t1 con el valor 0xFFFFFF (blanco)
    and $t1, $t1, 0xFF00FF   # Filtrar magenta

    li $v0, 4                # Mostrar mensaje de filtro aplicado
    la $a0, filtro_aplicado
    syscall

    lw $ra, 0($sp)           # Restaurar $ra
    addi $sp, $sp, 4         # Liberar espacio en la pila
    jr $ra                   # Regresar al punto de llamada

