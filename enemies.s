enemyCheckCollisions:
    push %bp
    mov %sp, %bp
    
    mov $1, %ax

    mov (%di), %si
    mov playerY, %cx

    cmp %cx, %si
    jle enemyCheckCollisionEnd
    add $20, %cx
    cmp %cx, %si
    jge enemyCheckCollisionEnd

    sub $2, %di
    mov (%di), %si

    mov playerX, %cx
    cmp %cx, %si
    jle enemyCheckCollisionEnd

    add $20, %cx

    cmp %cx, %si
    jge enemyCheckCollisionEnd
    mov $-1, %ax
    jmp enemyCheckCollisionEnd

enemyCheckCollisionEnd:
    mov %bp, %sp
    pop %bp
    ret

checkCollisions:
    push %bp
    mov %sp, %bp
    sub $2, %di
    mov %di, %si
    mov currentNumberOfEnemies, %di
    #mov $0, %di
    mov $0, %ax

checkCollisionsLoop:
    cmp $0, %di
    jl checkCollisionsLoopEnd

    # luat individual fiecare inamic
    mov %di, %ax
    mov $0, %ch
    mov $6, %cx
    mov $0, %dx
    mul %cx
    lea enemiesCoord, %bx
    add %ax, %bx

    add $4, %bx
    cmp $0, (%bx)
    jle skipCollisionCheck
    sub $4, %bx

    # dx -> glont X
    # bx -> enemy X
    mov (%bx), %cx                                  # X verification

    cmp %cx, (%si)
    jl skipCollisionCheck

    add $20, %cx
    cmp %cx, (%si)
    jg skipCollisionCheck
    add $2, %bx
    add $2, %si                                    # Y verification

    mov (%bx), %cx
    cmp %cx, (%si)
    jl skipCollisionCheck

    add $20, %cx
    cmp %cx, (%si)
    jg skipCollisionCheck

    mov $-1, %ax

    jmp checkCollisionsLoopEnd

skipCollisionCheck:
    #mov $22, currentScore
    dec %di
    jmp checkCollisionsLoop

checkCollisionsLoopEnd:
    mov %bp, %sp
    pop %bp
    ret

initEnemiesLine:
    push %bp
    mov %sp, %bp
    mov $40, %cx
    mov $10, %dx
    mov $0, %di

initEnemiesLoop:
    cmp currentNumberOfEnemies, %di
    je initEnemiesLoopEnd
    cmp $6, %di
    jne noAnotherRow
    add $30, %dx
    mov $40, %cx

noAnotherRow:
    push %dx
    push %di

    mov %di, %ax
    mov $6, %si
    mov $0, %dx
    mul %si

    lea enemiesCoord, %bx
    add %ax, %bx

    pop %di
    pop %dx

    mov %cx, (%bx)                  # pos X
    add $2, %bx
    mov %dx, (%bx)                  # pos Y
    add $2, %bx
    mov $2, (%bx)                   #HP

    inc %di
    add $40, %cx
    jmp initEnemiesLoop

initEnemiesLoopEnd:
    mov %bp, %sp
    pop %bp
    ret



initEnemyBullets:
    push %bp
    mov %sp, %bp
    mov $0, %di
    lea enemyBulletsCoord, %bx

initEnemyBulletsLoop:
    cmp currentNumberOfEnemies, %di
    je initEnemyEnd

    mov $200, (%bx)
    add $2, %bx
    mov $200, (%bx)

    inc %di
    add $2, %bx

    jmp initEnemyBulletsLoop

initEnemyEnd:
    mov %bp, %sp
    pop %bp
    ret

initShootOrder:
    push %bp
    mov %sp, %bp
    lea shootOrder, %bx
    mov %bx, currentShootPos                # the pointer is ready

    #hard coded values
    mov $3, (%bx)
    add $2, %bx
  
    mov $4, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $2, (%bx)
    add $2, %bx

    mov $2, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $4, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $4, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $2, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx

    mov $-1, (%bx)
    add $2, %bx

    mov %bp, %sp
    pop %bp
    ret

initShootOrder2:
    push %bp
    mov %sp, %bp
    lea shootOrder, %bx
    mov %bx, currentShootPos                # the pointer is ready

    #hard coded values

    mov $2, (%bx)
    add $2, %bx

    mov $7, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $11, (%bx)
    add $2, %bx

    mov $8, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $4, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $6, (%bx)
    add $2, %bx

    mov $2, (%bx)
    add $2, %bx

    mov $7, (%bx)
    add $2, %bx

    mov $9, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $4, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx
    
    mov $5, (%bx)
    add $2, %bx

    mov $4, (%bx)
    add $2, %bx

    mov $5, (%bx)
    add $2, %bx

    mov $8, (%bx)
    add $2, %bx

    mov $6, (%bx)
    add $2, %bx

    mov $2, (%bx)
    add $2, %bx

    mov $1, (%bx)
    add $2, %bx

    mov $3, (%bx)
    add $2, %bx

    mov $8, (%bx)
    add $2, %bx

    mov $-1, (%bx)
    add $2, %bx

    mov %bp, %sp
    pop %bp
    ret


