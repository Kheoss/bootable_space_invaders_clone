.global init
.code16
.text
init:

    mov $0x02, %ah                              # hey cpu! I need more memory!!!!
    mov $100, %al                               # read one mem sector  please
    mov $0x80, %dl                              # I'll just assume wikipedia knows better and let this number here

    mov $0, %ch                                 # cilynder 
    mov $0, %dh                                 # head nr
    mov $2, %cl                                 # this is actually the second segment we load (first is this one)

    mov $mainLoop, %bx                          # entry point for out 2DRender segment
    int $0x13                                   # cpu, do your thing

    jmp mainLoop

