/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_TRAP_H
#define JOS_KERN_TRAP_H
#ifndef JOS_KERNEL
#error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/mmu.h>
#include <inc/trap.h>

/* The kernel's interrupt descriptor table */
extern struct Gatedesc idt[];
extern struct Pseudodesc idt_pd;

void trap_init(void);
void trap_init_percpu(void);
void print_regs(struct PushRegs *regs);
void print_trapframe(struct Trapframe *tf);
void page_fault_handler(struct Trapframe *);
void backtrace(struct Trapframe *);

void divide_error();
void debug();
void non_maskable_interrupt();
void _breakpoint();
void overflow();
void bound_range_exceeded();
void invalid_opcode();
void device_not_avaliable();
void double_fault();
void coprocessor_segment_overrun();
void invalid_tss();
void segment_not_present();
void stack_fault();
void general_fault();
void page_fault();
void fpu_float_point_error();
void alignment_check();
void machine_check();
void simd_float_point_exception();
void syscall_handler();

#endif /* JOS_KERN_TRAP_H */
