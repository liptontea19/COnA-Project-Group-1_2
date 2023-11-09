	.text
	.section .rodata
	.align	3
.LC0: //declare a string "**Quick Sort**"
	.string	"\n**Quick Sort**"
	.align	3
.LC1: //declare a string "Number of element in a list to be sorted %d"
	.string	"\nNumber of element in list to be sorted %d: "
	.align	3
.LC2: //declare a string "Enter x[%d]
	.string	"\nEnter x[%d]: "
	.align	3
.LC3: //declare a string "%d"
	.string	"%d"
	.align	3
.LC4: //declare a string "sorted array:"
	.string	"\n\nsorted array:"
	.align	3
.LC5: //declare a string "%d,%d"
	.string	"\n%d. %d "
	.align	3
.LC6: //declare a string "Time in sorting %d values using quicksort algorithm is %f miliseconds"
	.string	"\n\nTime in sorting %d values using quicksort algorithm is %f miliseconds"
	.text
	.align	2
	.global	main //start at main for global
	.type	main, %function //set main as a function
main:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -448]!
	.cfi_def_cfa_offset 448
	.cfi_offset 29, -448
	.cfi_offset 30, -440
	mov	x29, sp //set x29=sp
	bl	clock //branch to clock
	str	x0, [sp, 432]
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts //branch puts
	mov	w1, 100 //set w1=100
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf //branch to printf
	mov	w0, 100 //set w0=100
	str	w0, [sp, 428]
	str	wzr, [sp, 444]
	b	.L2
.L3:
	ldr	w1, [sp, 444]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf //branch to printf
	bl	rand //branch to rand
	mov	w2, w0 //set w2=w0
	ldrsw	x0, [sp, 444]
	lsl	x0, x0, 2
	add	x1, sp, 16 //x1=sp+16
	str	w2, [x1, x0]
	ldrsw	x0, [sp, 444]
	lsl	x0, x0, 2
	add	x1, sp, 16 //x1=sp+16
	ldr	w0, [x1, x0]
	mov	w1, w0 //set w1=w0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf //branch to printf
	ldr	w0, [sp, 444]
	add	w0, w0, 1 //w0=w0+1
	str	w0, [sp, 444]
.L2:
	ldr	w1, [sp, 444]
	ldr	w0, [sp, 428]
	cmp	w1, w0 //compare w1 with w0
	blt	.L3 //if less than, then branch to L3
	ldr	w0, [sp, 428]
	sub	w1, w0, #1 //w1=w0-1
	add	x0, sp, 16 //x0=sp+16
	mov	w2, w1 //set w2=w1
	mov	w1, 0 //set w1=0
	bl	quick_sort //branch to quick_sort
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf //branch to printf
	str	wzr, [sp, 444]
	b	.L4 
.L7:
	ldr	w0, [sp, 444]
	add	w3, w0, 1 //w3=w0+1
	ldrsw	x0, [sp, 444]
	lsl	x0, x0, 2
	add	x1, sp, 16 //x1=sp+16
	ldr	w0, [x1, x0]
	mov	w2, w0 //set w2=w0
	mov	w1, w3 //set w1=w3
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf //branch to printf
	ldr	w1, [sp, 444]
	ldr	w0, [sp, 428]
	cmp	w1, w0 //compare w1 with w0
	bgt	.L9 //if greater than, then branch to L9
	ldr	w0, [sp, 444]
	add	w0, w0, 1 //w0=w0+1
	str	w0, [sp, 444]
.L4:
	ldr	w1, [sp, 444]
	ldr	w0, [sp, 428]
	cmp	w1, w0 //compare w1 with w0
	blt	.L7 //if less than, then branch to L7
	b	.L6
.L9:
	nop
.L6:
	bl	clock //branch to clock
	mov	x1, x0 //set x1=x0
	ldr	x0, [sp, 432]
	sub	x0, x1, x0 //x0=x1-x0
	str	x0, [sp, 432]
	ldr	d0, [sp, 432]
	scvtf	d0, d0
	mov	x0, 145685290680320 //set x0=145685290680320
	movk	x0, 0x412e, lsl 48 
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 416]
	ldr	d0, [sp, 416]
	mov	w1, 100 //set w1=100
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf //branch to printf
	mov	w0, 0 //set w0=0
	ldp	x29, x30, [sp], 448
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	main, .-main
	.align	2
	.global	quick_sort //start quick_sort at global
	.type	quick_sort, %function //set quick_sort as a function
quick_sort:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp //set x29=sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	w2, [sp, 16]
	ldr	w1, [sp, 20]
	ldr	w0, [sp, 16]
	cmp	w1, w0 //compare w1 with w0
	bge	.L12 //if greater than, then branch to L12
	ldr	w2, [sp, 16]
	ldr	w1, [sp, 20]
	ldr	x0, [sp, 24]
	bl	partition //branch to partition
	str	w0, [sp, 44]
	ldr	w0, [sp, 44]
	sub	w0, w0, #1 //w0=w0-1
	mov	w2, w0 //set w2=w0
	ldr	w1, [sp, 20]
	ldr	x0, [sp, 24]
	bl	quick_sort //branch to quick_sort
	ldr	w0, [sp, 44]
	add	w0, w0, 1 //w0=w0-1
	ldr	w2, [sp, 16]
	mov	w1, w0 //set w1=w0
	ldr	x0, [sp, 24]
	bl	quick_sort //branch to quick_sort
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
	.global	partition //start at partition for global
	.type	partition, %function //set partition as a function
partition:
.LFB8:
	.cfi_startproc
	sub	sp, sp, #32 //sp=sp-32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	str	w2, [sp]
	ldr	w0, [sp, 4]
	str	w0, [sp, 28]
	ldrsw	x0, [sp, 4]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0 //x0=x1-x0
	ldr	w0, [x0]
	str	w0, [sp, 20]
	ldr	w0, [sp, 4]
	str	w0, [sp, 24]
	b	.L14
.L16:
	ldrsw	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0 //x0=x1+x0
	ldr	w0, [x0]
	ldr	w1, [sp, 20]
	cmp	w1, w0 //compare w1 with w0
	ble	.L15 //branch to L15 if less than or equal`
	ldr	w0, [sp, 28]
	add	w0, w0, 1 //w0=w0+1
	str	w0, [sp, 28]
	ldr	w1, [sp, 24]
	ldr	w0, [sp, 28]
	cmp	w1, w0 //compare w1 with w0
	beq	.L15 //branch to L15 if equal 
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0 //x0=x1+x0
	ldr	w0, [x0]
	str	w0, [sp, 16]
	ldrsw	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x1, x1, x0 //x1=x1+x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x2, [sp, 8]
	add	x0, x2, x0 //x0=x2+x0
	ldr	w1, [x1]
	str	w1, [x0]
	ldrsw	x0, [sp, 24]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0 //x0=x1+x0
	ldr	w1, [sp, 16]
	str	w1, [x0]
.L15:
	ldr	w0, [sp, 24]
	add	w0, w0, 1 //w0=w0+1
	str	w0, [sp, 24]
.L14:
	ldr	w1, [sp, 24]
	ldr	w0, [sp]
	cmp	w1, w0 //compare w1 with w0
	ble	.L16 //branch to L16 if less than or equal
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0 //x0=x1+x0
	ldr	w0, [x0]
	str	w0, [sp, 16]
	ldrsw	x0, [sp, 4]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x1, x1, x0 //x1=x1+x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 2
	ldr	x2, [sp, 8]
	add	x0, x2, x0 //x0=x2+x0
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