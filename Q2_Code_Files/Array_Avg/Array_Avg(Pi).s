	.arch armv8-a
	.file	"Array_Avg.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"This program will find the average value of all the values you entered."
	.align	3
.LC1:
	.string	"First input the number of elements you want your array to have:"
	.align	3
.LC2:
	.string	"%d"
	.align	3
.LC3:
	.string	"Next, enter your %d values, one at a time.\n"
	.align	3
.LC4:
	.string	"Value %d:\n"
	.align	3
.LC5:
	.string	"The average value of the array is:%.2f"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -144]!
	.cfi_def_cfa_offset 144
	.cfi_offset 29, -144
	.cfi_offset 30, -136
	mov	x29, sp
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	str	x27, [sp, 80]
	.cfi_offset 19, -128
	.cfi_offset 20, -120
	.cfi_offset 21, -112
	.cfi_offset 22, -104
	.cfi_offset 23, -96
	.cfi_offset 24, -88
	.cfi_offset 25, -80
	.cfi_offset 26, -72
	.cfi_offset 27, -64
	mov	x0, sp
	mov	x19, x0
	str	wzr, [x29, 136]
	str	wzr, [x29, 132]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
	add	x0, x29, 108
	mov	x1, x0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	__isoc99_scanf
	ldr	w0, [x29, 108]
	sxtw	x1, w0
	sub	x1, x1, #1
	str	x1, [x29, 120]
	sxtw	x1, w0
	mov	x26, x1
	mov	x27, 0
	lsr	x1, x26, 59
	lsl	x23, x27, 5
	orr	x23, x1, x23
	lsl	x22, x26, 5
	sxtw	x1, w0
	mov	x24, x1
	mov	x25, 0
	lsr	x1, x24, 59
	lsl	x21, x25, 5
	orr	x21, x1, x21
	lsl	x20, x24, 5
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	sub	sp, sp, x0
	mov	x0, sp
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, 112]
	ldr	w0, [x29, 108]
	mov	w1, w0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	str	wzr, [x29, 140]
	b	.L2
.L3:
	ldr	w0, [x29, 140]
	add	w0, w0, 1
	mov	w1, w0
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	ldrsw	x0, [x29, 140]
	lsl	x0, x0, 2
	ldr	x1, [x29, 112]
	add	x0, x1, x0
	mov	x1, x0
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2 // "%d" format into X0
	bl	__isoc99_scanf	// scanf commmand
	ldr	x0, [x29, 112]
	ldrsw	x1, [x29, 140]
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, 136]
	add	w0, w1, w0
	str	w0, [x29, 136]
	ldr	w0, [x29, 140]
	add	w0, w0, 1
	str	w0, [x29, 140]
.L2:
	ldr	w0, [x29, 108]
	ldr	w1, [x29, 140]
	cmp	w1, w0
	blt	.L3
	ldr	w0, [x29, 108]
	ldr	w1, [x29, 136]
	sdiv	w0, w1, w0
	scvtf	s0, w0
	str	s0, [x29, 132]
	ldr	s0, [x29, 132]
	fcvt	d0, s0
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	mov	w0, 0
	mov	sp, x19
	mov	sp, x29
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldr	x27, [sp, 80]	// load value into stack pointer
	ldp	x29, x30, [sp], 144
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Debian 10.2.1-6) 10.2.1 20210110"
	.section	.note.GNU-stack,"",@progbits
