


.text
.global _start


@Exception Vector Table
_start:
	b reset
	ldr pc, _undefined_instructions
	ldr pc, _software_interrupt
	ldr pc, _prefetch_abort
	ldr pc, _data_abort
	ldr pc, _unused
	ldr pc, _irq
	ldr pc, _fiq

_undefined_instructions:
	.word undefined_instructions
_software_interrupt:
	.word software_interrupt
_prefetch_abort:
	.word prefetch_abort
_data_abort:
	.word data_abort
_unused:
	.word unused
_irq:
	.word irq
_fiq:
	.word fiq


undefined_instructions:
	b .

software_interrupt:
	b .

prefetch_abort:
	b .

data_abort:
	b .

unused:
	b .

irq:
	b .

fiq:
	b .

reset:
	bl set_svc
	bl disable_watchdog
	bl disable_interrupt
	bl disable_mmu
	bl light_led
	b .

set_svc:
	mrs r0, cpsr
	bic r0, #0x1f
	orr r0, #0xd3
	msr cpsr, r0
	mov pc, lr

#define pWTCON 0xE2700000
disable_watchdog:
	mov r0, #0
	ldr r1, =pWTCON
	str r0, [r1]
	mov pc, lr

#define pVIC0INTENCLEAR 0xF2000014
#define pVIC1INTENCLEAR 0xF2100014
#define pVIC2INTENCLEAR 0xF2200014
#define pVIC3INTENCLEAR 0xF2300014
disable_interrupt:
	mvn r0, #0

	ldr r1, =pVIC0INTENCLEAR
	str r0, [r1]

	ldr r1, =pVIC1INTENCLEAR
	str r0, [r1]

	ldr r1, =pVIC2INTENCLEAR
	str r0, [r1]

	ldr r1, =pVIC3INTENCLEAR
	str r0, [r1]

	mov pc, lr


#define CON_REG_VAL (~((1<<12)|(1<<2)|(1<<0))) 
@mcr{<cond>} <coproc>, <opcode_1>, <Rd>, <CRn>, <CRm>{, <opcode_2>}
disable_mmu:
	@Invalidate all instruction caches
	mcr p15, 0, r0, c7, c5, 0
	
	@Invalidate data cache line to point of coherency by MVA
	mcr p15, 0, r0, c7, c6, 1
	mov pc, lr

	@Disable instruction cache, data cache, mmu
	mrc p15, 0, r0, c1, c0, 0
	ldr r1, =CON_REG_VAL
	and r0, r0, r1	
	mcr p15, 0, r0, c1, c0, 0

light_led:
	mov pc, lr
