	.text
	.section .rodata
	.align	3
.LC0: //text for "Quick Sort"
	.string	"\n**Quick Sort**"
	.align	3
.LC1: //text for "Number of element in list to be sorted"
	.string	"\nNumber of element in list to be sorted %d: "
	.align	3
.LC2: //text for "Enter x"
	.string	"\nEnter x[%d]: "
	.align	3
.LC3:
	.string	"%d"
	.align	3
.LC4:
	.string	"\n\nsorted array:"
	.align	3
.LC5:
	.string	"\n%d. %d "
	.align	3
.LC6:
	.string	"\n\nTime in sorting %d values using quicksort algorithm is %f miliseconds"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -448]!
	.cfi_def_cfa_offset 448
	.cfi_offset 29, -448
	.cfi_offset 30, -440
	mov	x29, sp
	bl	clock
	str	x0, [sp, 432]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts
	mov	w1, 100
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	mov	w0, 100
	str	w0, [sp, 428]
	str	wzr, [sp, 444]
	b	.L2
.L3:
	ldr	w1, [sp, 444]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	bl	rand
	mov	w2, w0
	ldrsw	x0, [sp, 444]
	lsl	x0, x0, 2
	add	x1, sp, 16
	str	w2, [x1, x0]
	ldrsw	x0, [sp, 444]
	lsl	x0, x0, 2
	add	x1, sp, 16
	ldr	w0, [x1, x0]
	mov	w1, w0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	ldr	w0, [sp, 444]
	add	w0, w0, 1
	str	w0, [sp, 444]
.L2:
	ldr	w1, [sp, 444]
	ldr	w0, [sp, 428]
	cmp	w1, w0
	blt	.L3
	ldr	w0, [sp, 428]
	sub	w1, w0, #1
	add	x0, sp, 16
	mov	w2, w1
	mov	w1, 0
	bl	quick_sort
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	str	wzr, [sp, 444]
	b	.L4
.L7:
	ldr	w0, [sp, 444]
	add	w3, w0, 1
	ldrsw	x0, [sp, 444]
	lsl	x0, x0, 2
	add	x1, sp, 16
	ldr	w0, [x1, x0]
	mov	w2, w0
	mov	w1, w3
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	ldr	w1, [sp, 444]
	ldr	w0, [sp, 428]
	cmp	w1, w0
	bgt	.L9
	ldr	w0, [sp, 444]
	add	w0, w0, 1
	str	w0, [sp, 444]
.L4:
	ldr	w1, [sp, 444]
	ldr	w0, [sp, 428]
	cmp	w1, w0
	blt	.L7
	b	.L6
.L9:
	nop
.L6:
	bl	clock
	mov	x1, x0
	ldr	x0, [sp, 432]
	sub	x0, x1, x0
	str	x0, [sp, 432]
	ldr	d0, [sp, 432]
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 416]
	ldr	d0, [sp, 416]
	mov	w1, 100
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	mov	w0, 0
	ldp	x29, x30, [sp], 448
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.align	2
	.global	quick_sort
	.type	quick_sort, %function
quick_sort:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	w2, [sp, 16]
	ldr	w1, [sp, 20]
	ldr	w0, [sp, 16]
	cmp	w1, w0
	bge	.L12
	ldr	w2, [sp, 16]
	ldr	w1, [sp, 20]
	ldr	x0, [sp, 24]
	bl	partition
	str	w0, [sp, 44]
	ldr	w0, [sp, 44]
	sub	w0, w0, #1
	mov	w2, w0
	ldr	w1, [sp, 20]
	ldr	x0, [sp, 24]
	bl	quick_sort
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	ldr	w2, [sp, 16]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	quick_sort
.L12:
	nop
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	quick_sort, .-quick_sort
	.align	2
	.global	partition
	.type	partition, %function
partition:
.LFB8:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	str	w2, [sp]
	ldr	w0, [sp, 4]
	str	w0, [sp, 28]
	ldrsw	x0, [sp, 4]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [sp, 20]
	ldr	w0, [sp, 4]
	str	w0, [sp, 24]
	b	.L14
.L16:
	ldrsw	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	ldr	w1, [sp, 20]
	cmp	w1, w0
	ble	.L15
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
	ldr	w1, [sp, 24]
	ldr	w0, [sp, 28]
	cmp	w1, w0
	beq	.L15
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [sp, 16]
	ldrsw	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x1, x1, x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x2, [sp, 8]
	add	x0, x2, x0
	ldr	w1, [x1]
	str	w1, [x0]
	ldrsw	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w1, [sp, 16]
	str	w1, [x0]
.L15:
	ldr	w0, [sp, 24]
	add	w0, w0, 1
	str	w0, [sp, 24]
.L14:
	ldr	w1, [sp, 24]
	ldr	w0, [sp]
	cmp	w1, w0
	ble	.L16
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [sp, 16]
	ldrsw	x0, [sp, 4]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x1, x1, x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x2, [sp, 8]
	add	x0, x2, x0
	ldr	w1, [x1]
	str	w1, [x0]
	ldrsw	x0, [sp, 4]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w1, [sp, 16]
	str	w1, [x0]
	ldr	w0, [sp, 28]
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc