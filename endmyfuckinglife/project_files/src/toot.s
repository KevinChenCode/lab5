.equ JTAG_ADDRESS, 0x10001020

.global _start

_start:

movia sp, 0x0FFFFF

movui r4, 0x4
call write_to_jtag
movui r4, 0x7F 
call write_to_jtag

# expect sensor data in r2

looper:
	call return_sensor_data

	mov r4, r2

	call handle_steering

br looper

end:
	br end


handle_steering:
	addi sp, sp, -12
	stw r16, 8(sp)
	stw r17, 4(sp)
	stw ra, 0(sp)

	andi r4, r4, 0x1F
	mov r16, r4
	andi r16, r16, 0x1

	beq r16, r0, steer_right

	mov r16, r4
	andi r16, r16, 0x10

	beq r16, r0, steer_left

	br dont_steer

	steer_left:
		movui r4, 0x5
		call write_to_jtag

		movui r4, 0xFF
		call write_to_jtag

		br done_handle_steering

	steer_right:

		movui r4, 0x5
		call write_to_jtag

		movui r4, 0x7F
		call write_to_jtag

		br done_handle_steering

	dont_steer:
		movui r4, 0x5
		call write_to_jtag

		movui r4, 0
		call write_to_jtag

	done_handle_steering:

	ldw r16, 8(sp)
	ldw r17, 4(sp)
	ldw ra, 0(sp)
	addi sp, sp, 12

	ret




return_sensor_data:
	addi sp, sp, -8
	stw ra, 0(sp)
	stw r16, 4(sp)

	movui r4, 0x2

	# this will take r4 and write it to the jtag
	call write_to_jtag

	# this will put the return packet into r2
	call read_from_jtag

	call read_from_jtag

	mov r16, r2

	call read_from_jtag

	mov r3, r2

	mov r2, r16

	ldw ra, 0(sp)
	ldw r16, 4(sp)
	addi sp, sp, 8

	ret


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
	addi sp, sp, 36

	ret
	