/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(syscall_handler, T_SYSCALL)

TRAPHANDLER_NOEC(divide_error, T_DIVIDE)

TRAPHANDLER_NOEC(debug, T_DEBUG)

TRAPHANDLER_NOEC(non_maskable_interrupt, T_NMI)

TRAPHANDLER_NOEC(_breakpoint, 3)

TRAPHANDLER_NOEC(overflow, 4)

TRAPHANDLER_NOEC(bound_range_exceeded, 5)

TRAPHANDLER_NOEC(invalid_opcode, 6)

TRAPHANDLER_NOEC(device_not_avaliable, 7)

TRAPHANDLER(double_fault, 8)

TRAPHANDLER_NOEC(coprocessor_segment_overrun, 9)

TRAPHANDLER(invalid_tss, 10)

TRAPHANDLER(segment_not_present, 11)

TRAPHANDLER(stack_fault, 12)

TRAPHANDLER(general_fault, 13)

TRAPHANDLER(page_fault, 14)

TRAPHANDLER_NOEC(fpu_float_point_error, 16)

TRAPHANDLER(alignment_check, 17)

TRAPHANDLER_NOEC(machine_check, 18)

TRAPHANDLER_NOEC(simd_float_point_exception, 19)


/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
	pushl  %ds
	pushl  %es
	pushal

	movw %ss, %ax
	movw %ax, %ds
	movw %ax, %es

	pushl %esp
	call  trap
