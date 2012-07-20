
obj/mpos-bootsector.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.set SEGSEL_BOOT_DATA,0x10	# data segment selector
.set CR0_PE_ON,0x1		# protected mode enable flag

.globl start					# Entry point
start:		.code16				# This runs in real mode
		cli				# Disable interrupts
    7c00:	fa                   	cli    
		cld				# String operations increment
    7c01:	fc                   	cld    

		# Set up the important data segment registers (DS, ES, SS).
		xorw	%ax,%ax			# Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
		movw	%ax,%ds			# -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
		movw	%ax,%es			# -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
		movw	%ax,%ss			# -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

		# Set up the stack pointer, growing downward from 0x7c00.
		movw	$start,%sp         	# Stack Pointer
    7c0a:	bc 00 7c e4 64       	mov    $0x64e47c00,%esp

00007c0d <seta20.1>:
#   and subsequent 80286-based PCs wanted to retain maximum compatibility),
#   physical address line 20 is tied to low when the machine boots.
#   Obviously this a bit of a drag for us, especially when trying to
#   address memory above 1MB.  This code undoes this.

seta20.1:	inb	$0x64,%al		# Get status
    7c0d:	e4 64                	in     $0x64,%al
		testb	$0x2,%al		# Busy?
    7c0f:	a8 02                	test   $0x2,%al
		jnz	seta20.1		# Yes
    7c11:	75 fa                	jne    7c0d <seta20.1>
		movb	$0xd1,%al		# Command: Write
    7c13:	b0 d1                	mov    $0xd1,%al
		outb	%al,$0x64		#  output port
    7c15:	e6 64                	out    %al,$0x64

00007c17 <seta20.2>:
seta20.2:	inb	$0x64,%al		# Get status
    7c17:	e4 64                	in     $0x64,%al
		testb	$0x2,%al		# Busy?
    7c19:	a8 02                	test   $0x2,%al
		jnz	seta20.2		# Yes
    7c1b:	75 fa                	jne    7c17 <seta20.2>
		movb	$0xdf,%al		# Enable
    7c1d:	b0 df                	mov    $0xdf,%al
		outb	%al,$0x60		#  A20
    7c1f:	e6 60                	out    %al,$0x60

00007c21 <real_to_prot>:
#   OK to run code at any address, or write to any address.
#   The 'gdt' and 'gdtdesc' tables below define these segments.
#   This code loads them into the processor.
#   We need this setup to ensure the transition to protected mode is smooth.

real_to_prot:	cli			# Don't allow interrupts: mandatory,
    7c21:	fa                   	cli    
					# since we didn't set up an interrupt
					# descriptor table for handling them
		lgdt	gdtdesc		# load GDT: mandatory in protected mode
    7c22:	0f 01 16             	lgdtl  (%esi)
    7c25:	64                   	fs
    7c26:	7c 0f                	jl     7c37 <protcseg+0x1>
		movl	%cr0, %eax	# Turn on protected mode
    7c28:	20 c0                	and    %al,%al
		orl	$CR0_PE_ON, %eax
    7c2a:	66 83 c8 01          	or     $0x1,%ax
		movl	%eax, %cr0
    7c2e:	0f 22 c0             	mov    %eax,%cr0

	        # CPU magic: jump to relocation, flush prefetch queue, and
		# reload %cs.  Has the effect of just jmp to the next
		# instruction, but simultaneously loads CS with
		# $SEGSEL_BOOT_CODE.
		ljmp	$SEGSEL_BOOT_CODE, $protcseg
    7c31:	ea 36 7c 08 00 66 b8 	ljmp   $0xb866,$0x87c36

00007c36 <protcseg>:

		.code32			# run in 32-bit protected mode
		# Set up the protected-mode data segment registers
protcseg:	movw	$SEGSEL_BOOT_DATA, %ax	# Our data segment selector
    7c36:	66 b8 10 00          	mov    $0x10,%ax
		movw	%ax, %ds		# -> DS: Data Segment
    7c3a:	8e d8                	mov    %eax,%ds
		movw	%ax, %es		# -> ES: Extra Segment
    7c3c:	8e c0                	mov    %eax,%es
		movw	%ax, %fs		# -> FS
    7c3e:	8e e0                	mov    %eax,%fs
		movw	%ax, %gs		# -> GS
    7c40:	8e e8                	mov    %eax,%gs
		movw	%ax, %ss		# -> SS: Stack Segment
    7c42:	8e d0                	mov    %eax,%ss

		call bootmain		# finish the boot!  Shouldn't return,
    7c44:	e8 d7 00 00 00       	call   7d20 <bootmain>

00007c49 <spinloop>:

spinloop:	jmp spinloop		# ..but in case it does, spin.
    7c49:	eb fe                	jmp    7c49 <spinloop>
    7c4b:	90                   	nop

00007c4c <gdt>:
	...
    7c54:	ff                   	(bad)  
    7c55:	ff 00                	incl   (%eax)
    7c57:	00 00                	add    %al,(%eax)
    7c59:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c60:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

00007c64 <gdtdesc>:
    7c64:	17                   	pop    %ss
    7c65:	00 4c 7c 00          	add    %cl,0x0(%esp,%edi,2)
    7c69:	00 90 90 ba f7 01    	add    %dl,0x1f7ba90(%eax)

00007c6c <waitdisk>:

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7c6c:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c71:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c72:	25 c0 00 00 00       	and    $0xc0,%eax
    7c77:	83 f8 40             	cmp    $0x40,%eax
    7c7a:	75 f5                	jne    7c71 <waitdisk+0x5>
		/* do nothing */;
}
    7c7c:	c3                   	ret    

00007c7d <readsect>:

void
readsect(void *dst, uint32_t sect)
{
    7c7d:	57                   	push   %edi
    7c7e:	8b 4c 24 0c          	mov    0xc(%esp),%ecx
    7c82:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7c87:	ec                   	in     (%dx),%al

void
waitdisk(void)
{
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7c88:	25 c0 00 00 00       	and    $0xc0,%eax
    7c8d:	83 f8 40             	cmp    $0x40,%eax
    7c90:	75 f5                	jne    7c87 <readsect+0xa>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7c92:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7c97:	b0 01                	mov    $0x1,%al
    7c99:	ee                   	out    %al,(%dx)
    7c9a:	b2 f3                	mov    $0xf3,%dl
    7c9c:	88 c8                	mov    %cl,%al
    7c9e:	ee                   	out    %al,(%dx)
    7c9f:	89 c8                	mov    %ecx,%eax
    7ca1:	b2 f4                	mov    $0xf4,%dl
    7ca3:	c1 e8 08             	shr    $0x8,%eax
    7ca6:	ee                   	out    %al,(%dx)
    7ca7:	89 c8                	mov    %ecx,%eax
    7ca9:	b2 f5                	mov    $0xf5,%dl
    7cab:	c1 e8 10             	shr    $0x10,%eax
    7cae:	ee                   	out    %al,(%dx)
    7caf:	c1 e9 18             	shr    $0x18,%ecx
    7cb2:	b2 f6                	mov    $0xf6,%dl
    7cb4:	88 c8                	mov    %cl,%al
    7cb6:	83 c8 e0             	or     $0xffffffe0,%eax
    7cb9:	ee                   	out    %al,(%dx)
    7cba:	b0 20                	mov    $0x20,%al
    7cbc:	b2 f7                	mov    $0xf7,%dl
    7cbe:	ee                   	out    %al,(%dx)

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7cbf:	ec                   	in     (%dx),%al
    7cc0:	25 c0 00 00 00       	and    $0xc0,%eax
    7cc5:	83 f8 40             	cmp    $0x40,%eax
    7cc8:	75 f5                	jne    7cbf <readsect+0x42>
}

static inline void
insl(int port, void *addr, int cnt)
{
	asm volatile("cld\n\trepne\n\tinsl"			:
    7cca:	8b 7c 24 08          	mov    0x8(%esp),%edi
    7cce:	b9 80 00 00 00       	mov    $0x80,%ecx
    7cd3:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7cd8:	fc                   	cld    
    7cd9:	f2 6d                	repnz insl (%dx),%es:(%edi)
	// wait for disk to be ready
	waitdisk();

	// read a sector
	insl(0x1F0, dst, SECTORSIZE/4);
}
    7cdb:	5f                   	pop    %edi
    7cdc:	c3                   	ret    

00007cdd <readseg>:

// Read 'filesz' bytes at 'offset' from kernel into virtual address 'va',
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
void
readseg(uint32_t va, uint32_t filesz, uint32_t memsz, uint32_t sect)
{
    7cdd:	55                   	push   %ebp
    7cde:	57                   	push   %edi
    7cdf:	56                   	push   %esi
    7ce0:	53                   	push   %ebx
    7ce1:	8b 74 24 14          	mov    0x14(%esp),%esi
	uint32_t end_va;

	end_va = va + filesz;
    7ce5:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	memsz += va;
    7ce9:	8b 6c 24 1c          	mov    0x1c(%esp),%ebp

// Read 'filesz' bytes at 'offset' from kernel into virtual address 'va',
// then clear the memory from 'va+filesz' up to 'va+memsz' (set it to 0).
void
readseg(uint32_t va, uint32_t filesz, uint32_t memsz, uint32_t sect)
{
    7ced:	8b 7c 24 20          	mov    0x20(%esp),%edi
	uint32_t end_va;

	end_va = va + filesz;
    7cf1:	01 f3                	add    %esi,%ebx
	memsz += va;
    7cf3:	01 f5                	add    %esi,%ebp

	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);
    7cf5:	81 e6 00 fe ff ff    	and    $0xfffffe00,%esi

	// read sectors
	while (va < end_va) {
    7cfb:	eb 10                	jmp    7d0d <readseg+0x30>
		readsect((uint8_t*) va, sect);
    7cfd:	57                   	push   %edi
		va += SECTORSIZE;
		sect++;
    7cfe:	47                   	inc    %edi
	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);

	// read sectors
	while (va < end_va) {
		readsect((uint8_t*) va, sect);
    7cff:	56                   	push   %esi
		va += SECTORSIZE;
    7d00:	81 c6 00 02 00 00    	add    $0x200,%esi
	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);

	// read sectors
	while (va < end_va) {
		readsect((uint8_t*) va, sect);
    7d06:	e8 72 ff ff ff       	call   7c7d <readsect>
		va += SECTORSIZE;
		sect++;
    7d0b:	58                   	pop    %eax
    7d0c:	5a                   	pop    %edx

	// round down to sector boundary
	va &= ~(SECTORSIZE - 1);

	// read sectors
	while (va < end_va) {
    7d0d:	39 de                	cmp    %ebx,%esi
    7d0f:	72 ec                	jb     7cfd <readseg+0x20>
    7d11:	eb 04                	jmp    7d17 <readseg+0x3a>
		sect++;
	}

	// clear bss segment
	while (end_va < memsz)
		*((uint8_t*) end_va++) = 0;
    7d13:	c6 03 00             	movb   $0x0,(%ebx)
    7d16:	43                   	inc    %ebx
		va += SECTORSIZE;
		sect++;
	}

	// clear bss segment
	while (end_va < memsz)
    7d17:	39 eb                	cmp    %ebp,%ebx
    7d19:	72 f8                	jb     7d13 <readseg+0x36>
		*((uint8_t*) end_va++) = 0;
}
    7d1b:	5b                   	pop    %ebx
    7d1c:	5e                   	pop    %esi
    7d1d:	5f                   	pop    %edi
    7d1e:	5d                   	pop    %ebp
    7d1f:	c3                   	ret    

00007d20 <bootmain>:
void readsect(void *addr, uint32_t sect);
void readseg(uint32_t va, uint32_t filesz, uint32_t memsz, uint32_t sect);

void
bootmain(void)
{
    7d20:	56                   	push   %esi
    7d21:	53                   	push   %ebx
	struct Proghdr *ph, *eph;
	uint32_t *stackptr;

	// read 1st page off disk
	readseg((uint32_t) ELFHDR, PAGESIZE, PAGESIZE, 1);
    7d22:	6a 01                	push   $0x1
    7d24:	68 00 10 00 00       	push   $0x1000
    7d29:	68 00 10 00 00       	push   $0x1000
    7d2e:	68 00 00 01 00       	push   $0x10000
    7d33:	e8 a5 ff ff ff       	call   7cdd <readseg>

	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d38:	83 c4 10             	add    $0x10,%esp
    7d3b:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d42:	45 4c 46 
    7d45:	75 45                	jne    7d8c <bootmain+0x6c>
		return;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d47:	8b 1d 1c 00 01 00    	mov    0x1001c,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d4d:	0f b7 05 2c 00 01 00 	movzwl 0x1002c,%eax
	// is this a valid ELF?
	if (ELFHDR->e_magic != ELF_MAGIC)
		return;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d54:	81 c3 00 00 01 00    	add    $0x10000,%ebx
	eph = ph + ELFHDR->e_phnum;
    7d5a:	c1 e0 05             	shl    $0x5,%eax
    7d5d:	8d 34 03             	lea    (%ebx,%eax,1),%esi
	for (; ph < eph; ph++)
    7d60:	eb 1c                	jmp    7d7e <bootmain+0x5e>
		readseg(ph->p_va, ph->p_filesz, ph->p_memsz, 1 + ph->p_offset / SECTORSIZE);
    7d62:	8b 53 04             	mov    0x4(%ebx),%edx
    7d65:	c1 ea 09             	shr    $0x9,%edx
    7d68:	42                   	inc    %edx
    7d69:	52                   	push   %edx
    7d6a:	ff 73 14             	pushl  0x14(%ebx)
    7d6d:	ff 73 10             	pushl  0x10(%ebx)
    7d70:	ff 73 08             	pushl  0x8(%ebx)
		return;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d73:	83 c3 20             	add    $0x20,%ebx
		readseg(ph->p_va, ph->p_filesz, ph->p_memsz, 1 + ph->p_offset / SECTORSIZE);
    7d76:	e8 62 ff ff ff       	call   7cdd <readseg>
		return;

	// load each program segment (ignores ph flags)
	ph = (struct Proghdr*) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
	eph = ph + ELFHDR->e_phnum;
	for (; ph < eph; ph++)
    7d7b:	83 c4 10             	add    $0x10,%esp
    7d7e:	39 f3                	cmp    %esi,%ebx
    7d80:	72 e0                	jb     7d62 <bootmain+0x42>
		readseg(ph->p_va, ph->p_filesz, ph->p_memsz, 1 + ph->p_offset / SECTORSIZE);

	// jump to the kernel, clearing %eax
	__asm __volatile("movl %0, %%esp; ret" : : "r" (&ELFHDR->e_entry), "a" (0));
    7d82:	31 c0                	xor    %eax,%eax
    7d84:	ba 18 00 01 00       	mov    $0x10018,%edx
    7d89:	89 d4                	mov    %edx,%esp
    7d8b:	c3                   	ret    
}
    7d8c:	5b                   	pop    %ebx
    7d8d:	5e                   	pop    %esi
    7d8e:	c3                   	ret    
