OUTPUT_ARCH(arm)
ENTRY(_start)

SECTIONS{
	. = 0x20000000;
	. = ALIGN(4);
	.text :
	{
		start.o(.text)
		*(.text)
	}
	
	. = ALIGN(4);
	.data :
	{
		*(.data)
	}

	. = ALIGN(4);
	_bss_start = .;
	.bss :
	{
		*(.bss)
	}
	_bss_end = .;
}
