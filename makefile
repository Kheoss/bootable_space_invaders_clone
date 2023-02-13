build:
	as -o boot.o memAlloc.s mainLoop.s 2DRenderer.s enemies.s
	ld -o boot.bin --oformat binary -e init -T linker.ld -o boot.bin boot.o
	qemu-system-x86_64 boot.bin
