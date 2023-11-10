	.arch armv8-a
	.file	"gcd2.c"
	.text
	.global	start
	.bss
	.align	3
	.type	start, %object
	.size	start, 8
start:
	.zero	8
	.global	end
	.align	3
	.type	end, %object
	.size	end, 8
end:
	.zero	8
	.global	cpu_time_used
	.align	3
	.type	cpu_time_used, %object
	.size	cpu_time_used, 8
cpu_time_used:
	.zero	8
	.section	.rodata
	.align	3
.LC0:
	.string	"Enter two positive integers: "
	.align	3
.LC1:
	.string	"%d %d"
	.align	3
.LC2:
	.string	"GCD of %d and %d is %d."
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
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	add	x1, sp, 40
	add	x0, sp, 44
	mov	x2, x1
	mov	x1, x0
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	__isoc99_scanf
	bl	clock
	mov	x1, x0
	adrp	x0, start
	add	x0, x0, :lo12:start
	str	x1, [x0]
	ldr	w19, [sp, 44]
	ldr	w20, [sp, 40]
	ldr	w0, [sp, 44]
	ldr	w1, [sp, 40]
	bl	hcf
	mov	w3, w0
	mov	w2, w20
	mov	w1, w19
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	bl	clock
	mov	x1, x0
	adrp	x0, end
	add	x0, x0, :lo12:end
	str	x1, [x0]
	adrp	x0, end
	add	x0, x0, :lo12:end
	ldr	x1, [x0]
	adrp	x0, start
	add	x0, x0, :lo12:start
	ldr	x0, [x0]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, cpu_time_used
	add	x0, x0, :lo12:cpu_time_used
	str	d0, [x0]
	adrp	x0, cpu_time_used
	add	x0, x0, :lo12:cpu_time_used
	ldr	d0, [x0]
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.align	2
	.global	hcf
	.type	hcf, %function
hcf:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	str	w1, [sp, 24]
	ldr	w0, [sp, 24]
	cmp	w0, 0
	beq	.L4
	ldr	w0, [sp, 28]
	ldr	w1, [sp, 24]
	sdiv	w2, w0, w1
	ldr	w1, [sp, 24]
	mul	w1, w2, w1
	sub	w0, w0, w1
	mov	w1, w0
	ldr	w0, [sp, 24]
	bl	hcf
	b	.L5
.L4:
	ldr	w0, [sp, 28]
.L5:
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	hcf, .-hcf
	.ident	"GCC: (Debian 12.2.0-14) 12.2.0"
	.section	.note.GNU-stack,"",@progbits
