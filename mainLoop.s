.data
frameCounter: .word 0                           # simple timer
playerMovementDirection : .word 0
playerX : .word 0
playerY : .word 0
playerSpeed: .word 0
currentScore: .word 0
highScore: .word 0
                                                # Yayy, we've just doubled our memory need (320 > 256 => 1 byte is not enough)
bulletsCoord: .skip 80                          # alocate 40 bytes for 20 bullets (2 bytes for position x, 2 bytes for y)
enemiesCoord: .skip 120                         # 20 enemies on the screen in the same time is enough (2 bytes per coordonate + one for health)
enemyBulletsCoord: .skip 80                     # 6 bullets on the same time on screen (2bytes for Xcoord 2bytes for Ycoord)

enemyNumber: .word 0

shootOrder: .skip 60                            # shooting order containing 30 items
currentShootPos: .word 0

isAlive: .word 0

recordesListed: .word 0

menuActiveButton: .word 0

infoButtonColor: .word 0
startButtonColor: .word 0

currentStage: .word 0
deathEnemies: .word 0

currentNumberOfEnemies: .word 0

isBetweenStages: .word 0
framesBeforeShoot: .word 0
spritePointer: .word 0

topScores: .skip 20                           # 10 highscores
topScoresNumber: .word 0

.text
highScoreText: .asciz "Top Scores"
playButtonText: .asciz "Play"
infoButtonText: .asciz "Scoreboard"
stageInfoText: .asciz "Stage cleared"
noRecordsText: .asciz "No records available"
exitRecordsButton: .asciz " Great!"
#logoTitleText: .asciz "(totally not)"
logoTitleText: .asciz "Space Invaders"

.section .mainLoop

mainLoop:
  #get into graphics mode 13
  mov $0x13, %ax
  int $0x10

  mov $0, topScoresNumber

  jmp mainMenuRender

#_________________________________________main menu______________________________________
renderTheBasicScreen:
    push %bp
    mov %sp, %bp

    mov $120, %di
    mov $120, %si
    mov $0, %dx
    push $90
    push $5
    lea logoSprite, %bx
    mov %bx, spritePointer
    call drawSprite
    add $4, %sp

    mov $20, %di
    mov $20, %si
    mov $0, %dx
    push $100
    push $0
    lea enemySprite, %bx
    mov %bx, spritePointer
    call drawSprite
    add $4, %sp

    mov $20, %di
    mov $20, %si
    mov $0, %dx
    push $185
    push $10
    lea enemySprite, %bx
    mov %bx, spritePointer
    call drawSprite
    add $4, %sp

    mov $20, %di
    mov $20, %si
    mov $0, %dx
    push $45
    push $135
    lea enemySprite, %bx
    mov %bx, spritePointer
    call drawSprite

    add $4, %sp
    mov $logoTitleText, %di
    mov $12, %si
    mov $14, %dx
    call writeStringOnScreen

    


  mov startButtonColor, %dx
  mov $20, %di
  mov $100, %si
  push $10
  push $153
  call drawRect
  add $4, %sp

  mov $0, %dx
  mov $15, %di
  mov $90, %si
  push $15
  push $156
  call drawRect
  add $4, %sp


  mov infoButtonColor, %dx
  mov $20, %di
  mov $100, %si
  push $194
  push $153
  call drawRect
  add $4, %sp


  mov $0, %dx
  mov $15, %di
  mov $90, %si
  push $199
  push $156
  call drawRect
  add $4, %sp


  mov $playButtonText, %di
  mov $ 6, %si
  mov $20, %dx
  call writeStringOnScreen

  mov $infoButtonText, %di
  mov $ 26, %si
  mov $20, %dx
  call writeStringOnScreen

    mov %bp, %sp
    pop %bp
    ret

mainMenuRender:
    call clearWholeScreen
    mov $3, startButtonColor
    mov $12, infoButtonColor
    mov $1, menuActiveButton
    mov $0, recordesListed
    call renderTheBasicScreen
    jmp mainMenuRenderLoop

keyboardEventHandlerMenu:
  mov $0, %ax
  mov $0x00, %ah
  int $0x16
  jnz keyboardHandlerMenu

keyboardHandlerMenu:
    mov recordesListed, %bx
    
    cmp $0, %bx
    jg keyboardHandlerForRecord

    cmpb $'a', %al
    je selectTheStartButton
    cmpb $'d', %al
    je selectInfoButton
    cmpb $' ', %al
    je choseThisOption

    jmp mainMenuRenderLoop2

keyboardHandlerForRecord:
    cmpb $' ', %al
    je exitRecords
    
    jmp mainMenuRenderLoop2

exitRecords:
    call clearWholeScreen
    call renderTheBasicScreen
    mov $0, recordesListed

    jmp mainMenuRenderLoop2

choseThisOption:
    mov menuActiveButton, %ax
    cmp $0, %ax
    jl displayInfos

    call clearWholeScreen
    jmp gameInit

displayInfos:
    mov $1, recordesListed
    call clearWholeScreen

    mov infoButtonColor, %dx
    mov $13, %di
    mov $65, %si
    push $107
    push $157
    call drawRect
    add $4, %sp

    mov $exitRecordsButton, %di
    mov $14, %si
    mov $20, %dx
    call writeStringOnScreen

    cmp $0, highScore
    je displayNoRecord

    mov $highScoreText, %di
    mov $14, %si 
    mov $2, %dx
    call writeStringOnScreen

    #mov highScore, %di
    #mov $25, %si
    #mov $2, %dx
    #call writeNumberOnScreen


    call writeTopScoresOnScreen


    jmp mainMenuRenderLoop2

writeTopScoresOnScreen:
    push %bp
    mov %sp, %bp
    call sortTopScores
    mov $0, %di
    mov $4, %dx
    jmp writeTopScoresOnScreenLoop


writeTopScoresOnScreenLoop:
    mov topScoresNumber, %ax
    cmp %ax, %di
    jge writeTopScoresOnScreenEnd

    lea topScores, %bx
    add %di, %bx
    add %di, %bx
    push %di
    push %dx
    
    mov (%bx), %di
    mov $20, %si
    call writeNumberOnScreen
    
    pop %dx
    pop %di
    inc %di
    add $2, %dx

    jmp writeTopScoresOnScreenLoop

writeTopScoresOnScreenEnd:
    mov %bp, %sp
    pop %bp
    ret


displayNoRecord:
    mov $noRecordsText, %di
    mov $10, %si
    mov $2, %dx
    call writeStringOnScreen
    jmp mainMenuRenderLoop2

mainMenuRenderLoop:
  mov $0, %ax
  mov $0x01, %ah
  int $0x16
  jnz keyboardEventHandlerMenu

  jmp mainMenuRenderLoop2

selectInfoButton:
  mov $-1, menuActiveButton
  mov $12, startButtonColor
  mov $3, infoButtonColor
  call renderTheBasicScreen
  jmp mainMenuRenderLoop2

selectTheStartButton:
  mov $1, menuActiveButton
  mov $12, infoButtonColor
  mov $3, startButtonColor
  call renderTheBasicScreen
  jmp mainMenuRenderLoop2

mainMenuRenderLoop2:

  jmp mainMenuRenderLoop

#___________________________________end_main_menu_______________________________________________
gameInit:
  mov $1, isAlive
  mov $20, enemyNumber
  mov $0, playerMovementDirection               # making possible some sort of handmade multi key presses
  mov $2, playerSpeed                           # default speed
  mov $60, playerX
  mov $150, playerY
  mov $0, currentScore
  mov $1, currentStage
  mov $0, isBetweenStages
  mov $6, currentNumberOfEnemies
  mov currentNumberOfEnemies, %ax

  mov %ax,deathEnemies
  call initShootOrder

  call initEnemiesLine
  call initEnemyBullets

  call drawEnemies

  jmp update                                    # start the game

update:                                         # game main loop
  mov isAlive, %ax
  cmp $0, %ax
  jle die                                       # we've died, let's restart the thing
  call clearScreenBuffer                        # clear the screen buffer

  mov $0, %ax
  mov $0x01, %ah
  int $0x16
  jnz keyboardHandler

updatePart2:                                    # nothing to see here, just an update function doing it's stuff

  call updatePlayer
  call updateBullet
  call updateEnemyBullet
  call drawPlayer
  call drawEnemies
  call drawEnemyBullets
  call drawBullets


  mov isBetweenStages, %ax
  #cmp $0, %ax
  #jne skipDrawinEnemies

skipDrawinEnemies:
  mov currentScore, %di
  mov $40, %si
  mov $1, %dx
  call writeNumberOnScreen

  #mov highScore, %di
  #mov $3, %si
  #mov $1, %dx
  #call writeNumberOnScreen


  call incrementFrameCounter                    # timer
  call waitForFrame                             # wait for frame
  jmp update

addScoreToList:
    push %bp
    mov %sp, %bp

    mov topScoresNumber, %ax
    lea topScores, %bx
    add %ax, %bx
    add %ax, %bx

    mov currentScore, %ax

    mov %ax, (%bx)                      #store the score

    inc topScoresNumber

    mov %bp, %sp
    pop %bp
    ret

die:
    call clearWholeScreen
    call addScoreToList
    mov highScore, %ax
    mov currentScore, %bx
    cmp %ax, %bx
    jle dieWithoutHighScore
    mov %bx, highScore

dieWithoutHighScore:
    jmp mainMenuRender

  randomEnemyShoot:
    push %bp
    mov %sp, %bp

    mov $0, %di
    mov $-1, %cx
    jmp shootLoop

enemyShootReturn:
    mov %bp, %sp
    pop %bp
    ret


keyboardHandler:
    mov $0, %ax
    mov $0x00, %ah
    int $0x16                               # give the cpu another slap to clear the buffer ( TO DO: change to pasive pooling 
    jnz keyboardReader

    jmp updatePart2

keyboardReader:                              # finally, we can get the keycode
    cmp $'a', %al
    je incrementPlayerX
    cmp $'d', %al
    je decrementPlayerX
    cmp $' ', %al
    je shoot

    mov $0, playerMovementDirection

    jmp updatePart2

shoot:
    mov $0, %di
    mov $1, %cx

shootLoop:
    cmp $20, %di
    je exitShootLoop

    lea bulletsCoord, %bx                    #stard in the right momery point
    #get the first byte
    cmp $0, %cx
    jge continueShootLoop
    lea enemyBulletsCoord, %bx

continueShootLoop:
    mov %di, %ax
    mov $4, %si                              # jump in the good position
    mul %si
    add %ax, %bx

    add $2, %bx
    cmp $200, (%bx)
    jge putHereEnemy                             # for enemy ammos

    cmp $0, (%bx)
    jle putHere

    inc %di
    jmp shootLoop

putHereEnemy:

    push %bx

    mov currentShootPos, %bx

    mov (%bx), %bx

    cmp $-1, %bx
    jg putHereEnemyContinue

    lea shootOrder, %bx
    mov %bx, currentShootPos
    mov (%bx), %bx

putHereEnemyContinue:
    mov $2, %si
    mov %bx, %ax
    mov $0, %dx
    mul %si

    add $2, currentShootPos

    lea enemiesCoord, %bx

    add %ax, %bx
    add %ax, %bx
    add %ax, %bx

    mov %bx, %si
    mov (%bx), %bx
    #mov %bx, currentScore


    add $4, %si
    mov (%si), %dx
    sub $4, %si
    #mov %dx, currentScore

    cmp $0, %dx
    jle enemyShootReturn
    #sub $2, %bx

   pop %bx

   sub $2, %bx
    push %bx
    mov %si, %bx
    mov (%bx), %ax
    pop %bx

    add $7, %ax                    # add half of the enemy size (10) - half of the bullet size (2.5 aprox 3)

    mov %ax, (%bx)

    add $2, %bx
    push %bx
    mov %si, %bx
    add $2, %bx
    mov (%bx), %ax
    pop %bx
    mov %ax, (%bx)

    jmp enemyShootReturn

putHere:
    sub $2, %bx
    mov playerX, %ax
    add $7, %ax                    # add half of the player size - half of the bullet size
    mov %ax, (%bx)

    add $2, %bx

    mov playerY, %ax
    mov %ax, (%bx)

    jmp exitShootLoop

exitShootLoop:
    jmp updatePart2


incrementPlayerX:
    mov $1, playerMovementDirection
    jmp updatePart2

decrementPlayerX:
    mov $2, playerMovementDirection
    jmp updatePart2


waitForFrame:                       # aproximate some kind of framerate (it will be changed to IRQ1 in a sunny day) 
    push %bp
    mov %sp, %bp

    mov $0, %ax
    mov $0, %cx
    mov $0x8235, %dx                # aprox 30 fps
    #mov $0x1046A, %dx              # aprox 60 fps (too fast for ths small resolution pixel with screen)
    mov $0x86, %ah
    int $0x15                       # not broken, don't fix it

    mov %bp, %sp
    pop %bp
    ret

#___________________State_Management_And_Logic_Update_________________________


incrementFrameCounter:
    push %bp
    mov %sp, %bp
    cmp $0, isBetweenStages
    je incrementInGame                          # some sort of state machine

    inc frameCounter
    mov frameCounter, %ax
    cmp $90, %ax                                # 3 second(ish)
    jl skipBetweenStagesFrame

    call clearWholeScreen
    mov $0, isBetweenStages
    mov $0, frameCounter
    call startNextStage

skipBetweenStagesFrame:
    jmp exitFrameCounter

incrementInGame:                                # game running
    inc frameCounter
    mov frameCounter, %ax
    mov framesBeforeShoot, %si
    cmp %si, %ax
    je enemyDoSomething

continueIncrementInGame:
    mov $3, %si
    cmp $30, %ax                    # 30 frames per second => 1 second(ish) every 30 frame
    je incrementScoreByTime

    jmp exitFrameCounter

enemyDoSomething:
    mov $0, frameCounter
    call randomEnemyShoot
    jmp continueIncrementInGame

exitFrameCounter:
    mov %bp, %sp
    pop %bp
    ret

incrementScoreByTime:
    inc currentScore
    jmp exitFrameCounter

writeNumberOnScreen:
    push %bp
    mov %sp, %bp
    mov %dx, %cx
    push %di

updateScoreLoop:
    dec %si
    pop %ax
    cmp $0, %ax
    je finishUpdateScore
    push %ax

    push %cx
    mov %si, %ax
    mov %al, %dl                                # column number
    mov %cl, %dh                                # row number
    mov $0, %bh                                 # select main page
    mov $0x2, %ah                               # cursor position
    int  $0x10

    pop %cx
    pop %ax

    mov $10, %di
    mov $0, %dx
    div %di
    push %ax
    push %cx
    mov %dx, %ax
    add $48, %al                                # convert in asci
    mov $0x0C, %bl                              # color selection
    mov $0, %bh                                 # again page
    mov $0x0E, %ah                              # teletype
    int $0x10
    pop %cx
    jmp updateScoreLoop


finishUpdateScore:
    mov %bp, %sp
    pop %bp
    ret

updatePlayer:
    push %bp
    mov %sp, %bp

    mov playerMovementDirection, %ax

    cmp $1, %ax
    je moveLeft
    cmp $2, %ax
    je moveRight

updatePlayerFinish:
    mov %bp, %sp
    pop %bp
    ret

moveLeft:
    cmp $0, playerX
    jle updatePlayerFinish                          # the memory on video card in "circular" so let's not teleport from one side of the screen to anothe

    mov playerSpeed, %ax
    sub %ax, playerX
    jmp updatePlayerFinish

moveRight:
    cmp $300, playerX
    jge updatePlayerFinish

    mov playerSpeed, %ax
    add %ax, playerX
    jmp updatePlayerFinish

#__________Update_Player_Bullets_Update_____________
updateBullet:
    push %bp
    mov %sp, %bp
    mov $0, %di
updateBulletLoop:
    cmp $20, %di
    je endUpdateBullet

    lea bulletsCoord, %bx
    mov %di, %ax
    mov $4, %si
    mov $0, %dx
    mul %si
    add %ax, %bx                    # current bullet
    add $2, %bx

    cmp $0, (%bx)
    jg updateThisBullet

nextBulletLoop:
    inc %di
    jmp updateBulletLoop

updateThisBullet:
    sub $5, (%bx)
    push %di
    push %bx
    mov %bx, %di
    mov $6, %dx
    call checkCollisions
    cmp $-1, %ax
    je bulletHit

bulletHitNext:
    #add $4, %bx
    #mov (%bx),%ax
    #mov %ax, currentScore

    pop %bx
    pop %di
    jmp nextBulletLoop

bulletHit:
    add $2, %bx
    cmp $0, (%bx)
    jle bulletHitNext

    dec (%bx)
    mov $0, (%si)

    mov (%bx), %ax
    cmp $0, %ax
    jg bulletHitNext

    add $2, currentScore
    dec deathEnemies
    call drawEnemies
    call tryNextStage

    jmp bulletHitNext

endUpdateBullet:
    mov %bp, %sp
    pop %bp
    ret

tryNextStage:
    push %bp
    mov %sp, %bp
    mov deathEnemies, %ax
    cmp $0, %ax
    jg tryNextStageEnd

    call initShootOrder2
    mov $1, isBetweenStages
    inc currentStage
    mov $0, frameCounter
    
    mov currentStage, %di
    cmp $60, %di
    je tryNextStage
    mov $31, framesBeforeShoot

continueTryNextStage:
    cmp $15, %di                                    # cap fire rate at a minimum of 15
    jle skipTheDecrement
    dec framesBeforeShoot
skipTheDecrement:
    mov $stageInfoText, %di
    mov $13, %si
    mov $10, %dx
    call writeStringOnScreen

tryNextStageEnd:
    mov %bp, %sp
    pop %bp
    ret

startNextStage:
    push %bp
    mov %sp, %bp

    mov $12, currentNumberOfEnemies
    mov currentNumberOfEnemies, %ax
    mov %ax, deathEnemies                                           #next stage
    call initEnemiesLine
    call drawEnemies

    mov %bp, %sp
    pop %bp
    ret

#_____________End_Player_Bullets_Update____________

#____________Update_Enemy_Bullets__________________

updateEnemyBullet:
    push %bp
    mov %sp, %bp
    mov $0, %di
updateEnemyBulletLoop:
    cmp $20, %di
    je endUpdateEnemyBullet

    lea enemyBulletsCoord, %bx
    mov %di, %ax
    mov $4, %si
    mov $0, %dx
    mul %si
    add %ax, %bx                    # current bullet
    add $2, %bx

    cmp $200, (%bx)
    jl updateThisEnemyBullet

nextEnemyBulletLoop:
    inc %di
    jmp updateEnemyBulletLoop

updateThisEnemyBullet:
    add $5, (%bx)
    push %di
    push %bx
    mov %bx, %di
    call enemyCheckCollisions
    cmp $-1, %ax
    je enemybulletHit
enemybulletHitNext:
    pop %bx
    pop %di
    jmp nextEnemyBulletLoop

enemybulletHit:
    mov $200, (%bx)

    mov $-1, isAlive                                            # oups, we've died
    jmp enemybulletHitNext

endUpdateEnemyBullet:
    mov %bp, %sp
    pop %bp
    ret


#___________End_Update_Enemy_Bullets_______________

#______________Sort_Top_Scores________________________

sortTopScores:
    push %bp
    mov %sp, %bp
    mov $0, %di                                     # first index
sortBigLoop:
    mov topScoresNumber, %ax
    cmp %ax, %di
    jge sortTopScoresEnd

    mov %di, %si
    inc %si                                         # from index1 +1 to topScores.....
    jmp sortSmallLoop

sortSmallLoop:
    mov topScoresNumber, %ax
    cmp %ax, %si
    jge sortSmallLoopEnd

    push %di
    push %si

    lea topScores, %bx
    add %di, %bx
    add %di, %bx

    mov (%bx), %di

    mov $0, %bx
    lea topScores, %bx
    add %si, %bx
    add %si, %bx

    mov (%bx), %si

    cmp %si, %di
    jl switchTheNumbers

    pop %si
    pop %di

    inc %si
    jmp sortSmallLoop

switchTheNumbers:  
    mov %si, %ax
    mov %di, %cx

    pop %si
    pop %di
    
    lea topScores, %bx
    add %si, %bx
    add %si, %bx

    mov %cx, (%bx)

    lea topScores, %bx
    add %di, %bx
    add %di, %bx

    mov %ax, (%bx)

    inc %si
    jmp sortSmallLoop


sortSmallLoopEnd:
    inc %di
    jmp sortBigLoop

sortTopScoresEnd:
    mov %bp, %sp
    pop %bp
    ret

#______________End_Sort_Top_Scores_________________

#_____________End_State_Management_And_Logic_Update____________________________





