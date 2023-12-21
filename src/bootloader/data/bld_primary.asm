%ifndef BLD_PRIMARY
%define BLD_PRIMARY

bld_welcome_msg db " Welcome to PilgrimOS!", 0xa, 0xd, 0
bld_select_msg db " Please press the:", 0xa, 0xd, 0
bld_text_editor_option db " 0 key for a real-mode text editor, or", 0xa, 0xd, 0
bld_kernel_option db " 1 key for the OS kernel.", 0xa, 0xd, 0

%endif