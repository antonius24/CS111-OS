
obj/mpos-app2:     file format elf32-i386


Disassembly of section .text:

00200000 <app_printf>:

static void app_printf(const char *format, ...) __attribute__((noinline));

static void
app_printf(const char *format, ...)
{
  200000:	83 ec 0c             	sub    $0xc,%esp
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200003:	cd 30                	int    $0x30
static void
app_printf(const char *format, ...)
{
	// set default color based on currently running process
	int color = sys_getpid();
	if (color < 0)
  200005:	85 c0                	test   %eax,%eax
  200007:	ba 00 07 00 00       	mov    $0x700,%edx
  20000c:	78 13                	js     200021 <app_printf+0x21>
		color = 0x0700;
	else {
		static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
		color = col[color % sizeof(col)] << 8;
  20000e:	b9 05 00 00 00       	mov    $0x5,%ecx
  200013:	31 d2                	xor    %edx,%edx
  200015:	f7 f1                	div    %ecx
  200017:	0f b6 92 c8 05 20 00 	movzbl 0x2005c8(%edx),%edx
  20001e:	c1 e2 08             	shl    $0x8,%edx
	}

	va_list val;
	va_start(val, format);
	cursorpos = console_vprintf(cursorpos, color, format, val);
  200021:	8d 44 24 14          	lea    0x14(%esp),%eax
  200025:	50                   	push   %eax
  200026:	ff 74 24 14          	pushl  0x14(%esp)
  20002a:	52                   	push   %edx
  20002b:	ff 35 00 00 06 00    	pushl  0x60000
  200031:	e8 b5 01 00 00       	call   2001eb <console_vprintf>
  200036:	a3 00 00 06 00       	mov    %eax,0x60000
	va_end(val);
}
  20003b:	83 c4 1c             	add    $0x1c,%esp
  20003e:	c3                   	ret    

0020003f <run_child>:
	sys_exit(0);
}

void
run_child(void)
{
  20003f:	53                   	push   %ebx
  200040:	83 ec 0c             	sub    $0xc,%esp
	int input_counter = counter;
  200043:	8b 1d 00 16 20 00    	mov    0x201600,%ebx

	counter++;		/* Note that all "processes" share an address
  200049:	a1 00 16 20 00       	mov    0x201600,%eax
  20004e:	40                   	inc    %eax
  20004f:	a3 00 16 20 00       	mov    %eax,0x201600
	// That means that after the "asm" instruction (which causes the
	// interrupt), the system call's return value is in the 'pid'
	// variable, and we can just return that value!

	pid_t pid;
	asm volatile("int %1\n"
  200054:	cd 30                	int    $0x30
				   space, so this change to 'counter' will be
				   visible to all processes. */

	app_printf("Process %d lives, counter %d!\n",
  200056:	53                   	push   %ebx
  200057:	50                   	push   %eax
  200058:	68 a8 05 20 00       	push   $0x2005a8
  20005d:	e8 9e ff ff ff       	call   200000 <app_printf>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  200062:	89 d8                	mov    %ebx,%eax
  200064:	cd 33                	int    $0x33
  200066:	83 c4 10             	add    $0x10,%esp
  200069:	eb fe                	jmp    200069 <run_child+0x2a>

0020006b <start>:

void run_child(void);

void
start(void)
{
  20006b:	53                   	push   %ebx
  20006c:	83 ec 08             	sub    $0x8,%esp
	pid_t p;
	int status;

	counter = 0;
  20006f:	c7 05 00 16 20 00 00 	movl   $0x0,0x201600
  200076:	00 00 00 

	while (counter < 1025) {
  200079:	eb 37                	jmp    2000b2 <start+0x47>
sys_fork(void)
{
	// This system call follows the same pattern as sys_getpid().

	pid_t result;
	asm volatile("int %1\n"
  20007b:	cd 31                	int    $0x31

		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < 1025) {
			p = sys_fork();
			if (p == 0)
  20007d:	83 f8 00             	cmp    $0x0,%eax
  200080:	75 07                	jne    200089 <start+0x1e>
				run_child();
  200082:	e8 b8 ff ff ff       	call   20003f <run_child>
  200087:	eb 03                	jmp    20008c <start+0x21>
			else if (p > 0)
  200089:	7e 10                	jle    20009b <start+0x30>
				n_started++;
  20008b:	43                   	inc    %ebx
	while (counter < 1025) {
		int n_started = 0;

		// Start as many processes as possible, until we fail to start
		// a process or we have started 1025 processes total.
		while (counter + n_started < 1025) {
  20008c:	a1 00 16 20 00       	mov    0x201600,%eax
  200091:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  200094:	3d 00 04 00 00       	cmp    $0x400,%eax
  200099:	7e e0                	jle    20007b <start+0x10>
				break;
		}
                //app_printf("Process %d lives, Status_FORK: %d, Start: %d!",
		//sys_getpid(), p, n_started);
		// If we could not start any new processes, give up!
		if (n_started == 0)
  20009b:	85 db                	test   %ebx,%ebx
  20009d:	74 23                	je     2000c2 <start+0x57>
  20009f:	ba 02 00 00 00       	mov    $0x2,%edx

static inline int
sys_wait(pid_t pid)
{
	int retval;
	asm volatile("int %1\n"
  2000a4:	89 d0                	mov    %edx,%eax
  2000a6:	cd 34                	int    $0x34
  2000a8:	89 d0                	mov    %edx,%eax
  2000aa:	cd 34                	int    $0x34
		// any more.
		// That means we ran out of room to start processes.
		// Retrieve old processes' exit status with sys_wait(),
		// to make room for new processes.

		for (p = 2; p < NPROCS; p++)
  2000ac:	42                   	inc    %edx
  2000ad:	83 fa 10             	cmp    $0x10,%edx
  2000b0:	75 f2                	jne    2000a4 <start+0x39>
	pid_t p;
	int status;

	counter = 0;

	while (counter < 1025) {
  2000b2:	a1 00 16 20 00       	mov    0x201600,%eax
  2000b7:	3d 00 04 00 00       	cmp    $0x400,%eax
  2000bc:	7f 04                	jg     2000c2 <start+0x57>
  2000be:	31 db                	xor    %ebx,%ebx
  2000c0:	eb ca                	jmp    20008c <start+0x21>
	// the 'int' instruction.
	// You can load other registers with similar syntax; specifically:
	//	"a" = %eax, "b" = %ebx, "c" = %ecx, "d" = %edx,
	//	"S" = %esi, "D" = %edi.

	asm volatile("int %0\n"
  2000c2:	31 c0                	xor    %eax,%eax
  2000c4:	cd 33                	int    $0x33
  2000c6:	eb fe                	jmp    2000c6 <start+0x5b>

002000c8 <memcpy>:
 *
 *   We must provide our own implementations of these basic functions. */

void *
memcpy(void *dst, const void *src, size_t n)
{
  2000c8:	56                   	push   %esi
  2000c9:	31 d2                	xor    %edx,%edx
  2000cb:	53                   	push   %ebx
  2000cc:	8b 44 24 0c          	mov    0xc(%esp),%eax
  2000d0:	8b 5c 24 10          	mov    0x10(%esp),%ebx
  2000d4:	8b 74 24 14          	mov    0x14(%esp),%esi
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  2000d8:	eb 08                	jmp    2000e2 <memcpy+0x1a>
		*d++ = *s++;
  2000da:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
  2000dd:	4e                   	dec    %esi
  2000de:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  2000e1:	42                   	inc    %edx
void *
memcpy(void *dst, const void *src, size_t n)
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	while (n-- > 0)
  2000e2:	85 f6                	test   %esi,%esi
  2000e4:	75 f4                	jne    2000da <memcpy+0x12>
		*d++ = *s++;
	return dst;
}
  2000e6:	5b                   	pop    %ebx
  2000e7:	5e                   	pop    %esi
  2000e8:	c3                   	ret    

002000e9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  2000e9:	57                   	push   %edi
  2000ea:	56                   	push   %esi
  2000eb:	53                   	push   %ebx
  2000ec:	8b 44 24 10          	mov    0x10(%esp),%eax
  2000f0:	8b 7c 24 14          	mov    0x14(%esp),%edi
  2000f4:	8b 54 24 18          	mov    0x18(%esp),%edx
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
  2000f8:	39 c7                	cmp    %eax,%edi
  2000fa:	73 26                	jae    200122 <memmove+0x39>
  2000fc:	8d 34 17             	lea    (%edi,%edx,1),%esi
  2000ff:	39 c6                	cmp    %eax,%esi
  200101:	76 1f                	jbe    200122 <memmove+0x39>
		s += n, d += n;
  200103:	8d 3c 10             	lea    (%eax,%edx,1),%edi
  200106:	31 c9                	xor    %ecx,%ecx
		while (n-- > 0)
  200108:	eb 07                	jmp    200111 <memmove+0x28>
			*--d = *--s;
  20010a:	8a 1c 0e             	mov    (%esi,%ecx,1),%bl
  20010d:	4a                   	dec    %edx
  20010e:	88 1c 0f             	mov    %bl,(%edi,%ecx,1)
  200111:	49                   	dec    %ecx
{
	const char *s = (const char *) src;
	char *d = (char *) dst;
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
  200112:	85 d2                	test   %edx,%edx
  200114:	75 f4                	jne    20010a <memmove+0x21>
  200116:	eb 10                	jmp    200128 <memmove+0x3f>
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  200118:	8a 1c 0f             	mov    (%edi,%ecx,1),%bl
  20011b:	4a                   	dec    %edx
  20011c:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
  20011f:	41                   	inc    %ecx
  200120:	eb 02                	jmp    200124 <memmove+0x3b>
  200122:	31 c9                	xor    %ecx,%ecx
	if (s < d && s + n > d) {
		s += n, d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  200124:	85 d2                	test   %edx,%edx
  200126:	75 f0                	jne    200118 <memmove+0x2f>
			*d++ = *s++;
	return dst;
}
  200128:	5b                   	pop    %ebx
  200129:	5e                   	pop    %esi
  20012a:	5f                   	pop    %edi
  20012b:	c3                   	ret    

0020012c <memset>:

void *
memset(void *v, int c, size_t n)
{
  20012c:	53                   	push   %ebx
  20012d:	8b 44 24 08          	mov    0x8(%esp),%eax
  200131:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  200135:	8b 4c 24 10          	mov    0x10(%esp),%ecx
	char *p = (char *) v;
  200139:	89 c2                	mov    %eax,%edx
	while (n-- > 0)
  20013b:	eb 04                	jmp    200141 <memset+0x15>
		*p++ = c;
  20013d:	88 1a                	mov    %bl,(%edx)
  20013f:	49                   	dec    %ecx
  200140:	42                   	inc    %edx

void *
memset(void *v, int c, size_t n)
{
	char *p = (char *) v;
	while (n-- > 0)
  200141:	85 c9                	test   %ecx,%ecx
  200143:	75 f8                	jne    20013d <memset+0x11>
		*p++ = c;
	return v;
}
  200145:	5b                   	pop    %ebx
  200146:	c3                   	ret    

00200147 <strlen>:

size_t
strlen(const char *s)
{
  200147:	8b 54 24 04          	mov    0x4(%esp),%edx
  20014b:	31 c0                	xor    %eax,%eax
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20014d:	eb 01                	jmp    200150 <strlen+0x9>
		++n;
  20014f:	40                   	inc    %eax

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  200150:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  200154:	75 f9                	jne    20014f <strlen+0x8>
		++n;
	return n;
}
  200156:	c3                   	ret    

00200157 <strnlen>:

size_t
strnlen(const char *s, size_t maxlen)
{
  200157:	8b 4c 24 04          	mov    0x4(%esp),%ecx
  20015b:	31 c0                	xor    %eax,%eax
  20015d:	8b 54 24 08          	mov    0x8(%esp),%edx
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  200161:	eb 01                	jmp    200164 <strnlen+0xd>
		++n;
  200163:	40                   	inc    %eax

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  200164:	39 d0                	cmp    %edx,%eax
  200166:	74 06                	je     20016e <strnlen+0x17>
  200168:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  20016c:	75 f5                	jne    200163 <strnlen+0xc>
		++n;
	return n;
}
  20016e:	c3                   	ret    

0020016f <console_putc>:
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  20016f:	56                   	push   %esi
	if (cursor >= CONSOLE_END)
  200170:	3d 9f 8f 0b 00       	cmp    $0xb8f9f,%eax
 *
 *   Print a message onto the console, starting at the given cursor position. */

static uint16_t *
console_putc(uint16_t *cursor, unsigned char c, int color)
{
  200175:	53                   	push   %ebx
  200176:	89 c3                	mov    %eax,%ebx
	if (cursor >= CONSOLE_END)
  200178:	76 05                	jbe    20017f <console_putc+0x10>
  20017a:	bb 00 80 0b 00       	mov    $0xb8000,%ebx
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
  20017f:	80 fa 0a             	cmp    $0xa,%dl
  200182:	75 2c                	jne    2001b0 <console_putc+0x41>
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  200184:	8d 83 00 80 f4 ff    	lea    -0xb8000(%ebx),%eax
  20018a:	be 50 00 00 00       	mov    $0x50,%esi
  20018f:	d1 f8                	sar    %eax
		for (; pos != 80; pos++)
			*cursor++ = ' ' | color;
  200191:	83 c9 20             	or     $0x20,%ecx
console_putc(uint16_t *cursor, unsigned char c, int color)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
  200194:	99                   	cltd   
  200195:	f7 fe                	idiv   %esi
  200197:	89 de                	mov    %ebx,%esi
  200199:	89 d0                	mov    %edx,%eax
		for (; pos != 80; pos++)
  20019b:	eb 07                	jmp    2001a4 <console_putc+0x35>
			*cursor++ = ' ' | color;
  20019d:	66 89 0e             	mov    %cx,(%esi)
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  2001a0:	40                   	inc    %eax
			*cursor++ = ' ' | color;
  2001a1:	83 c6 02             	add    $0x2,%esi
{
	if (cursor >= CONSOLE_END)
		cursor = CONSOLE_BEGIN;
	if (c == '\n') {
		int pos = (cursor - CONSOLE_BEGIN) % 80;
		for (; pos != 80; pos++)
  2001a4:	83 f8 50             	cmp    $0x50,%eax
  2001a7:	75 f4                	jne    20019d <console_putc+0x2e>
  2001a9:	29 d0                	sub    %edx,%eax
  2001ab:	8d 04 43             	lea    (%ebx,%eax,2),%eax
  2001ae:	eb 0b                	jmp    2001bb <console_putc+0x4c>
			*cursor++ = ' ' | color;
	} else
		*cursor++ = c | color;
  2001b0:	0f b6 d2             	movzbl %dl,%edx
  2001b3:	09 ca                	or     %ecx,%edx
  2001b5:	66 89 13             	mov    %dx,(%ebx)
  2001b8:	8d 43 02             	lea    0x2(%ebx),%eax
	return cursor;
}
  2001bb:	5b                   	pop    %ebx
  2001bc:	5e                   	pop    %esi
  2001bd:	c3                   	ret    

002001be <fill_numbuf>:
static const char lower_digits[] = "0123456789abcdef";

static char *
fill_numbuf(char *numbuf_end, uint32_t val, int base, const char *digits,
	    int precision)
{
  2001be:	56                   	push   %esi
  2001bf:	53                   	push   %ebx
  2001c0:	8b 74 24 0c          	mov    0xc(%esp),%esi
	*--numbuf_end = '\0';
  2001c4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  2001c7:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
	if (precision != 0 || val != 0)
  2001cb:	83 7c 24 10 00       	cmpl   $0x0,0x10(%esp)
  2001d0:	75 04                	jne    2001d6 <fill_numbuf+0x18>
  2001d2:	85 d2                	test   %edx,%edx
  2001d4:	74 10                	je     2001e6 <fill_numbuf+0x28>
		do {
			*--numbuf_end = digits[val % base];
  2001d6:	89 d0                	mov    %edx,%eax
  2001d8:	31 d2                	xor    %edx,%edx
  2001da:	f7 f1                	div    %ecx
  2001dc:	4b                   	dec    %ebx
  2001dd:	8a 14 16             	mov    (%esi,%edx,1),%dl
  2001e0:	88 13                	mov    %dl,(%ebx)
			val /= base;
  2001e2:	89 c2                	mov    %eax,%edx
  2001e4:	eb ec                	jmp    2001d2 <fill_numbuf+0x14>
		} while (val != 0);
	return numbuf_end;
}
  2001e6:	89 d8                	mov    %ebx,%eax
  2001e8:	5b                   	pop    %ebx
  2001e9:	5e                   	pop    %esi
  2001ea:	c3                   	ret    

002001eb <console_vprintf>:
#define FLAG_PLUSPOSITIVE	(1<<4)
static const char flag_chars[] = "#0- +";

uint16_t *
console_vprintf(uint16_t *cursor, int color, const char *format, va_list val)
{
  2001eb:	55                   	push   %ebp
  2001ec:	57                   	push   %edi
  2001ed:	56                   	push   %esi
  2001ee:	53                   	push   %ebx
  2001ef:	83 ec 38             	sub    $0x38,%esp
  2001f2:	8b 74 24 4c          	mov    0x4c(%esp),%esi
  2001f6:	8b 7c 24 54          	mov    0x54(%esp),%edi
  2001fa:	8b 5c 24 58          	mov    0x58(%esp),%ebx
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  2001fe:	e9 60 03 00 00       	jmp    200563 <console_vprintf+0x378>
		if (*format != '%') {
  200203:	80 fa 25             	cmp    $0x25,%dl
  200206:	74 13                	je     20021b <console_vprintf+0x30>
			cursor = console_putc(cursor, *format, color);
  200208:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  20020c:	0f b6 d2             	movzbl %dl,%edx
  20020f:	89 f0                	mov    %esi,%eax
  200211:	e8 59 ff ff ff       	call   20016f <console_putc>
  200216:	e9 45 03 00 00       	jmp    200560 <console_vprintf+0x375>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  20021b:	47                   	inc    %edi
  20021c:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
  200223:	00 
  200224:	eb 12                	jmp    200238 <console_vprintf+0x4d>
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
  200226:	41                   	inc    %ecx

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
  200227:	8a 11                	mov    (%ecx),%dl
  200229:	84 d2                	test   %dl,%dl
  20022b:	74 1a                	je     200247 <console_vprintf+0x5c>
  20022d:	89 e8                	mov    %ebp,%eax
  20022f:	38 c2                	cmp    %al,%dl
  200231:	75 f3                	jne    200226 <console_vprintf+0x3b>
  200233:	e9 3f 03 00 00       	jmp    200577 <console_vprintf+0x38c>
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200238:	8a 17                	mov    (%edi),%dl
  20023a:	84 d2                	test   %dl,%dl
  20023c:	74 0b                	je     200249 <console_vprintf+0x5e>
  20023e:	b9 d0 05 20 00       	mov    $0x2005d0,%ecx
  200243:	89 d5                	mov    %edx,%ebp
  200245:	eb e0                	jmp    200227 <console_vprintf+0x3c>
  200247:	89 ea                	mov    %ebp,%edx
			flags |= (1 << (flagc - flag_chars));
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
  200249:	8d 42 cf             	lea    -0x31(%edx),%eax
  20024c:	3c 08                	cmp    $0x8,%al
  20024e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  200255:	00 
  200256:	76 13                	jbe    20026b <console_vprintf+0x80>
  200258:	eb 1d                	jmp    200277 <console_vprintf+0x8c>
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
  20025a:	6b 54 24 0c 0a       	imul   $0xa,0xc(%esp),%edx
  20025f:	0f be c0             	movsbl %al,%eax
  200262:	47                   	inc    %edi
  200263:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
  200267:	89 44 24 0c          	mov    %eax,0xc(%esp)
		}

		// process width
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
  20026b:	8a 07                	mov    (%edi),%al
  20026d:	8d 50 d0             	lea    -0x30(%eax),%edx
  200270:	80 fa 09             	cmp    $0x9,%dl
  200273:	76 e5                	jbe    20025a <console_vprintf+0x6f>
  200275:	eb 18                	jmp    20028f <console_vprintf+0xa4>
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
  200277:	80 fa 2a             	cmp    $0x2a,%dl
  20027a:	c7 44 24 0c ff ff ff 	movl   $0xffffffff,0xc(%esp)
  200281:	ff 
  200282:	75 0b                	jne    20028f <console_vprintf+0xa4>
			width = va_arg(val, int);
  200284:	83 c3 04             	add    $0x4,%ebx
			++format;
  200287:	47                   	inc    %edi
		width = -1;
		if (*format >= '1' && *format <= '9') {
			for (width = 0; *format >= '0' && *format <= '9'; )
				width = 10 * width + *format++ - '0';
		} else if (*format == '*') {
			width = va_arg(val, int);
  200288:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20028b:	89 54 24 0c          	mov    %edx,0xc(%esp)
			++format;
		}

		// process precision
		precision = -1;
		if (*format == '.') {
  20028f:	83 cd ff             	or     $0xffffffff,%ebp
  200292:	80 3f 2e             	cmpb   $0x2e,(%edi)
  200295:	75 37                	jne    2002ce <console_vprintf+0xe3>
			++format;
  200297:	47                   	inc    %edi
			if (*format >= '0' && *format <= '9') {
  200298:	31 ed                	xor    %ebp,%ebp
  20029a:	8a 07                	mov    (%edi),%al
  20029c:	8d 50 d0             	lea    -0x30(%eax),%edx
  20029f:	80 fa 09             	cmp    $0x9,%dl
  2002a2:	76 0d                	jbe    2002b1 <console_vprintf+0xc6>
  2002a4:	eb 17                	jmp    2002bd <console_vprintf+0xd2>
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
  2002a6:	6b ed 0a             	imul   $0xa,%ebp,%ebp
  2002a9:	0f be c0             	movsbl %al,%eax
  2002ac:	47                   	inc    %edi
  2002ad:	8d 6c 05 d0          	lea    -0x30(%ebp,%eax,1),%ebp
		// process precision
		precision = -1;
		if (*format == '.') {
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
  2002b1:	8a 07                	mov    (%edi),%al
  2002b3:	8d 50 d0             	lea    -0x30(%eax),%edx
  2002b6:	80 fa 09             	cmp    $0x9,%dl
  2002b9:	76 eb                	jbe    2002a6 <console_vprintf+0xbb>
  2002bb:	eb 11                	jmp    2002ce <console_vprintf+0xe3>
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
  2002bd:	3c 2a                	cmp    $0x2a,%al
  2002bf:	75 0b                	jne    2002cc <console_vprintf+0xe1>
				precision = va_arg(val, int);
  2002c1:	83 c3 04             	add    $0x4,%ebx
				++format;
  2002c4:	47                   	inc    %edi
			++format;
			if (*format >= '0' && *format <= '9') {
				for (precision = 0; *format >= '0' && *format <= '9'; )
					precision = 10 * precision + *format++ - '0';
			} else if (*format == '*') {
				precision = va_arg(val, int);
  2002c5:	8b 6b fc             	mov    -0x4(%ebx),%ebp
				++format;
			}
			if (precision < 0)
  2002c8:	85 ed                	test   %ebp,%ebp
  2002ca:	79 02                	jns    2002ce <console_vprintf+0xe3>
  2002cc:	31 ed                	xor    %ebp,%ebp
		}

		// process main conversion character
		negative = 0;
		numeric = 0;
		switch (*format) {
  2002ce:	8a 07                	mov    (%edi),%al
  2002d0:	3c 64                	cmp    $0x64,%al
  2002d2:	74 34                	je     200308 <console_vprintf+0x11d>
  2002d4:	7f 1d                	jg     2002f3 <console_vprintf+0x108>
  2002d6:	3c 58                	cmp    $0x58,%al
  2002d8:	0f 84 a2 00 00 00    	je     200380 <console_vprintf+0x195>
  2002de:	3c 63                	cmp    $0x63,%al
  2002e0:	0f 84 bf 00 00 00    	je     2003a5 <console_vprintf+0x1ba>
  2002e6:	3c 43                	cmp    $0x43,%al
  2002e8:	0f 85 d0 00 00 00    	jne    2003be <console_vprintf+0x1d3>
  2002ee:	e9 a3 00 00 00       	jmp    200396 <console_vprintf+0x1ab>
  2002f3:	3c 75                	cmp    $0x75,%al
  2002f5:	74 4d                	je     200344 <console_vprintf+0x159>
  2002f7:	3c 78                	cmp    $0x78,%al
  2002f9:	74 5c                	je     200357 <console_vprintf+0x16c>
  2002fb:	3c 73                	cmp    $0x73,%al
  2002fd:	0f 85 bb 00 00 00    	jne    2003be <console_vprintf+0x1d3>
  200303:	e9 86 00 00 00       	jmp    20038e <console_vprintf+0x1a3>
		case 'd': {
			int x = va_arg(val, int);
  200308:	83 c3 04             	add    $0x4,%ebx
  20030b:	8b 53 fc             	mov    -0x4(%ebx),%edx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x > 0 ? x : -x, 10, upper_digits, precision);
  20030e:	89 d1                	mov    %edx,%ecx
  200310:	c1 f9 1f             	sar    $0x1f,%ecx
  200313:	89 0c 24             	mov    %ecx,(%esp)
  200316:	31 ca                	xor    %ecx,%edx
  200318:	55                   	push   %ebp
  200319:	29 ca                	sub    %ecx,%edx
  20031b:	68 d8 05 20 00       	push   $0x2005d8
  200320:	b9 0a 00 00 00       	mov    $0xa,%ecx
  200325:	8d 44 24 40          	lea    0x40(%esp),%eax
  200329:	e8 90 fe ff ff       	call   2001be <fill_numbuf>
  20032e:	89 44 24 0c          	mov    %eax,0xc(%esp)
			if (x < 0)
  200332:	58                   	pop    %eax
  200333:	5a                   	pop    %edx
  200334:	ba 01 00 00 00       	mov    $0x1,%edx
  200339:	8b 04 24             	mov    (%esp),%eax
  20033c:	83 e0 01             	and    $0x1,%eax
  20033f:	e9 a5 00 00 00       	jmp    2003e9 <console_vprintf+0x1fe>
				negative = 1;
			numeric = 1;
			break;
		}
		case 'u': {
			unsigned x = va_arg(val, unsigned);
  200344:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 10, upper_digits, precision);
  200347:	b9 0a 00 00 00       	mov    $0xa,%ecx
  20034c:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20034f:	55                   	push   %ebp
  200350:	68 d8 05 20 00       	push   $0x2005d8
  200355:	eb 11                	jmp    200368 <console_vprintf+0x17d>
			numeric = 1;
			break;
		}
		case 'x': {
			unsigned x = va_arg(val, unsigned);
  200357:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, lower_digits, precision);
  20035a:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20035d:	55                   	push   %ebp
  20035e:	68 ec 05 20 00       	push   $0x2005ec
  200363:	b9 10 00 00 00       	mov    $0x10,%ecx
  200368:	8d 44 24 40          	lea    0x40(%esp),%eax
  20036c:	e8 4d fe ff ff       	call   2001be <fill_numbuf>
  200371:	ba 01 00 00 00       	mov    $0x1,%edx
  200376:	89 44 24 0c          	mov    %eax,0xc(%esp)
  20037a:	31 c0                	xor    %eax,%eax
			numeric = 1;
			break;
  20037c:	59                   	pop    %ecx
  20037d:	59                   	pop    %ecx
  20037e:	eb 69                	jmp    2003e9 <console_vprintf+0x1fe>
		}
		case 'X': {
			unsigned x = va_arg(val, unsigned);
  200380:	83 c3 04             	add    $0x4,%ebx
			data = fill_numbuf(numbuf + NUMBUFSIZ, x, 16, upper_digits, precision);
  200383:	8b 53 fc             	mov    -0x4(%ebx),%edx
  200386:	55                   	push   %ebp
  200387:	68 d8 05 20 00       	push   $0x2005d8
  20038c:	eb d5                	jmp    200363 <console_vprintf+0x178>
			numeric = 1;
			break;
		}
		case 's':
			data = va_arg(val, char *);
  20038e:	83 c3 04             	add    $0x4,%ebx
  200391:	8b 43 fc             	mov    -0x4(%ebx),%eax
  200394:	eb 40                	jmp    2003d6 <console_vprintf+0x1eb>
			break;
		case 'C':
			color = va_arg(val, int);
  200396:	83 c3 04             	add    $0x4,%ebx
  200399:	8b 53 fc             	mov    -0x4(%ebx),%edx
  20039c:	89 54 24 50          	mov    %edx,0x50(%esp)
			goto done;
  2003a0:	e9 bd 01 00 00       	jmp    200562 <console_vprintf+0x377>
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003a5:	83 c3 04             	add    $0x4,%ebx
  2003a8:	8b 43 fc             	mov    -0x4(%ebx),%eax
			numbuf[1] = '\0';
  2003ab:	8d 4c 24 24          	lea    0x24(%esp),%ecx
  2003af:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
  2003b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
		case 'C':
			color = va_arg(val, int);
			goto done;
		case 'c':
			data = numbuf;
			numbuf[0] = va_arg(val, int);
  2003b8:	88 44 24 24          	mov    %al,0x24(%esp)
  2003bc:	eb 27                	jmp    2003e5 <console_vprintf+0x1fa>
			numbuf[1] = '\0';
			break;
		normal:
		default:
			data = numbuf;
			numbuf[0] = (*format ? *format : '%');
  2003be:	84 c0                	test   %al,%al
  2003c0:	75 02                	jne    2003c4 <console_vprintf+0x1d9>
  2003c2:	b0 25                	mov    $0x25,%al
  2003c4:	88 44 24 24          	mov    %al,0x24(%esp)
			numbuf[1] = '\0';
  2003c8:	c6 44 24 25 00       	movb   $0x0,0x25(%esp)
			if (!*format)
  2003cd:	80 3f 00             	cmpb   $0x0,(%edi)
  2003d0:	74 0a                	je     2003dc <console_vprintf+0x1f1>
  2003d2:	8d 44 24 24          	lea    0x24(%esp),%eax
  2003d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  2003da:	eb 09                	jmp    2003e5 <console_vprintf+0x1fa>
				format--;
  2003dc:	8d 54 24 24          	lea    0x24(%esp),%edx
  2003e0:	4f                   	dec    %edi
  2003e1:	89 54 24 04          	mov    %edx,0x4(%esp)
  2003e5:	31 d2                	xor    %edx,%edx
  2003e7:	31 c0                	xor    %eax,%eax
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  2003e9:	31 c9                	xor    %ecx,%ecx
			if (!*format)
				format--;
			break;
		}

		if (precision >= 0)
  2003eb:	83 fd ff             	cmp    $0xffffffff,%ebp
  2003ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  2003f5:	74 1f                	je     200416 <console_vprintf+0x22b>
  2003f7:	89 04 24             	mov    %eax,(%esp)
  2003fa:	eb 01                	jmp    2003fd <console_vprintf+0x212>
size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
		++n;
  2003fc:	41                   	inc    %ecx

size_t
strnlen(const char *s, size_t maxlen)
{
	size_t n;
	for (n = 0; n != maxlen && *s != '\0'; ++s)
  2003fd:	39 e9                	cmp    %ebp,%ecx
  2003ff:	74 0a                	je     20040b <console_vprintf+0x220>
  200401:	8b 44 24 04          	mov    0x4(%esp),%eax
  200405:	80 3c 08 00          	cmpb   $0x0,(%eax,%ecx,1)
  200409:	75 f1                	jne    2003fc <console_vprintf+0x211>
  20040b:	8b 04 24             	mov    (%esp),%eax
				format--;
			break;
		}

		if (precision >= 0)
			len = strnlen(data, precision);
  20040e:	89 0c 24             	mov    %ecx,(%esp)
  200411:	eb 1f                	jmp    200432 <console_vprintf+0x247>
size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
		++n;
  200413:	42                   	inc    %edx
  200414:	eb 09                	jmp    20041f <console_vprintf+0x234>
  200416:	89 d1                	mov    %edx,%ecx
  200418:	8b 14 24             	mov    (%esp),%edx
  20041b:	89 44 24 08          	mov    %eax,0x8(%esp)

size_t
strlen(const char *s)
{
	size_t n;
	for (n = 0; *s != '\0'; ++s)
  20041f:	8b 44 24 04          	mov    0x4(%esp),%eax
  200423:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
  200427:	75 ea                	jne    200413 <console_vprintf+0x228>
  200429:	8b 44 24 08          	mov    0x8(%esp),%eax
  20042d:	89 14 24             	mov    %edx,(%esp)
  200430:	89 ca                	mov    %ecx,%edx

		if (precision >= 0)
			len = strnlen(data, precision);
		else
			len = strlen(data);
		if (numeric && negative)
  200432:	85 c0                	test   %eax,%eax
  200434:	74 0c                	je     200442 <console_vprintf+0x257>
  200436:	84 d2                	test   %dl,%dl
  200438:	c7 44 24 08 2d 00 00 	movl   $0x2d,0x8(%esp)
  20043f:	00 
  200440:	75 24                	jne    200466 <console_vprintf+0x27b>
			negative = '-';
		else if (flags & FLAG_PLUSPOSITIVE)
  200442:	f6 44 24 14 10       	testb  $0x10,0x14(%esp)
  200447:	c7 44 24 08 2b 00 00 	movl   $0x2b,0x8(%esp)
  20044e:	00 
  20044f:	75 15                	jne    200466 <console_vprintf+0x27b>
			negative = '+';
		else if (flags & FLAG_SPACEPOSITIVE)
  200451:	8b 44 24 14          	mov    0x14(%esp),%eax
  200455:	83 e0 08             	and    $0x8,%eax
  200458:	83 f8 01             	cmp    $0x1,%eax
  20045b:	19 c9                	sbb    %ecx,%ecx
  20045d:	f7 d1                	not    %ecx
  20045f:	83 e1 20             	and    $0x20,%ecx
  200462:	89 4c 24 08          	mov    %ecx,0x8(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
  200466:	3b 2c 24             	cmp    (%esp),%ebp
  200469:	7e 0d                	jle    200478 <console_vprintf+0x28d>
  20046b:	84 d2                	test   %dl,%dl
  20046d:	74 40                	je     2004af <console_vprintf+0x2c4>
			zeros = precision - len;
  20046f:	2b 2c 24             	sub    (%esp),%ebp
  200472:	89 6c 24 10          	mov    %ebp,0x10(%esp)
  200476:	eb 3f                	jmp    2004b7 <console_vprintf+0x2cc>
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200478:	84 d2                	test   %dl,%dl
  20047a:	74 33                	je     2004af <console_vprintf+0x2c4>
  20047c:	8b 44 24 14          	mov    0x14(%esp),%eax
  200480:	83 e0 06             	and    $0x6,%eax
  200483:	83 f8 02             	cmp    $0x2,%eax
  200486:	75 27                	jne    2004af <console_vprintf+0x2c4>
  200488:	45                   	inc    %ebp
  200489:	75 24                	jne    2004af <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
  20048b:	31 c0                	xor    %eax,%eax
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  20048d:	8b 0c 24             	mov    (%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
  200490:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  200495:	0f 95 c0             	setne  %al
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  200498:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  20049b:	3b 54 24 0c          	cmp    0xc(%esp),%edx
  20049f:	7d 0e                	jge    2004af <console_vprintf+0x2c4>
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
  2004a1:	8b 54 24 0c          	mov    0xc(%esp),%edx
  2004a5:	29 ca                	sub    %ecx,%edx
  2004a7:	29 c2                	sub    %eax,%edx
  2004a9:	89 54 24 10          	mov    %edx,0x10(%esp)
			negative = ' ';
		else
			negative = 0;
		if (numeric && precision > len)
			zeros = precision - len;
		else if ((flags & (FLAG_ZERO | FLAG_LEFTJUSTIFY)) == FLAG_ZERO
  2004ad:	eb 08                	jmp    2004b7 <console_vprintf+0x2cc>
  2004af:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  2004b6:	00 
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004b7:	8b 6c 24 0c          	mov    0xc(%esp),%ebp
  2004bb:	31 c0                	xor    %eax,%eax
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004bd:	8b 4c 24 14          	mov    0x14(%esp),%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004c1:	2b 2c 24             	sub    (%esp),%ebp
  2004c4:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  2004c9:	0f 95 c0             	setne  %al
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004cc:	83 e1 04             	and    $0x4,%ecx
			 && numeric && precision < 0
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
  2004cf:	29 c5                	sub    %eax,%ebp
  2004d1:	89 f0                	mov    %esi,%eax
  2004d3:	2b 6c 24 10          	sub    0x10(%esp),%ebp
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  2004db:	eb 0f                	jmp    2004ec <console_vprintf+0x301>
			cursor = console_putc(cursor, ' ', color);
  2004dd:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  2004e1:	ba 20 00 00 00       	mov    $0x20,%edx
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004e6:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  2004e7:	e8 83 fc ff ff       	call   20016f <console_putc>
			 && len + !!negative < width)
			zeros = width - len - !!negative;
		else
			zeros = 0;
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
  2004ec:	85 ed                	test   %ebp,%ebp
  2004ee:	7e 07                	jle    2004f7 <console_vprintf+0x30c>
  2004f0:	83 7c 24 0c 00       	cmpl   $0x0,0xc(%esp)
  2004f5:	74 e6                	je     2004dd <console_vprintf+0x2f2>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
  2004f7:	83 7c 24 08 00       	cmpl   $0x0,0x8(%esp)
  2004fc:	89 c6                	mov    %eax,%esi
  2004fe:	74 23                	je     200523 <console_vprintf+0x338>
			cursor = console_putc(cursor, negative, color);
  200500:	0f b6 54 24 08       	movzbl 0x8(%esp),%edx
  200505:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200509:	e8 61 fc ff ff       	call   20016f <console_putc>
  20050e:	89 c6                	mov    %eax,%esi
  200510:	eb 11                	jmp    200523 <console_vprintf+0x338>
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
  200512:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200516:	ba 30 00 00 00       	mov    $0x30,%edx
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  20051b:	4e                   	dec    %esi
			cursor = console_putc(cursor, '0', color);
  20051c:	e8 4e fc ff ff       	call   20016f <console_putc>
  200521:	eb 06                	jmp    200529 <console_vprintf+0x33e>
  200523:	89 f0                	mov    %esi,%eax
  200525:	8b 74 24 10          	mov    0x10(%esp),%esi
		width -= len + zeros + !!negative;
		for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
  200529:	85 f6                	test   %esi,%esi
  20052b:	7f e5                	jg     200512 <console_vprintf+0x327>
  20052d:	8b 34 24             	mov    (%esp),%esi
  200530:	eb 15                	jmp    200547 <console_vprintf+0x35c>
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
  200532:	8b 4c 24 04          	mov    0x4(%esp),%ecx
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200536:	4e                   	dec    %esi
			cursor = console_putc(cursor, *data, color);
  200537:	0f b6 11             	movzbl (%ecx),%edx
  20053a:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  20053e:	e8 2c fc ff ff       	call   20016f <console_putc>
			cursor = console_putc(cursor, ' ', color);
		if (negative)
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
  200543:	ff 44 24 04          	incl   0x4(%esp)
  200547:	85 f6                	test   %esi,%esi
  200549:	7f e7                	jg     200532 <console_vprintf+0x347>
  20054b:	eb 0f                	jmp    20055c <console_vprintf+0x371>
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
			cursor = console_putc(cursor, ' ', color);
  20054d:	8b 4c 24 50          	mov    0x50(%esp),%ecx
  200551:	ba 20 00 00 00       	mov    $0x20,%edx
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  200556:	4d                   	dec    %ebp
			cursor = console_putc(cursor, ' ', color);
  200557:	e8 13 fc ff ff       	call   20016f <console_putc>
			cursor = console_putc(cursor, negative, color);
		for (; zeros > 0; --zeros)
			cursor = console_putc(cursor, '0', color);
		for (; len > 0; ++data, --len)
			cursor = console_putc(cursor, *data, color);
		for (; width > 0; --width)
  20055c:	85 ed                	test   %ebp,%ebp
  20055e:	7f ed                	jg     20054d <console_vprintf+0x362>
  200560:	89 c6                	mov    %eax,%esi
	int flags, width, zeros, precision, negative, numeric, len;
#define NUMBUFSIZ 20
	char numbuf[NUMBUFSIZ];
	char *data;

	for (; *format; ++format) {
  200562:	47                   	inc    %edi
  200563:	8a 17                	mov    (%edi),%dl
  200565:	84 d2                	test   %dl,%dl
  200567:	0f 85 96 fc ff ff    	jne    200203 <console_vprintf+0x18>
			cursor = console_putc(cursor, ' ', color);
	done: ;
	}

	return cursor;
}
  20056d:	83 c4 38             	add    $0x38,%esp
  200570:	89 f0                	mov    %esi,%eax
  200572:	5b                   	pop    %ebx
  200573:	5e                   	pop    %esi
  200574:	5f                   	pop    %edi
  200575:	5d                   	pop    %ebp
  200576:	c3                   	ret    
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  200577:	81 e9 d0 05 20 00    	sub    $0x2005d0,%ecx
  20057d:	b8 01 00 00 00       	mov    $0x1,%eax
  200582:	d3 e0                	shl    %cl,%eax
			continue;
		}

		// process flags
		flags = 0;
		for (++format; *format; ++format) {
  200584:	47                   	inc    %edi
			const char *flagc = flag_chars;
			while (*flagc != '\0' && *flagc != *format)
				++flagc;
			if (*flagc == '\0')
				break;
			flags |= (1 << (flagc - flag_chars));
  200585:	09 44 24 14          	or     %eax,0x14(%esp)
  200589:	e9 aa fc ff ff       	jmp    200238 <console_vprintf+0x4d>

0020058e <console_printf>:
uint16_t *
console_printf(uint16_t *cursor, int color, const char *format, ...)
{
	va_list val;
	va_start(val, format);
	cursor = console_vprintf(cursor, color, format, val);
  20058e:	8d 44 24 10          	lea    0x10(%esp),%eax
  200592:	50                   	push   %eax
  200593:	ff 74 24 10          	pushl  0x10(%esp)
  200597:	ff 74 24 10          	pushl  0x10(%esp)
  20059b:	ff 74 24 10          	pushl  0x10(%esp)
  20059f:	e8 47 fc ff ff       	call   2001eb <console_vprintf>
  2005a4:	83 c4 10             	add    $0x10,%esp
	va_end(val);
	return cursor;
}
  2005a7:	c3                   	ret    
