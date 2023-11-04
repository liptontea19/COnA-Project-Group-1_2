	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"\n n=%d"
	.text
	.align	2
	.global	MultiplyNumbers
	.type	MultiplyNumbers, %function
MultiplyNumbers:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	cmp	w0, 0
	bne	.L2
	mov	w0, 1
	b	.L3
.L2:
	ldr	w1, [sp, 28]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	ldr	w0, [sp, 28]
	sub	w0, w0, #1
	bl	MultiplyNumbers
	mov	w1, w0
	ldr	w0, [sp, 28]
	mul	w0, w1, w0
.L3:
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	MultiplyNumbers, .-MultiplyNumbers
	.section	.rodata
	.align	3
.LC1:
	.string	"\n Please put in a postive integer"
	.align	3
.LC2:
	.string	"\n\nEnter a positive integer: "
	.align	3
.LC3:
	.string	"%d"
	.text
	.align	2
	.global	PositiveInt
	.type	PositiveInt, %function
PositiveInt:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	ldr	w0, [sp, 28]
	cmp	w0, 0
	bgt	.L5
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	add	x0, sp, 28
	mov	x1, x0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	__isoc99_scanf
	ldr	w0, [sp, 28]
	cmp	w0, 0
	bgt	.L6
	ldr	w0, [sp, 28]
	bl	PositiveInt
	b	.L6
.L5:
	ldr	w0, [sp, 28]
	b	.L4
.L6:
.L4:
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	PositiveInt, .-PositiveInt
	.section	.rodata
	.align	3
.LC4:
	.string	"Enter a positive integer: "
	.align	3
.LC5:
	.string	"Factorial of %d = %ld, and it took %f miliseconds"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	add	x0, sp, 20
	mov	x1, x0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	__isoc99_scanf
	ldr	w0, [sp, 20]
	bl	PositiveInt
	str	w0, [sp, 20]
	bl	clock
	str	x0, [sp, 40]
	ldr	w0, [sp, 20]
	bl	MultiplyNumbers
	str	w0, [sp, 36]
	bl	clock
	mov	x1, x0
	ldr	x0, [sp, 40]
	sub	x0, x1, x0
	str	x0, [sp, 40]
	ldr	d0, [sp, 40]
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	w0, [sp, 20]
	ldr	d0, [sp, 24]
	ldr	w2, [sp, 36]
	mov	w1, w0
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
