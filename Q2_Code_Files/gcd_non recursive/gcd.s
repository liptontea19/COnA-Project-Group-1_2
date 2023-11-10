	.arch armv8-a
	.file	"gcd.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"Enter two integers: "
	.align	3
.LC1:
	.string	"%d %d"
	.align	3
.LC2:
	.string	"GCD of %d and %d is %d"
	.align	3
.LC3:
	.string	"\nCPU time used: %f seconds\n"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	add	x1, sp, 24
	add	x0, sp, 28
	mov	x2, x1
	mov	x1, x0
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	__isoc99_scanf
	bl	clock
	str	x0, [sp, 48]
	mov	w0, 1
	str	w0, [sp, 60]
	b	.L2
.L5:
	ldr	w0, [sp, 28]
	ldr	w1, [sp, 60]
	sdiv	w2, w0, w1
	ldr	w1, [sp, 60]
	mul	w1, w2, w1
	sub	w0, w0, w1
	cmp	w0, 0
	bne	.L3
	ldr	w0, [sp, 24]
	ldr	w1, [sp, 60]
	sdiv	w2, w0, w1
	ldr	w1, [sp, 60]
	mul	w1, w2, w1
	sub	w0, w0, w1
	cmp	w0, 0
	bne	.L3
	ldr	w0, [sp, 60]
	str	w0, [sp, 56]
.L3:
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L2:
	ldr	w0, [sp, 28]
	ldr	w1, [sp, 60]
	cmp	w1, w0
	bgt	.L4
	ldr	w0, [sp, 24]
	ldr	w1, [sp, 60]
	cmp	w1, w0
	ble	.L5
.L4:
	ldr	w0, [sp, 28]
	ldr	w1, [sp, 24]
	ldr	w3, [sp, 56]
	mov	w2, w1
	mov	w1, w0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	bl	clock
	str	x0, [sp, 40]
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 48]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 32]
	ldr	d0, [sp, 32]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	mov	w0, 0
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
