
obj/mpos-kern:     file format elf32-i386


Disassembly of section .text:

00100000 <multiboot>:
  100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
  100006:	00 00                	add    %al,(%eax)
  100008:	fe 4f 52             	decb   0x52(%edi)
  10000b:	e4 bc                	in     $0xbc,%al

0010000c <multiboot_start>:
# The multiboot_start routine sets the stack pointer to the top of the
# MiniprocOS's kernel stack, then jumps to the 'start' routine in mpos-kern.c.

.globl multiboot_start
multiboot_start:
	movl $0x200000, %esp
  10000c:	bc 00 00 20 00       	mov    $0x200000,%esp
	pushl $0
  100011:	6a 00                	push   $0x0
	popfl
  100013:	9d                   	popf   
	call start
  100014:	e8 69 02 00 00       	call   100282 <start>
  100019:	90                   	nop

0010001a <sys_int48_handler>:

# Interrupt handlers
.align 2

sys_int48_handler:
	pushl $0
  10001a:	6a 00                	push   $0x0
	pushl $48
  10001c:	6a 30                	push   $0x30
	jmp _generic_int_handler
  10001e:	eb 3a                	jmp    10005a <_generic_int_handler>

00100020 <sys_int49_handler>:

sys_int49_handler:
	pushl $0
  100020:	6a 00                	push   $0x0
	pushl $49
  100022:	6a 31                	push   $0x31
	jmp _generic_int_handler
  100024:	eb 34                	jmp    10005a <_generic_int_handler>

00100026 <sys_int50_handler>:

sys_int50_handler:
	pushl $0
  100026:	6a 00                	push   $0x0
	pushl $50
  100028:	6a 32                	push   $0x32
	jmp _generic_int_handler
  10002a:	eb 2e                	jmp    10005a <_generic_int_handler>

0010002c <sys_int51_handler>:

sys_int51_handler:
	pushl $0
  10002c:	6a 00                	push   $0x0
	pushl $51
  10002e:	6a 33                	push   $0x33
	jmp _generic_int_handler
  100030:	eb 28                	jmp    10005a <_generic_int_handler>

00100032 <sys_int52_handler>:

sys_int52_handler:
	pushl $0
  100032:	6a 00                	push   $0x0
	pushl $52
  100034:	6a 34                	push   $0x34
	jmp _generic_int_handler
  100036:	eb 22                	jmp    10005a <_generic_int_handler>

00100038 <sys_int53_handler>:

sys_int53_handler:
	pushl $0
  100038:	6a 00                	push   $0x0
	pushl $53
  10003a:	6a 35                	push   $0x35
	jmp _generic_int_handler
  10003c:	eb 1c                	jmp    10005a <_generic_int_handler>

0010003e <sys_int54_handler>:

sys_int54_handler:
	pushl $0
  10003e:	6a 00                	push   $0x0
	pushl $54
  100040:	6a 36                	push   $0x36
	jmp _generic_int_handler
  100042:	eb 16                	jmp    10005a <_generic_int_handler>

00100044 <sys_int55_handler>:

sys_int55_handler:
	pushl $0
  100044:	6a 00                	push   $0x0
	pushl $55
  100046:	6a 37                	push   $0x37
	jmp _generic_int_handler
  100048:	eb 10                	jmp    10005a <_generic_int_handler>

0010004a <sys_int56_handler>:

sys_int56_handler:
	pushl $0
  10004a:	6a 00                	push   $0x0
	pushl $56
  10004c:	6a 38                	push   $0x38
	jmp _generic_int_handler
  10004e:	eb 0a                	jmp    10005a <_generic_int_handler>

00100050 <sys_int57_handler>:

sys_int57_handler:
	pushl $0
  100050:	6a 00                	push   $0x0
	pushl $57
  100052:	6a 39                	push   $0x39
	jmp _generic_int_handler
  100054:	eb 04                	jmp    10005a <_generic_int_handler>

00100056 <default_int_handler>:

	.globl default_int_handler
default_int_handler:
	pushl $0
  100056:	6a 00                	push   $0x0
	jmp _generic_int_handler
  100058:	eb 00                	jmp    10005a <_generic_int_handler>

0010005a <_generic_int_handler>:
	# When we get here, the processor's interrupt mechanism has
	# pushed the old task status and stack registers onto the kernel stack.
	# Then one of the specific handlers pushed the interrupt number.
	# Now, we complete the 'registers_t' structure by pushing the extra
	# segment definitions and the general CPU registers.
	pushl %ds
  10005a:	1e                   	push   %ds
	pushl %es
  10005b:	06                   	push   %es
	pushal
  10005c:	60                   	pusha  

	# Call the kernel's 'interrupt' function.
	pushl %esp
  10005d:	54                   	push   %esp
	call interrupt
  10005e:	e8 5b 00 00 00       	call   1000be <interrupt>

00100063 <sys_int_handlers>:
  100063:	1a 00                	sbb    (%eax),%al
  100065:	10 00                	adc    %al,(%eax)
  100067:	20 00                	and    %al,(%eax)
  100069:	10 00                	adc    %al,(%eax)
  10006b:	26 00 10             	add    %dl,%es:(%eax)
  10006e:	00 2c 00             	add    %ch,(%eax,%eax,1)
  100071:	10 00                	adc    %al,(%eax)
  100073:	32 00                	xor    (%eax),%al
  100075:	10 00                	adc    %al,(%eax)
  100077:	38 00                	cmp    %al,(%eax)
  100079:	10 00                	adc    %al,(%eax)
  10007b:	3e 00 10             	add    %dl,%ds:(%eax)
  10007e:	00 44 00 10          	add    %al,0x10(%eax,%eax,1)
  100082:	00 4a 00             	add    %cl,0x0(%edx)
  100085:	10 00                	adc    %al,(%eax)
  100087:	50                   	push   %eax
  100088:	00 10                	add    %dl,(%eax)
  10008a:	00 90 83 ec 0c a1    	add    %dl,-0x5ef3137d(%eax)

0010008c <schedule>:
 *
 *****************************************************************************/

void
schedule(void)
{
  10008c:	83 ec 0c             	sub    $0xc,%esp
	pid_t pid = current->p_pid;
  10008f:	a1 2c 99 10 00       	mov    0x10992c,%eax
	while (1) {
		pid = (pid + 1) % NPROCS;
  100094:	b9 10 00 00 00       	mov    $0x10,%ecx
 *****************************************************************************/

void
schedule(void)
{
	pid_t pid = current->p_pid;
  100099:	8b 10                	mov    (%eax),%edx
	while (1) {
		pid = (pid + 1) % NPROCS;
  10009b:	8d 42 01             	lea    0x1(%edx),%eax
  10009e:	99                   	cltd   
  10009f:	f7 f9                	idiv   %ecx
		if (proc_array[pid].p_state == P_RUNNABLE)
  1000a1:	69 c2 90 00 00 00    	imul   $0x90,%edx,%eax
  1000a7:	83 b8 0c 88 10 00 01 	cmpl   $0x1,0x10880c(%eax)
  1000ae:	75 eb                	jne    10009b <schedule+0xf>
			run(&proc_array[pid]);
  1000b0:	83 ec 0c             	sub    $0xc,%esp
  1000b3:	05 c4 87 10 00       	add    $0x1087c4,%eax
  1000b8:	50                   	push   %eax
  1000b9:	e8 fe 03 00 00       	call   1004bc <run>

001000be <interrupt>:

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  1000be:	55                   	push   %ebp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000bf:	b9 11 00 00 00       	mov    $0x11,%ecx

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  1000c4:	57                   	push   %edi
  1000c5:	56                   	push   %esi
  1000c6:	53                   	push   %ebx
  1000c7:	83 ec 2c             	sub    $0x2c,%esp
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000ca:	8b 1d 2c 99 10 00    	mov    0x10992c,%ebx

static pid_t do_fork(process_t *parent);

void
interrupt(registers_t *reg)
{
  1000d0:	8b 44 24 40          	mov    0x40(%esp),%eax
	// the application's state on the kernel's stack, then jumping to
	// kernel assembly code (in mpos-int.S, for your information).
	// That code saves more registers on the kernel's stack, then calls
	// interrupt().  The first thing we must do, then, is copy the saved
	// registers into the 'current' process descriptor.
	current->p_registers = *reg;
  1000d4:	8d 7b 04             	lea    0x4(%ebx),%edi
  1000d7:	89 c6                	mov    %eax,%esi
  1000d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	switch (reg->reg_intno) {
  1000db:	8b 40 28             	mov    0x28(%eax),%eax
  1000de:	83 e8 30             	sub    $0x30,%eax
  1000e1:	83 f8 04             	cmp    $0x4,%eax
  1000e4:	0f 87 96 01 00 00    	ja     100280 <interrupt+0x1c2>
  1000ea:	ff 24 85 74 0a 10 00 	jmp    *0x100a74(,%eax,4)
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1000f1:	8b 03                	mov    (%ebx),%eax
		run(current);
  1000f3:	83 ec 0c             	sub    $0xc,%esp
		// The 'sys_getpid' system call returns the current
		// process's process ID.  System calls return results to user
		// code by putting those results in a register.  Like Linux,
		// we use %eax for system call return values.  The code is
		// surprisingly simple:
		current->p_registers.reg_eax = current->p_pid;
  1000f6:	89 43 20             	mov    %eax,0x20(%ebx)
		run(current);
  1000f9:	53                   	push   %ebx
  1000fa:	e9 c1 00 00 00       	jmp    1001c0 <interrupt+0x102>
static void copy_stack(process_t *dest, process_t *src);

static pid_t
do_fork(process_t *parent)
{
  pid_t pid = parent->p_pid;
  1000ff:	8b 2b                	mov    (%ebx),%ebp
  100101:	31 c9                	xor    %ecx,%ecx
  int i = 0;
    while (i<NPROCS)  // Check all possible processes 
    {
      pid = (pid + 1) % NPROCS;
  100103:	be 10 00 00 00       	mov    $0x10,%esi
  100108:	8d 45 01             	lea    0x1(%ebp),%eax
  10010b:	99                   	cltd   
  10010c:	f7 fe                	idiv   %esi
      if ((proc_array[pid].p_state == P_EMPTY) && (pid != 0))
  10010e:	85 d2                	test   %edx,%edx
{
  pid_t pid = parent->p_pid;
  int i = 0;
    while (i<NPROCS)  // Check all possible processes 
    {
      pid = (pid + 1) % NPROCS;
  100110:	89 d5                	mov    %edx,%ebp
      if ((proc_array[pid].p_state == P_EMPTY) && (pid != 0))
  100112:	0f 84 8f 00 00 00    	je     1001a7 <interrupt+0xe9>
  100118:	69 c2 90 00 00 00    	imul   $0x90,%edx,%eax
  10011e:	8d 90 cc 87 10 00    	lea    0x1087cc(%eax),%edx
  100124:	83 7a 40 00          	cmpl   $0x0,0x40(%edx)
  100128:	8d 7a 40             	lea    0x40(%edx),%edi
  10012b:	89 7c 24 1c          	mov    %edi,0x1c(%esp)
  10012f:	75 76                	jne    1001a7 <interrupt+0xe9>
      {
        proc_array[pid].p_pid = pid;
  100131:	89 a8 c4 87 10 00    	mov    %ebp,0x1087c4(%eax)
        proc_array[pid].p_registers = parent->p_registers;
  100137:	05 c4 87 10 00       	add    $0x1087c4,%eax
  10013c:	b9 11 00 00 00       	mov    $0x11,%ecx
  100141:	89 c7                	mov    %eax,%edi
  100143:	89 44 24 18          	mov    %eax,0x18(%esp)
  100147:	83 c7 04             	add    $0x4,%edi
  10014a:	8d 73 04             	lea    0x4(%ebx),%esi
        proc_array[pid].p_registers.reg_eax = 0;  //The return value of the child process should be 0;
  10014d:	8d 44 ed 00          	lea    0x0(%ebp,%ebp,8),%eax
    {
      pid = (pid + 1) % NPROCS;
      if ((proc_array[pid].p_state == P_EMPTY) && (pid != 0))
      {
        proc_array[pid].p_pid = pid;
        proc_array[pid].p_registers = parent->p_registers;
  100151:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
        proc_array[pid].p_registers.reg_eax = 0;  //The return value of the child process should be 0;
  100153:	c1 e0 04             	shl    $0x4,%eax
	// YOUR CODE HERE!
        
	src_stack_top = PROC1_STACK_ADDR + (src->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + (dest->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
        dest_stack_bottom = (src_stack_bottom - src_stack_top) + dest_stack_top; /* YOUR CODE HERE: calculate based on the
  100156:	bf 10 00 00 00       	mov    $0x10,%edi
      pid = (pid + 1) % NPROCS;
      if ((proc_array[pid].p_state == P_EMPTY) && (pid != 0))
      {
        proc_array[pid].p_pid = pid;
        proc_array[pid].p_registers = parent->p_registers;
        proc_array[pid].p_registers.reg_eax = 0;  //The return value of the child process should be 0;
  10015b:	c7 80 e4 87 10 00 00 	movl   $0x0,0x1087e4(%eax)
  100162:	00 00 00 
	// and then how to actually copy the stack.  (Hint: use memcpy.)
	// We have done one for you.

	// YOUR CODE HERE!
        
	src_stack_top = PROC1_STACK_ADDR + (src->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  100165:	8b 03                	mov    (%ebx),%eax
  100167:	99                   	cltd   
  100168:	b1 10                	mov    $0x10,%cl
  10016a:	f7 f9                	idiv   %ecx
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + (dest->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
        dest_stack_bottom = (src_stack_bottom - src_stack_top) + dest_stack_top; /* YOUR CODE HERE: calculate based on the
  10016c:	89 e8                	mov    %ebp,%eax
	// We have done one for you.

	// YOUR CODE HERE!
        
	src_stack_top = PROC1_STACK_ADDR + (src->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	src_stack_bottom = src->p_registers.reg_esp;
  10016e:	8b 4b 40             	mov    0x40(%ebx),%ecx
	// and then how to actually copy the stack.  (Hint: use memcpy.)
	// We have done one for you.

	// YOUR CODE HERE!
        
	src_stack_top = PROC1_STACK_ADDR + (src->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  100171:	8d 72 0a             	lea    0xa(%edx),%esi
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + (dest->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
        dest_stack_bottom = (src_stack_bottom - src_stack_top) + dest_stack_top; /* YOUR CODE HERE: calculate based on the
  100174:	99                   	cltd   
  100175:	f7 ff                	idiv   %edi
	// and then how to actually copy the stack.  (Hint: use memcpy.)
	// We have done one for you.

	// YOUR CODE HERE!
        
	src_stack_top = PROC1_STACK_ADDR + (src->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
  100177:	c1 e6 12             	shl    $0x12,%esi
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + (dest->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
        dest_stack_bottom = (src_stack_bottom - src_stack_top) + dest_stack_top; /* YOUR CODE HERE: calculate based on the
  10017a:	c1 e2 12             	shl    $0x12,%edx
  10017d:	8d bc 0a 00 00 28 00 	lea    0x280000(%edx,%ecx,1),%edi
				 other variables */;
        memcpy((void *)dest_stack_bottom,(void *)src_stack_bottom,src_stack_top-src_stack_bottom);
  100184:	50                   	push   %eax
	// YOUR CODE HERE!
        
	src_stack_top = PROC1_STACK_ADDR + (src->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + (dest->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
        dest_stack_bottom = (src_stack_bottom - src_stack_top) + dest_stack_top; /* YOUR CODE HERE: calculate based on the
  100185:	29 f7                	sub    %esi,%edi
				 other variables */;
        memcpy((void *)dest_stack_bottom,(void *)src_stack_bottom,src_stack_top-src_stack_bottom);
  100187:	29 ce                	sub    %ecx,%esi
  100189:	56                   	push   %esi
  10018a:	51                   	push   %ecx
  10018b:	57                   	push   %edi
  10018c:	e8 03 04 00 00       	call   100594 <memcpy>
        dest->p_registers.reg_esp = dest_stack_bottom;
  100191:	8b 44 24 28          	mov    0x28(%esp),%eax
      {
        proc_array[pid].p_pid = pid;
        proc_array[pid].p_registers = parent->p_registers;
        proc_array[pid].p_registers.reg_eax = 0;  //The return value of the child process should be 0;
        copy_stack(&proc_array[pid],parent);
        proc_array[pid].p_state = P_RUNNABLE;
  100195:	8b 54 24 2c          	mov    0x2c(%esp),%edx
  100199:	83 c4 10             	add    $0x10,%esp
	src_stack_bottom = src->p_registers.reg_esp;
	dest_stack_top = PROC1_STACK_ADDR + (dest->p_pid % NPROCS)*PROC_STACK_SIZE; /* YOUR CODE HERE */;
        dest_stack_bottom = (src_stack_bottom - src_stack_top) + dest_stack_top; /* YOUR CODE HERE: calculate based on the
				 other variables */;
        memcpy((void *)dest_stack_bottom,(void *)src_stack_bottom,src_stack_top-src_stack_bottom);
        dest->p_registers.reg_esp = dest_stack_bottom;
  10019c:	89 78 40             	mov    %edi,0x40(%eax)
      {
        proc_array[pid].p_pid = pid;
        proc_array[pid].p_registers = parent->p_registers;
        proc_array[pid].p_registers.reg_eax = 0;  //The return value of the child process should be 0;
        copy_stack(&proc_array[pid],parent);
        proc_array[pid].p_state = P_RUNNABLE;
  10019f:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  1001a5:	eb 0d                	jmp    1001b4 <interrupt+0xf6>
        return pid;
      }   
      i++;
  1001a7:	41                   	inc    %ecx
static pid_t
do_fork(process_t *parent)
{
  pid_t pid = parent->p_pid;
  int i = 0;
    while (i<NPROCS)  // Check all possible processes 
  1001a8:	83 f9 10             	cmp    $0x10,%ecx
  1001ab:	0f 85 57 ff ff ff    	jne    100108 <interrupt+0x4a>
  1001b1:	83 cd ff             	or     $0xffffffff,%ebp
		run(current);

	case INT_SYS_FORK:
		// The 'sys_fork' system call should create a new process.
		// You will have to complete the do_fork() function!
		current->p_registers.reg_eax = do_fork(current);
  1001b4:	89 6b 20             	mov    %ebp,0x20(%ebx)
		run(current);
  1001b7:	83 ec 0c             	sub    $0xc,%esp
  1001ba:	ff 35 2c 99 10 00    	pushl  0x10992c
  1001c0:	e8 f7 02 00 00       	call   1004bc <run>

	case INT_SYS_YIELD:
		// The 'sys_yield' system call asks the kernel to schedule a
		// different process.  (MiniprocOS is cooperatively
		// scheduled, so we need a special system call to do this.)		// The schedule() function picks another process and runs it.
		schedule();
  1001c5:	e8 c2 fe ff ff       	call   10008c <schedule>
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  1001ca:	a1 2c 99 10 00       	mov    0x10992c,%eax
		current->p_exit_status = current->p_registers.reg_eax;
  1001cf:	8b 50 20             	mov    0x20(%eax),%edx
  1001d2:	89 c1                	mov    %eax,%ecx
		// non-runnable.
		// The process stored its exit status in the %eax register
		// before calling the system call.  The %eax REGISTER has
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
  1001d4:	c7 40 48 03 00 00 00 	movl   $0x3,0x48(%eax)
		current->p_exit_status = current->p_registers.reg_eax;
  1001db:	89 50 4c             	mov    %edx,0x4c(%eax)
  1001de:	31 d2                	xor    %edx,%edx
                int j;
                for (j = 0; j < NPROCS; j++)
                {                  
                  if (current->waiting_me[j] !=0)  // Wake up all the processes that are waiting for this process to exit
  1001e0:	83 79 50 00          	cmpl   $0x0,0x50(%ecx)
  1001e4:	74 21                	je     100207 <interrupt+0x149>
                  {
                    current->p_state = P_EMPTY; 
                    proc_array[j].p_state = P_RUNNABLE;
                    proc_array[j].p_registers.reg_eax = current->p_exit_status;
  1001e6:	8b 58 4c             	mov    0x4c(%eax),%ebx
                int j;
                for (j = 0; j < NPROCS; j++)
                {                  
                  if (current->waiting_me[j] !=0)  // Wake up all the processes that are waiting for this process to exit
                  {
                    current->p_state = P_EMPTY; 
  1001e9:	c7 40 48 00 00 00 00 	movl   $0x0,0x48(%eax)
                    proc_array[j].p_state = P_RUNNABLE;
                    proc_array[j].p_registers.reg_eax = current->p_exit_status;
                    current->waiting_me[j] = 0;
  1001f0:	c7 41 50 00 00 00 00 	movl   $0x0,0x50(%ecx)
                for (j = 0; j < NPROCS; j++)
                {                  
                  if (current->waiting_me[j] !=0)  // Wake up all the processes that are waiting for this process to exit
                  {
                    current->p_state = P_EMPTY; 
                    proc_array[j].p_state = P_RUNNABLE;
  1001f7:	c7 82 0c 88 10 00 01 	movl   $0x1,0x10880c(%edx)
  1001fe:	00 00 00 
                    proc_array[j].p_registers.reg_eax = current->p_exit_status;
  100201:	89 9a e4 87 10 00    	mov    %ebx,0x1087e4(%edx)
                    current->waiting_me[j] = 0;
  100207:	81 c2 90 00 00 00    	add    $0x90,%edx
  10020d:	83 c1 04             	add    $0x4,%ecx
		// changed by now, but we can read the APPLICATION's setting
		// for this register out of 'current->p_registers'.
		current->p_state = P_ZOMBIE;
		current->p_exit_status = current->p_registers.reg_eax;
                int j;
                for (j = 0; j < NPROCS; j++)
  100210:	81 fa 00 09 00 00    	cmp    $0x900,%edx
  100216:	75 c8                	jne    1001e0 <interrupt+0x122>
                    proc_array[j].p_state = P_RUNNABLE;
                    proc_array[j].p_registers.reg_eax = current->p_exit_status;
                    current->waiting_me[j] = 0;
                  }
                }
		schedule();
  100218:	e8 6f fe ff ff       	call   10008c <schedule>
		// * A process that doesn't exist (p_state == P_EMPTY).
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
  10021d:	a1 2c 99 10 00       	mov    0x10992c,%eax
  100222:	8b 50 20             	mov    0x20(%eax),%edx
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  100225:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100228:	83 f9 0e             	cmp    $0xe,%ecx
  10022b:	77 17                	ja     100244 <interrupt+0x186>
  10022d:	3b 10                	cmp    (%eax),%edx
  10022f:	74 13                	je     100244 <interrupt+0x186>
		    || proc_array[p].p_state == P_EMPTY)
  100231:	69 ca 90 00 00 00    	imul   $0x90,%edx,%ecx
  100237:	8d 99 cc 87 10 00    	lea    0x1087cc(%ecx),%ebx
  10023d:	8b 73 40             	mov    0x40(%ebx),%esi
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  100240:	85 f6                	test   %esi,%esi
  100242:	75 09                	jne    10024d <interrupt+0x18f>
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
  100244:	c7 40 20 ff ff ff ff 	movl   $0xffffffff,0x20(%eax)
		// (In the Unix operating system, only process P's parent
		// can call sys_wait(P).  In MiniprocOS, we allow ANY
		// process to call sys_wait(P).)

		pid_t p = current->p_registers.reg_eax;
		if (p <= 0 || p >= NPROCS || p == current->p_pid
  10024b:	eb 2e                	jmp    10027b <interrupt+0x1bd>
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
		else if (proc_array[p].p_state == P_ZOMBIE)
  10024d:	83 fe 03             	cmp    $0x3,%esi
  100250:	75 12                	jne    100264 <interrupt+0x1a6>
                {
                        proc_array[p].p_state = P_EMPTY;
                        current->p_registers.reg_eax = proc_array[p].p_exit_status;
  100252:	8b 91 10 88 10 00    	mov    0x108810(%ecx),%edx
		if (p <= 0 || p >= NPROCS || p == current->p_pid
		    || proc_array[p].p_state == P_EMPTY)
			current->p_registers.reg_eax = -1;
		else if (proc_array[p].p_state == P_ZOMBIE)
                {
                        proc_array[p].p_state = P_EMPTY;
  100258:	c7 43 40 00 00 00 00 	movl   $0x0,0x40(%ebx)
                        current->p_registers.reg_eax = proc_array[p].p_exit_status;
  10025f:	89 50 20             	mov    %edx,0x20(%eax)
  100262:	eb 17                	jmp    10027b <interrupt+0x1bd>
                        //current->p_registers.reg_eax = proc_array[p].p_state;
                }
		else
                {
                  current->p_state = P_BLOCKED;	// Set status of the current process to be BLOCKED
                  proc_array[p].waiting_me[current->p_pid] = 1;  // Notify the waited process someone is waiting
  100264:	6b d2 24             	imul   $0x24,%edx,%edx
  100267:	03 10                	add    (%eax),%edx
                        current->p_registers.reg_eax = proc_array[p].p_exit_status;
                        //current->p_registers.reg_eax = proc_array[p].p_state;
                }
		else
                {
                  current->p_state = P_BLOCKED;	// Set status of the current process to be BLOCKED
  100269:	c7 40 48 02 00 00 00 	movl   $0x2,0x48(%eax)
                  proc_array[p].waiting_me[current->p_pid] = 1;  // Notify the waited process someone is waiting
  100270:	c7 04 95 14 88 10 00 	movl   $0x1,0x108814(,%edx,4)
  100277:	01 00 00 00 
                }
		schedule();
  10027b:	e8 0c fe ff ff       	call   10008c <schedule>
  100280:	eb fe                	jmp    100280 <interrupt+0x1c2>

00100282 <start>:
 *
 *****************************************************************************/

void
start(void)
{
  100282:	53                   	push   %ebx
  100283:	83 ec 0c             	sub    $0xc,%esp
	const char *s;
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
  100286:	68 00 09 00 00       	push   $0x900
  10028b:	6a 00                	push   $0x0
  10028d:	68 c4 87 10 00       	push   $0x1087c4
  100292:	e8 61 03 00 00       	call   1005f8 <memset>
  100297:	ba c4 87 10 00       	mov    $0x1087c4,%edx
  10029c:	31 c0                	xor    %eax,%eax
  10029e:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < NPROCS; i++) {
                int j;
                proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
  1002a1:	69 d8 90 00 00 00    	imul   $0x90,%eax,%ebx
  1002a7:	31 c9                	xor    %ecx,%ecx

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
                int j;
                proc_array[i].p_pid = i;
  1002a9:	89 02                	mov    %eax,(%edx)
		proc_array[i].p_state = P_EMPTY;
  1002ab:	c7 42 48 00 00 00 00 	movl   $0x0,0x48(%edx)
  1002b2:	81 c3 14 88 10 00    	add    $0x108814,%ebx
                for (j = 0; j < NPROCS; j++)
  1002b8:	41                   	inc    %ecx
                  proc_array[i].waiting_me[j] = 0;
  1002b9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
                int j;
                proc_array[i].p_pid = i;
		proc_array[i].p_state = P_EMPTY;
                for (j = 0; j < NPROCS; j++)
  1002bf:	83 c3 04             	add    $0x4,%ebx
  1002c2:	83 f9 10             	cmp    $0x10,%ecx
  1002c5:	75 f1                	jne    1002b8 <start+0x36>
	int whichprocess;
	pid_t i;

	// Initialize process descriptors as empty
	memset(proc_array, 0, sizeof(proc_array));
	for (i = 0; i < NPROCS; i++) {
  1002c7:	40                   	inc    %eax
  1002c8:	81 c2 90 00 00 00    	add    $0x90,%edx
  1002ce:	83 f8 10             	cmp    $0x10,%eax
  1002d1:	75 ce                	jne    1002a1 <start+0x1f>
                for (j = 0; j < NPROCS; j++)
                  proc_array[i].waiting_me[j] = 0;
	}

	// The first process has process ID 1.
	current = &proc_array[1];
  1002d3:	c7 05 2c 99 10 00 54 	movl   $0x108854,0x10992c
  1002da:	88 10 00 

	// Set up x86 hardware, and initialize the first process's
	// special registers.  This only needs to be done once, at boot time.
	// All other processes' special registers can be copied from the
	// first process.
	segments_init();
  1002dd:	e8 72 00 00 00       	call   100354 <segments_init>
	special_registers_init(current);
  1002e2:	83 ec 0c             	sub    $0xc,%esp
  1002e5:	ff 35 2c 99 10 00    	pushl  0x10992c
  1002eb:	e8 e3 01 00 00       	call   1004d3 <special_registers_init>

	// Erase the console, and initialize the cursor-position shared
	// variable to point to its upper left.
	console_clear();
  1002f0:	e8 2e 01 00 00       	call   100423 <console_clear>

	// Figure out which program to run.
	cursorpos = console_printf(cursorpos, 0x0700, "Type '1' to run mpos-app, or '2' to run mpos-app2.");
  1002f5:	83 c4 0c             	add    $0xc,%esp
  1002f8:	68 88 0a 10 00       	push   $0x100a88
  1002fd:	68 00 07 00 00       	push   $0x700
  100302:	ff 35 00 00 06 00    	pushl  0x60000
  100308:	e8 4d 07 00 00       	call   100a5a <console_printf>
  10030d:	83 c4 10             	add    $0x10,%esp
  100310:	a3 00 00 06 00       	mov    %eax,0x60000
	do {
		whichprocess = console_read_digit();
  100315:	e8 4c 01 00 00       	call   100466 <console_read_digit>
	} while (whichprocess != 1 && whichprocess != 2);
  10031a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  10031d:	83 fb 01             	cmp    $0x1,%ebx
  100320:	77 f3                	ja     100315 <start+0x93>
	console_clear();
  100322:	e8 fc 00 00 00       	call   100423 <console_clear>

	// Load the process application code and data into memory.
	// Store its entry point into the first process's EIP
	// (instruction pointer).
	program_loader(whichprocess - 1, &current->p_registers.reg_eip);
  100327:	a1 2c 99 10 00       	mov    0x10992c,%eax
  10032c:	83 c0 34             	add    $0x34,%eax
  10032f:	52                   	push   %edx
  100330:	52                   	push   %edx
  100331:	50                   	push   %eax
  100332:	53                   	push   %ebx
  100333:	e8 d0 01 00 00       	call   100508 <program_loader>

	// Set the main process's stack pointer, ESP.
	current->p_registers.reg_esp = PROC1_STACK_ADDR + PROC_STACK_SIZE;
  100338:	a1 2c 99 10 00       	mov    0x10992c,%eax
  10033d:	c7 40 40 00 00 2c 00 	movl   $0x2c0000,0x40(%eax)

	// Mark the process as runnable!
	current->p_state = P_RUNNABLE;
  100344:	c7 40 48 01 00 00 00 	movl   $0x1,0x48(%eax)

	// Switch to the main process using run().
	run(current);
  10034b:	89 04 24             	mov    %eax,(%esp)
  10034e:	e8 69 01 00 00       	call   1004bc <run>
  100353:	90                   	nop

00100354 <segments_init>:
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100354:	b8 c4 90 10 00       	mov    $0x1090c4,%eax
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100359:	b9 56 00 10 00       	mov    $0x100056,%ecx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  10035e:	89 c2                	mov    %eax,%edx
  100360:	c1 ea 10             	shr    $0x10,%edx
extern void default_int_handler(void);


void
segments_init(void)
{
  100363:	53                   	push   %ebx
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100364:	bb 56 00 10 00       	mov    $0x100056,%ebx
  100369:	c1 eb 10             	shr    $0x10,%ebx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  10036c:	66 a3 3a 10 10 00    	mov    %ax,0x10103a
  100372:	c1 e8 18             	shr    $0x18,%eax
  100375:	88 15 3c 10 10 00    	mov    %dl,0x10103c
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  10037b:	ba 2c 91 10 00       	mov    $0x10912c,%edx
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100380:	a2 3f 10 10 00       	mov    %al,0x10103f
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  100385:	31 c0                	xor    %eax,%eax
segments_init(void)
{
	int i;

	// Set task state segment
	segments[SEGSEL_TASKSTATE >> 3]
  100387:	66 c7 05 38 10 10 00 	movw   $0x68,0x101038
  10038e:	68 00 
  100390:	c6 05 3e 10 10 00 40 	movb   $0x40,0x10103e
		= SEG16(STS_T32A, (uint32_t) &kernel_task_descriptor,
			sizeof(taskstate_t), 0);
	segments[SEGSEL_TASKSTATE >> 3].sd_s = 0;
  100397:	c6 05 3d 10 10 00 89 	movb   $0x89,0x10103d

	// Set up kernel task descriptor, so we can receive interrupts
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
  10039e:	c7 05 c8 90 10 00 00 	movl   $0x80000,0x1090c8
  1003a5:	00 08 00 
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;
  1003a8:	66 c7 05 cc 90 10 00 	movw   $0x10,0x1090cc
  1003af:	10 00 

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
		SETGATE(interrupt_descriptors[i], 0,
  1003b1:	66 89 0c c5 2c 91 10 	mov    %cx,0x10912c(,%eax,8)
  1003b8:	00 
  1003b9:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  1003c0:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  1003c5:	c6 44 c2 05 8e       	movb   $0x8e,0x5(%edx,%eax,8)
  1003ca:	66 89 5c c2 06       	mov    %bx,0x6(%edx,%eax,8)
	kernel_task_descriptor.ts_esp0 = KERNEL_STACK_TOP;
	kernel_task_descriptor.ts_ss0 = SEGSEL_KERN_DATA;

	// Set up interrupt descriptor table.
	// Most interrupts are effectively ignored
	for (i = 0; i < sizeof(interrupt_descriptors) / sizeof(gatedescriptor_t); i++)
  1003cf:	40                   	inc    %eax
  1003d0:	3d 00 01 00 00       	cmp    $0x100,%eax
  1003d5:	75 da                	jne    1003b1 <segments_init+0x5d>
  1003d7:	66 b8 30 00          	mov    $0x30,%ax

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
		SETGATE(interrupt_descriptors[i], 0,
  1003db:	ba 2c 91 10 00       	mov    $0x10912c,%edx
  1003e0:	8b 0c 85 a3 ff 0f 00 	mov    0xfffa3(,%eax,4),%ecx
  1003e7:	66 c7 44 c2 02 08 00 	movw   $0x8,0x2(%edx,%eax,8)
  1003ee:	66 89 0c c5 2c 91 10 	mov    %cx,0x10912c(,%eax,8)
  1003f5:	00 
  1003f6:	c1 e9 10             	shr    $0x10,%ecx
  1003f9:	c6 44 c2 04 00       	movb   $0x0,0x4(%edx,%eax,8)
  1003fe:	c6 44 c2 05 ee       	movb   $0xee,0x5(%edx,%eax,8)
  100403:	66 89 4c c2 06       	mov    %cx,0x6(%edx,%eax,8)
			SEGSEL_KERN_CODE, default_int_handler, 0);

	// System calls get special handling.
	// Note that the last argument is '3'.  This means that unprivileged
	// (level-3) applications may generate these interrupts.
	for (i = INT_SYS_GETPID; i < INT_SYS_GETPID + 10; i++)
  100408:	40                   	inc    %eax
  100409:	83 f8 3a             	cmp    $0x3a,%eax
  10040c:	75 d2                	jne    1003e0 <segments_init+0x8c>
		SETGATE(interrupt_descriptors[i], 0,
			SEGSEL_KERN_CODE, sys_int_handlers[i - INT_SYS_GETPID], 3);

	// Reload segment pointers
	asm volatile("lgdt global_descriptor_table\n\t"
  10040e:	b0 28                	mov    $0x28,%al
  100410:	0f 01 15 00 10 10 00 	lgdtl  0x101000
  100417:	0f 00 d8             	ltr    %ax
  10041a:	0f 01 1d 08 10 10 00 	lidtl  0x101008
		     "lidt interrupt_descriptor_table"
		     : : "r" ((uint16_t) SEGSEL_TASKSTATE));

	// Convince compiler that all symbols were used
	(void) global_descriptor_table, (void) interrupt_descriptor_table;
}
  100421:	5b                   	pop    %ebx
  100422:	c3                   	ret    

00100423 <console_clear>:
 *
 *****************************************************************************/

void
console_clear(void)
{
  100423:	56                   	push   %esi
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  100424:	31 c0                	xor    %eax,%eax
 *
 *****************************************************************************/

void
console_clear(void)
{
  100426:	53                   	push   %ebx
	int i;
	cursorpos = (uint16_t *) 0xB8000;
  100427:	c7 05 00 00 06 00 00 	movl   $0xb8000,0x60000
  10042e:	80 0b 00 

	for (i = 0; i < 80 * 25; i++)
		cursorpos[i] = ' ' | 0x0700;
  100431:	66 c7 84 00 00 80 0b 	movw   $0x720,0xb8000(%eax,%eax,1)
  100438:	00 20 07 
console_clear(void)
{
	int i;
	cursorpos = (uint16_t *) 0xB8000;

	for (i = 0; i < 80 * 25; i++)
  10043b:	40                   	inc    %eax
  10043c:	3d d0 07 00 00       	cmp    $0x7d0,%eax
  100441:	75 ee                	jne    100431 <console_clear+0xe>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
  100443:	be d4 03 00 00       	mov    $0x3d4,%esi
  100448:	b0 0e                	mov    $0xe,%al
  10044a:	89 f2                	mov    %esi,%edx
  10044c:	ee                   	out    %al,(%dx)
  10044d:	31 c9                	xor    %ecx,%ecx
  10044f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
  100454:	88 c8                	mov    %cl,%al
  100456:	89 da                	mov    %ebx,%edx
  100458:	ee                   	out    %al,(%dx)
  100459:	b0 0f                	mov    $0xf,%al
  10045b:	89 f2                	mov    %esi,%edx
  10045d:	ee                   	out    %al,(%dx)
  10045e:	88 c8                	mov    %cl,%al
  100460:	89 da                	mov    %ebx,%edx
  100462:	ee                   	out    %al,(%dx)
		cursorpos[i] = ' ' | 0x0700;
	outb(0x3D4, 14);
	outb(0x3D5, 0 / 256);
	outb(0x3D4, 15);
	outb(0x3D5, 0 % 256);
}
  100463:	5b                   	pop    %ebx
  100464:	5e                   	pop    %esi
  100465:	c3                   	ret    

00100466 <console_read_digit>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  100466:	ba 64 00 00 00       	mov    $0x64,%edx
  10046b:	ec                   	in     (%dx),%al
int
console_read_digit(void)
{
	uint8_t data;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
  10046c:	a8 01                	test   $0x1,%al
  10046e:	74 45                	je     1004b5 <console_read_digit+0x4f>
  100470:	b2 60                	mov    $0x60,%dl
  100472:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);
	if (data >= 0x02 && data <= 0x0A)
  100473:	8d 50 fe             	lea    -0x2(%eax),%edx
  100476:	80 fa 08             	cmp    $0x8,%dl
  100479:	77 05                	ja     100480 <console_read_digit+0x1a>
		return data - 0x02 + 1;
  10047b:	0f b6 c0             	movzbl %al,%eax
  10047e:	48                   	dec    %eax
  10047f:	c3                   	ret    
	else if (data == 0x0B)
  100480:	3c 0b                	cmp    $0xb,%al
  100482:	74 35                	je     1004b9 <console_read_digit+0x53>
		return 0;
	else if (data >= 0x47 && data <= 0x49)
  100484:	8d 50 b9             	lea    -0x47(%eax),%edx
  100487:	80 fa 02             	cmp    $0x2,%dl
  10048a:	77 07                	ja     100493 <console_read_digit+0x2d>
		return data - 0x47 + 7;
  10048c:	0f b6 c0             	movzbl %al,%eax
  10048f:	83 e8 40             	sub    $0x40,%eax
  100492:	c3                   	ret    
	else if (data >= 0x4B && data <= 0x4D)
  100493:	8d 50 b5             	lea    -0x4b(%eax),%edx
  100496:	80 fa 02             	cmp    $0x2,%dl
  100499:	77 07                	ja     1004a2 <console_read_digit+0x3c>
		return data - 0x4B + 4;
  10049b:	0f b6 c0             	movzbl %al,%eax
  10049e:	83 e8 47             	sub    $0x47,%eax
  1004a1:	c3                   	ret    
	else if (data >= 0x4F && data <= 0x51)
  1004a2:	8d 50 b1             	lea    -0x4f(%eax),%edx
  1004a5:	80 fa 02             	cmp    $0x2,%dl
  1004a8:	77 07                	ja     1004b1 <console_read_digit+0x4b>
		return data - 0x4F + 1;
  1004aa:	0f b6 c0             	movzbl %al,%eax
  1004ad:	83 e8 4e             	sub    $0x4e,%eax
  1004b0:	c3                   	ret    
	else if (data == 0x53)
  1004b1:	3c 53                	cmp    $0x53,%al
  1004b3:	74 04                	je     1004b9 <console_read_digit+0x53>
  1004b5:	83 c8 ff             	or     $0xffffffff,%eax
  1004b8:	c3                   	ret    
  1004b9:	31 c0                	xor    %eax,%eax
		return 0;
	else
		return -1;
}
  1004bb:	c3                   	ret    

001004bc <run>:
 *
 *****************************************************************************/

void
run(process_t *proc)
{
  1004bc:	8b 44 24 04          	mov    0x4(%esp),%eax
	current = proc;
  1004c0:	a3 2c 99 10 00       	mov    %eax,0x10992c

	asm volatile("movl %0,%%esp\n\t"
  1004c5:	83 c0 04             	add    $0x4,%eax
  1004c8:	89 c4                	mov    %eax,%esp
  1004ca:	61                   	popa   
  1004cb:	07                   	pop    %es
  1004cc:	1f                   	pop    %ds
  1004cd:	83 c4 08             	add    $0x8,%esp
  1004d0:	cf                   	iret   
  1004d1:	eb fe                	jmp    1004d1 <run+0x15>

001004d3 <special_registers_init>:
 *
 *****************************************************************************/

void
special_registers_init(process_t *proc)
{
  1004d3:	53                   	push   %ebx
  1004d4:	83 ec 0c             	sub    $0xc,%esp
  1004d7:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	memset(&proc->p_registers, 0, sizeof(registers_t));
  1004db:	6a 44                	push   $0x44
  1004dd:	6a 00                	push   $0x0
  1004df:	8d 43 04             	lea    0x4(%ebx),%eax
  1004e2:	50                   	push   %eax
  1004e3:	e8 10 01 00 00       	call   1005f8 <memset>
	proc->p_registers.reg_cs = SEGSEL_APP_CODE | 3;
  1004e8:	66 c7 43 38 1b 00    	movw   $0x1b,0x38(%ebx)
	proc->p_registers.reg_ds = SEGSEL_APP_DATA | 3;
  1004ee:	66 c7 43 28 23 00    	movw   $0x23,0x28(%ebx)
	proc->p_registers.reg_es = SEGSEL_APP_DATA | 3;
  1004f4:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	proc->p_registers.reg_ss = SEGSEL_APP_DATA | 3;
  1004fa:	66 c7 43 44 23 00    	movw   $0x23,0x44(%ebx)
}
  100500:	83 c4 18             	add    $0x18,%esp
  100503:	5b                   	pop    %ebx
  100504:	c3                   	ret    
  100505:	90                   	nop
  100506:	90                   	nop
  100507:	90                   	nop

00100508 <program_loader>:
		    uint32_t filesz, uint32_t memsz);
static void loader_panic(void);

void
program_loader(int program_id, uint32_t *entry_point)
{
  100508:	55                   	push   %ebp
  100509:	57                   	push   %edi
  10050a:	56                   	push   %esi
  10050b:	53                   	push   %ebx
  10050c:	83 ec 1c             	sub    $0x1c,%esp
  10050f:	8b 44 24 30          	mov    0x30(%esp),%eax
	struct Proghdr *ph, *eph;
	struct Elf *elf_header;
	int nprograms = sizeof(ramimages) / sizeof(ramimages[0]);

	if (program_id < 0 || program_id >= nprograms)
  100513:	83 f8 01             	cmp    $0x1,%eax
  100516:	7f 04                	jg     10051c <program_loader+0x14>
  100518:	85 c0                	test   %eax,%eax
  10051a:	79 02                	jns    10051e <program_loader+0x16>
  10051c:	eb fe                	jmp    10051c <program_loader+0x14>
		loader_panic();

	// is this a valid ELF?
	elf_header = (struct Elf *) ramimages[program_id].begin;
  10051e:	8b 34 c5 40 10 10 00 	mov    0x101040(,%eax,8),%esi
	if (elf_header->e_magic != ELF_MAGIC)
  100525:	81 3e 7f 45 4c 46    	cmpl   $0x464c457f,(%esi)
  10052b:	74 02                	je     10052f <program_loader+0x27>
  10052d:	eb fe                	jmp    10052d <program_loader+0x25>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  10052f:	8b 5e 1c             	mov    0x1c(%esi),%ebx
	eph = ph + elf_header->e_phnum;
  100532:	0f b7 6e 2c          	movzwl 0x2c(%esi),%ebp
	elf_header = (struct Elf *) ramimages[program_id].begin;
	if (elf_header->e_magic != ELF_MAGIC)
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
  100536:	01 f3                	add    %esi,%ebx
	eph = ph + elf_header->e_phnum;
  100538:	c1 e5 05             	shl    $0x5,%ebp
  10053b:	8d 2c 2b             	lea    (%ebx,%ebp,1),%ebp
	for (; ph < eph; ph++)
  10053e:	eb 3f                	jmp    10057f <program_loader+0x77>
		if (ph->p_type == ELF_PROG_LOAD)
  100540:	83 3b 01             	cmpl   $0x1,(%ebx)
  100543:	75 37                	jne    10057c <program_loader+0x74>
			copyseg((void *) ph->p_va,
  100545:	8b 43 08             	mov    0x8(%ebx),%eax
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  100548:	8b 7b 10             	mov    0x10(%ebx),%edi
	memsz += va;
  10054b:	8b 53 14             	mov    0x14(%ebx),%edx
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
  10054e:	01 c7                	add    %eax,%edi
	memsz += va;
  100550:	01 c2                	add    %eax,%edx
	va &= ~(PAGESIZE - 1);		// round to page boundary
  100552:	25 00 f0 ff ff       	and    $0xfffff000,%eax
static void
copyseg(void *dst, const uint8_t *src, uint32_t filesz, uint32_t memsz)
{
	uint32_t va = (uint32_t) dst;
	uint32_t end_va = va + filesz;
	memsz += va;
  100557:	89 54 24 0c          	mov    %edx,0xc(%esp)
	va &= ~(PAGESIZE - 1);		// round to page boundary

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);
  10055b:	52                   	push   %edx
  10055c:	89 fa                	mov    %edi,%edx
  10055e:	29 c2                	sub    %eax,%edx
  100560:	52                   	push   %edx
  100561:	8b 53 04             	mov    0x4(%ebx),%edx
  100564:	01 f2                	add    %esi,%edx
  100566:	52                   	push   %edx
  100567:	50                   	push   %eax
  100568:	e8 27 00 00 00       	call   100594 <memcpy>
  10056d:	83 c4 10             	add    $0x10,%esp
  100570:	eb 04                	jmp    100576 <program_loader+0x6e>

	// clear bss segment
	while (end_va < memsz)
		*((uint8_t *) end_va++) = 0;
  100572:	c6 07 00             	movb   $0x0,(%edi)
  100575:	47                   	inc    %edi

	// copy data
	memcpy((uint8_t *) va, src, end_va - va);

	// clear bss segment
	while (end_va < memsz)
  100576:	3b 7c 24 0c          	cmp    0xc(%esp),%edi
  10057a:	72 f6                	jb     100572 <program_loader+0x6a>
		loader_panic();

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((const uint8_t *) elf_header + elf_header->e_phoff);
	eph = ph + elf_header->e_phnum;
	for (; ph < eph; ph++)
  10057c:	83 c3 20             	add    $0x20,%ebx
  10057f:	39 eb                	cmp    %ebp,%ebx
  100581:	72 bd                	jb     100540 <program_loader+0x38>
			copyseg((void *) ph->p_va,
				(const uint8_t *) elf_header + ph->p_offset,
				ph->p_filesz, ph->p_memsz);

	// store the entry point from the ELF header
	*entry_point = elf_header->e_entry;
  100583:	8b 56 18             	mov    0x18(%esi),%edx
  100586:	8b 44 24 34          	mov    0x34(%esp),%eax
  10058a:	89 10                	mov    %edx,(%eax)
}
  10058c:	83 c4 1c             	add    $0x1c,%esp
  10058f:	5b                   	pop    %ebx
  100590:	5e                   	pop    %esi
  100591:	5f                   	pop    %edi
  100592:	5d                   	pop    %ebp
  100593:	c3                   	ret    

00100594 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  100594:	56                   	push   %esi
  100595:	31 d2                	xor    %edx,%edx
  100597:	53                   	push   %ebx
  100598:	8b 44 24 0c          	mov    0xc(%esp),%eax
  10059c:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  1005a0:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  1005a4:	eb 08                	jmp    1005ae <memcpy+0x1a>
		*d++ = *s++;
  1005a6:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  1005a9:	4e                   	dec    %esi
  1005aa:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  1005ad:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  1005ae:	85 f6                	test   %esi,%esi
  1005b0:	75 f4                	jne    1005a6 <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  1005b2:	5b                   	pop    %ebx
  1005b3:	5e                   	pop    %esi
  1005b4:	c3                   	ret    

001005b5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  1005b5:	57                   	push   %edi
  1005b6:	56                   	push   %esi
  1005b7:	53                   	push   %ebx
  1005b8:	8b 44 24 10          	mov    0x10(%esp),%eax
  1005bc:	8b 7c 24 14          	mov    0x14(%esp),%edi
  1005c0:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  1005c4:	39 c7                	cmp    %eax,%edi
  1005c6:	73 26                	jae    1005ee <memmove+0x39>
  1005c8:	8d 34 17             	lea    (%edi,%edx,1),%esi
  1005cb:	39 c6                	cmp    %eax,%esi
  1005cd:	76 1f                	jbe    1005ee <memmove+0x39>
		s += n, d += n;
  1005cf:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  1005d2:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  1005d4:	eb 07                	jmp    1005dd <memmove+0x28>
			*--d = *--s;
  1005d6:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  1005d9:	4a                   	dec    %edx
  1005da:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  1005dd:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  1005de:	85 d2                	test   %edx,%edx
  1005e0:	75 f4                	jne    1005d6 <memmove+0x21>
  1005e2:	eb 10                	jmp    1005f4 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  1005e4:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  1005e7:	4a                   	dec    %edx
  1005e8:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  1005eb:	41                   	inc    %ecx
  1005ec:	eb 02                	jmp    1005f0 <memmove+0x3b>
  1005ee:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  1005f0:	85 d2                	test   %edx,%edx
  1005f2:	75 f0                	jne    1005e4 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  1005f4:	5b                   	pop    %ebx
  1005f5:	5e                   	pop    %esi
  1005f6:	5f                   	pop    %edi
  1005f7:	c3                   	ret    

001005f8 <memset>:

void *
memset(void *v, int c, size_t n)
{
  1005f8:	53                   	push   %ebx
  1005f9:	8b 44 24 08          	mov    0x8(%esp),%eax
  1005fd:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  100601:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  100605:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  100607:	eb 04                	jmp    10060d <memset+0x15>
		*p++ = c;
  100609:	88 1a                	mov    %bl,(%edx)
  10060b:	49                   	dec    %ecx
  10060c:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  10060d:	85 c9                	test   %ecx,%ecx
  10060f:	75 f8                	jne    100609 <memset+0x11>
		*p++ = c;
	return v;
}
  100611:	5b                   	pop    %ebx
  100612:	c3                   	ret    

00100613 <strlen>:

size_t
strlen(const char *s)
{
  100613:	8b 54 24 04          	mov    0x4(%esp),%edx
  100617:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  100619:	eb 01                	jmp    10061c <strlen+0x9>
		++n;
  10061b:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  10061c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  100620:	75 f9                	jne    10061b <strlen+0x8>
		++n;
	return n;
}
  100622:	c3                   	ret    

00100623 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  100623:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  100627:	31 c0                	xor    %eax,%eax
  100629:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  10062d:	eb 01                	jmp    100630 <strnlen+0xd>
		++n;
  10062f:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  100630:	39 d0                	cmp    %edx,%eax
  100632:	74 06                	je     10063a <strnlen+0x17>
  100634:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  100638:	75 f5                	jne    10062f <strnlen+0xc>
		++n;
	return n;
}
  10063a:	c3                   	ret    

0010063b <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  10063b:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  10063c:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  100641:	53                   	push   %ebx
  100642:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  100644:	76 05                	jbe    10064b <console_putc+0x10>
  100646:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  10064b:	80 fa 0a             	cmp    $0xa,%dl
  10064e:	75 2c                	jne    10067c <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  100650:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  100656:	be 50 00 00 00       	mov    $0x50,%esi
  10065b:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  10065d:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  100660:	99                   	cltd   
  100661:	f7 fe                	idiv   %esi
  100663:	89 de                	mov    %ebx,%esi
  100665:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  100667:	eb 07                	jmp    100670 <console_putc+0x35>
			*cursor++ = ' ' | color;
  100669:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  10066c:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  10066d:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  100670:	83 f8 50             	cmp    $0x50,%eax
  100673:	75 f4                	jne    100669 <console_putc+0x2e>
  100675:	29 d0                	sub    %edx,%eax
  100677:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  10067a:	eb 0b                	jmp    100687 <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  10067c:	0f b6 d2             	movzbl %dl,%edx
  10067f:	09 ca                	or     %ecx,%edx
  100681:	66 89 13             	mov    %dx,(%ebx)
  100684:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  100687:	5b                   	pop    %ebx
  100688:	5e                   	pop    %esi
  100689:	c3                   	ret    

0010068a <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  10068a:	56                   	push   %esi
  10068b:	53                   	push   %ebx
  10068c:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  100690:	8d 58 ff             	lea    -0x1(%eax),%ebx
  100693:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  100697:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  10069c:	75 04                	jne    1006a2 <fill_numbuf+0x18>
  10069e:	85 d2                	test   %edx,%edx
  1006a0:	74 10                	je     1006b2 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  1006a2:	89 d0                	mov    %edx,%eax
  1006a4:	31 d2                	xor    %edx,%edx
  1006a6:	f7 f1                	div    %ecx
  1006a8:	4b                   	dec    %ebx
  1006a9:	8a 14 16             	mov    (%esi,%edx,1),%dl
  1006ac:	88 13                	mov    %dl,(%ebx)
			val /= base;
  1006ae:	89 c2                	mov    %eax,%edx
  1006b0:	eb ec                	jmp    10069e <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  1006b2:	89 d8                	mov    %ebx,%eax
  1006b4:	5b                   	pop    %ebx
  1006b5:	5e                   	pop    %esi
  1006b6:	c3                   	ret    

001006b7 <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  1006b7:	55                   	push   %ebp
  1006b8:	57                   	push   %edi
  1006b9:	56                   	push   %esi
  1006ba:	53                   	push   %ebx
  1006bb:	83 ec 38             	sub    $0x38,%esp
  1006be:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  1006c2:	8b 7c 24 54          	mov    0x54(%esp),%edi
  1006c6:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  1006ca:	e9 60 03 00 00       	jmp    100a2f <console_vprintf+0x378>
		if (*format != '%') {
  1006cf:	80 fa 25             	cmp    $0x25,%dl
  1006d2:	74 13                	je     1006e7 <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  1006d4:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1006d8:	0f b6 d2             	movzbl %dl,%edx
  1006db:	89 f0                	mov    %esi,%eax
  1006dd:	e8 59 ff ff ff       	call   10063b <console_putc>
  1006e2:	e9 45 03 00 00       	jmp    100a2c <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  1006e7:	47                   	inc    %edi
  1006e8:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  1006ef:	00 
  1006f0:	eb 12                	jmp    100704 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  1006f2:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  1006f3:	8a 11                	mov    (%ecx),%dl
  1006f5:	84 d2                	test   %dl,%dl
  1006f7:	74 1a                	je     100713 <console_vprintf+0x5c>
  1006f9:	89 e8                	mov    %ebp,%eax
  1006fb:	38 c2                	cmp    %al,%dl
  1006fd:	75 f3                	jne    1006f2 <console_vprintf+0x3b>
  1006ff:	e9 3f 03 00 00       	jmp    100a43 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100704:	8a 17                	mov    (%edi),%dl
  100706:	84 d2                	test   %dl,%dl
  100708:	74 0b                	je     100715 <console_vprintf+0x5e>
  10070a:	b9 bc 0a 10 00       	mov    $0x100abc,%ecx
  10070f:	89 d5                	mov    %edx,%ebp
  100711:	eb e0                	jmp    1006f3 <console_vprintf+0x3c>
  100713:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  100715:	8d 42 cf             	lea    -0x31(%edx),%eax
  100718:	3c 08                	cmp    $0x8,%al
  10071a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  100721:	00 
  100722:	76 13                	jbe    100737 <console_vprintf+0x80>
  100724:	eb 1d                	jmp    100743 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  100726:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  10072b:	0f be c0             	movsbl %al,%eax
  10072e:	47                   	inc    %edi
  10072f:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  100733:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  100737:	8a 07                	mov    (%edi),%al
  100739:	8d 50 d0             	lea    -0x30(%eax),%edx
  10073c:	80 fa 09             	cmp    $0x9,%dl
  10073f:	76 e5                	jbe    100726 <console_vprintf+0x6f>
  100741:	eb 18                	jmp    10075b <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  100743:	80 fa 2a             	cmp    $0x2a,%dl
  100746:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  10074d:	ff 
  10074e:	75 0b                	jne    10075b <console_vprintf+0xa4>
			width = va_arg(val, int);
  100750:	83 c3 04             	add    $0x4,%ebx
			++format;
  100753:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  100754:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100757:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  10075b:	83 cd ff             	or     $0xffffffff,%ebp
  10075e:	80 3f 2e             	cmpb   $0x2e,(%edi)
  100761:	75 37                	jne    10079a <console_vprintf+0xe3>
			++format;
  100763:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  100764:	31 ed                	xor    %ebp,%ebp
  100766:	8a 07                	mov    (%edi),%al
  100768:	8d 50 d0             	lea    -0x30(%eax),%edx
  10076b:	80 fa 09             	cmp    $0x9,%dl
  10076e:	76 0d                	jbe    10077d <console_vprintf+0xc6>
  100770:	eb 17                	jmp    100789 <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  100772:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  100775:	0f be c0             	movsbl %al,%eax
  100778:	47                   	inc    %edi
  100779:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  10077d:	8a 07                	mov    (%edi),%al
  10077f:	8d 50 d0             	lea    -0x30(%eax),%edx
  100782:	80 fa 09             	cmp    $0x9,%dl
  100785:	76 eb                	jbe    100772 <console_vprintf+0xbb>
  100787:	eb 11                	jmp    10079a <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  100789:	3c 2a                	cmp    $0x2a,%al
  10078b:	75 0b                	jne    100798 <console_vprintf+0xe1>
				precision = va_arg(val, int);
  10078d:	83 c3 04             	add    $0x4,%ebx
				++format;
  100790:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  100791:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  100794:	85 ed                	test   %ebp,%ebp
  100796:	79 02                	jns    10079a <console_vprintf+0xe3>
  100798:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  10079a:	8a 07                	mov    (%edi),%al
  10079c:	3c 64                	cmp    $0x64,%al
  10079e:	74 34                	je     1007d4 <console_vprintf+0x11d>
  1007a0:	7f 1d                	jg     1007bf <console_vprintf+0x108>
  1007a2:	3c 58                	cmp    $0x58,%al
  1007a4:	0f 84 a2 00 00 00    	je     10084c <console_vprintf+0x195>
  1007aa:	3c 63                	cmp    $0x63,%al
  1007ac:	0f 84 bf 00 00 00    	je     100871 <console_vprintf+0x1ba>
  1007b2:	3c 43                	cmp    $0x43,%al
  1007b4:	0f 85 d0 00 00 00    	jne    10088a <console_vprintf+0x1d3>
  1007ba:	e9 a3 00 00 00       	jmp    100862 <console_vprintf+0x1ab>
  1007bf:	3c 75                	cmp    $0x75,%al
  1007c1:	74 4d                	je     100810 <console_vprintf+0x159>
  1007c3:	3c 78                	cmp    $0x78,%al
  1007c5:	74 5c                	je     100823 <console_vprintf+0x16c>
  1007c7:	3c 73                	cmp    $0x73,%al
  1007c9:	0f 85 bb 00 00 00    	jne    10088a <console_vprintf+0x1d3>
  1007cf:	e9 86 00 00 00       	jmp    10085a <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  1007d4:	83 c3 04             	add    $0x4,%ebx
  1007d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  1007da:	89 d1                	mov    %edx,%ecx
  1007dc:	c1 f9 1f             	sar    $0x1f,%ecx
  1007df:	89 0c 24             	mov    %ecx,(%esp)
  1007e2:	31 ca                	xor    %ecx,%edx
  1007e4:	55                   	push   %ebp
  1007e5:	29 ca                	sub    %ecx,%edx
  1007e7:	68 c4 0a 10 00       	push   $0x100ac4
  1007ec:	b9 0a 00 00 00       	mov    $0xa,%ecx
  1007f1:	8d 44 24 40          	lea    0x40(%esp),%eax
  1007f5:	e8 90 fe ff ff       	call   10068a <fill_numbuf>
  1007fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  1007fe:	58                   	pop    %eax
  1007ff:	5a                   	pop    %edx
  100800:	ba 01 00 00 00       	mov    $0x1,%edx
  100805:	8b 04 24             	mov    (%esp),%eax
  100808:	83 e0 01             	and    $0x1,%eax
  10080b:	e9 a5 00 00 00       	jmp    1008b5 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  100810:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  100813:	b9 0a 00 00 00       	mov    $0xa,%ecx
  100818:	8b 53 fc             	mov    -0x4(%ebx),%edx
  10081b:	55                   	push   %ebp
  10081c:	68 c4 0a 10 00       	push   $0x100ac4
  100821:	eb 11                	jmp    100834 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  100823:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  100826:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100829:	55                   	push   %ebp
  10082a:	68 d8 0a 10 00       	push   $0x100ad8
  10082f:	b9 10 00 00 00       	mov    $0x10,%ecx
  100834:	8d 44 24 40          	lea    0x40(%esp),%eax
  100838:	e8 4d fe ff ff       	call   10068a <fill_numbuf>
  10083d:	ba 01 00 00 00       	mov    $0x1,%edx
  100842:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100846:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  100848:	59                   	pop    %ecx
  100849:	59                   	pop    %ecx
  10084a:	eb 69                	jmp    1008b5 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  10084c:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  10084f:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100852:	55                   	push   %ebp
  100853:	68 c4 0a 10 00       	push   $0x100ac4
  100858:	eb d5                	jmp    10082f <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  10085a:	83 c3 04             	add    $0x4,%ebx
  10085d:	8b 43 fc             	mov    -0x4(%ebx),%eax
  100860:	eb 40                	jmp    1008a2 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  100862:	83 c3 04             	add    $0x4,%ebx
  100865:	8b 53 fc             	mov    -0x4(%ebx),%edx
  100868:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  10086c:	e9 bd 01 00 00       	jmp    100a2e <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100871:	83 c3 04             	add    $0x4,%ebx
  100874:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  100877:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  10087b:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  100880:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  100884:	88 44 24 24          	mov    %al,0x24(%esp)
  100888:	eb 27                	jmp    1008b1 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  10088a:	84 c0                	test   %al,%al
  10088c:	75 02                	jne    100890 <console_vprintf+0x1d9>
  10088e:	b0 25                	mov    $0x25,%al
  100890:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  100894:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  100899:	80 3f 00             	cmpb   $0x0,(%edi)
  10089c:	74 0a                	je     1008a8 <console_vprintf+0x1f1>
  10089e:	8d 44 24 24          	lea    0x24(%esp),%eax
  1008a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008a6:	eb 09                	jmp    1008b1 <console_vprintf+0x1fa>
				format--;
  1008a8:	8d 54 24 24          	lea    0x24(%esp),%edx
  1008ac:	4f                   	dec    %edi
  1008ad:	89 54 24 04          	mov    %edx,0x4(%esp)
  1008b1:	31 d2                	xor    %edx,%edx
  1008b3:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  1008b5:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  1008b7:	83 fd ff             	cmp    $0xffffffff,%ebp
  1008ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1008c1:	74 1f                	je     1008e2 <console_vprintf+0x22b>
  1008c3:	89 04 24             	mov    %eax,(%esp)
  1008c6:	eb 01                	jmp    1008c9 <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  1008c8:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  1008c9:	39 e9                	cmp    %ebp,%ecx
  1008cb:	74 0a                	je     1008d7 <console_vprintf+0x220>
  1008cd:	8b 44 24 04          	mov    0x4(%esp),%eax
  1008d1:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  1008d5:	75 f1                	jne    1008c8 <console_vprintf+0x211>
  1008d7:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  1008da:	89 0c 24             	mov    %ecx,(%esp)
  1008dd:	eb 1f                	jmp    1008fe <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  1008df:	42                   	inc    %edx
  1008e0:	eb 09                	jmp    1008eb <console_vprintf+0x234>
  1008e2:	89 d1                	mov    %edx,%ecx
  1008e4:	8b 14 24             	mov    (%esp),%edx
  1008e7:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  1008eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  1008ef:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  1008f3:	75 ea                	jne    1008df <console_vprintf+0x228>
  1008f5:	8b 44 24 08          	mov    0x8(%esp),%eax
  1008f9:	89 14 24             	mov    %edx,(%esp)
  1008fc:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  1008fe:	85 c0                	test   %eax,%eax
  100900:	74 0c                	je     10090e <console_vprintf+0x257>
  100902:	84 d2                	test   %dl,%dl
  100904:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  10090b:	00 
  10090c:	75 24                	jne    100932 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  10090e:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  100913:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  10091a:	00 
  10091b:	75 15                	jne    100932 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  10091d:	8b 44 24 14          	mov    0x14(%esp),%eax
  100921:	83 e0 08             	and    $0x8,%eax
  100924:	83 f8 01             	cmp    $0x1,%eax
  100927:	19 c9                	sbb    %ecx,%ecx
  100929:	f7 d1                	not    %ecx
  10092b:	83 e1 20             	and    $0x20,%ecx
  10092e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  100932:	3b 2c 24             	cmp    (%esp),%ebp
  100935:	7e 0d                	jle    100944 <console_vprintf+0x28d>
  100937:	84 d2                	test   %dl,%dl
  100939:	74 40                	je     10097b <console_vprintf+0x2c4>
			zeros = precision - len;
  10093b:	2b 2c 24             	sub    (%esp),%ebp
  10093e:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  100942:	eb 3f                	jmp    100983 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100944:	84 d2                	test   %dl,%dl
  100946:	74 33                	je     10097b <console_vprintf+0x2c4>
  100948:	8b 44 24 14          	mov    0x14(%esp),%eax
  10094c:	83 e0 06             	and    $0x6,%eax
  10094f:	83 f8 02             	cmp    $0x2,%eax
  100952:	75 27                	jne    10097b <console_vprintf+0x2c4>
  100954:	45                   	inc    %ebp
  100955:	75 24                	jne    10097b <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  100957:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100959:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  10095c:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100961:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100964:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  100967:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  10096b:	7d 0e                	jge    10097b <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  10096d:	8b 54 24 0c          	mov    0xc(%esp),%edx
  100971:	29 ca                	sub    %ecx,%edx
  100973:	29 c2                	sub    %eax,%edx
  100975:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  100979:	eb 08                	jmp    100983 <console_vprintf+0x2cc>
  10097b:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  100982:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  100983:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  100987:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100989:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  10098d:	2b 2c 24             	sub    (%esp),%ebp
  100990:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  100995:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  100998:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  10099b:	29 c5                	sub    %eax,%ebp
  10099d:	89 f0                	mov    %esi,%eax
  10099f:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  1009a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1009a7:	eb 0f                	jmp    1009b8 <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  1009a9:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009ad:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  1009b2:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  1009b3:	e8 83 fc ff ff       	call   10063b <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  1009b8:	85 ed                	test   %ebp,%ebp
  1009ba:	7e 07                	jle    1009c3 <console_vprintf+0x30c>
  1009bc:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  1009c1:	74 e6                	je     1009a9 <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  1009c3:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  1009c8:	89 c6                	mov    %eax,%esi
  1009ca:	74 23                	je     1009ef <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  1009cc:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  1009d1:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009d5:	e8 61 fc ff ff       	call   10063b <console_putc>
  1009da:	89 c6                	mov    %eax,%esi
  1009dc:	eb 11                	jmp    1009ef <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  1009de:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  1009e2:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1009e7:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  1009e8:	e8 4e fc ff ff       	call   10063b <console_putc>
  1009ed:	eb 06                	jmp    1009f5 <console_vprintf+0x33e>
  1009ef:	89 f0                	mov    %esi,%eax
  1009f1:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  1009f5:	85 f6                	test   %esi,%esi
  1009f7:	7f e5                	jg     1009de <console_vprintf+0x327>
  1009f9:	8b 34 24             	mov    (%esp),%esi
  1009fc:	eb 15                	jmp    100a13 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  1009fe:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100a02:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  100a03:	0f b6 11             	movzbl (%ecx),%edx
  100a06:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a0a:	e8 2c fc ff ff       	call   10063b <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  100a0f:	ff 44 24 04          	incl   0x4(%esp)
  100a13:	85 f6                	test   %esi,%esi
  100a15:	7f e7                	jg     1009fe <console_vprintf+0x347>
  100a17:	eb 0f                	jmp    100a28 <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  100a19:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  100a1d:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100a22:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  100a23:	e8 13 fc ff ff       	call   10063b <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  100a28:	85 ed                	test   %ebp,%ebp
  100a2a:	7f ed                	jg     100a19 <console_vprintf+0x362>
  100a2c:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  100a2e:	47                   	inc    %edi
  100a2f:	8a 17                	mov    (%edi),%dl
  100a31:	84 d2                	test   %dl,%dl
  100a33:	0f 85 96 fc ff ff    	jne    1006cf <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  100a39:	83 c4 38             	add    $0x38,%esp
  100a3c:	89 f0                	mov    %esi,%eax
  100a3e:	5b                   	pop    %ebx
  100a3f:	5e                   	pop    %esi
  100a40:	5f                   	pop    %edi
  100a41:	5d                   	pop    %ebp
  100a42:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100a43:	81 e9 bc 0a 10 00    	sub    $0x100abc,%ecx
  100a49:	b8 01 00 00 00       	mov    $0x1,%eax
  100a4e:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  100a50:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  100a51:	09 44 24 14          	or     %eax,0x14(%esp)
  100a55:	e9 aa fc ff ff       	jmp    100704 <console_vprintf+0x4d>

00100a5a <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  100a5a:	8d 44 24 10          	lea    0x10(%esp),%eax
  100a5e:	50                   	push   %eax
  100a5f:	ff 74 24 10          	pushl  0x10(%esp)
  100a63:	ff 74 24 10          	pushl  0x10(%esp)
  100a67:	ff 74 24 10          	pushl  0x10(%esp)
  100a6b:	e8 47 fc ff ff       	call   1006b7 <console_vprintf>
  100a70:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  100a73:	c3                   	ret    
