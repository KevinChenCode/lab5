.equ JTAG_ADDRESS, 0x10001020

.global _start

_start:


write_to_jtag:
	addi sp, sp, -36
	stw r16, 32(sp)
	stw r17, 28(sp)
	stw r18, 24(sp)
	stw r19, 20(sp)
	stw r20, 16(sp)
	stw r21, 12(sp)
	stw r22, 8(sp)
	stw r23, 4(sp)
	stw ra, 0(sp)
	
	movia r16, JTAG_ADDRESS
	
	check_readiness:
		ldwio r17, 4(r16)
		srli r17, r17, 16
		beq r17, r0, check_readiness
	
	actually_write:
		stwio r4, 0(r16)
	
	ldw r16, 32(sp)
	ldw r17, 28(sp)
	ldw r18, 24(sp)
	ldw r19, 20(sp)
	ldw r20, 16(sp)
	ldw r21, 12(sp)
	ldw r22, 8(sp)
	ldw r23, 4(sp)
	ldw ra, 0(sp)
	addi sp, sp, 36

	ret

	
read_from_jtag:
	addi sp, sp, -36
	stw r16, 32(sp)
	stw r17, 28(sp)
	stw r18, 24(sp)
	stw r19, 20(sp)
	stw r20, 16(sp)
	stw r21, 12(sp)
	stw r22, 8(sp)
	stw r23, 4(sp)
	stw ra, 0(sp)
	
	movia r16, JTAG_ADDRESS
	
	
	check_readyness:
		ldwio r17, 0(r16)
		srli r17, r17, 15
		andi r17, r17, 0x1
		beq r17, r0, check_readyness
		
	reader:
		ldwio r2, 0(r16)
		andi r2, r2, 0x00FF
	
	ldw r16, 32(sp)
	ldw r17, 28(sp)
	ldw r18, 24(sp)
	ldw r19, 20(sp)
	ldw r20, 16(sp)
	ldw r21, 12(sp)
	ldw r22, 8(sp)
	ldw r23, 4(sp)
	ldw ra, 0(sp)
	addi sp, sp 36

	ret
	