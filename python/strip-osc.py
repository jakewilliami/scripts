# Use case: stripping all ASCI escpae codes (including OSC sequences) from captured
# terminal output.  Helping @Abraham-Alfred with his Honour's project
# https://en.wikipedia.org/wiki/ANSI_escape_code#OSC_(Operating_System_Command)_sequences
# Adapted from https://stackoverflow.com/a/71775190/12069968

import pyte  # terminal emulator: render terminal output to visible characters


def strip_ansi_escape(f_in: str, f_out: str) -> str:
    print(f'parsing {repr(f_in)}...')
    
    pyte_screen = pyte.Screen(80, 24)
    pyte_stream = pyte.ByteStream(pyte_screen)
    with open(f_in, 'rb') as f:
        pyte_stream.feed(f.read())
    
    with open(f_out, 'w') as f:
        for line in pyte_screen.display:
            f.write(line.rstrip() + '\n')
        byte_pos = f.tell()
    
    print(f'bytes written to {repr(f_out)}: {byte_pos}')
    print(f'cursor: {pyte_screen.cursor.y}, {pyte_screen.cursor.x}')
    print(f'title: {pyte_screen.title}')


# Example
bytes_ = b''.join([
    b'$ cowsay hello\r\n', b'\x1b[?2004l', b'\r', b' _______\r\n',
    b'< hello >\r\n', b' -------\r\n', b'        \\   ^__^\r\n',
    b'         \\  (oo)\\_______\r\n', b'            (__)\\       )\\/\\\r\n',
    b'                ||----w |\r\n', b'                ||     ||\r\n',
    b'\x1b]0;user@laptop1:/tmp\x1b\\', b'\x1b]7;file://laptop1/tmp\x1b\\', b'\x1b[?2004h$ ',
])
p = 'random-cowsay-encoded-file-ksdjnfkdjfskdsnjfkjsdsdkfnaldsm.txt'
with open(p, 'wb') as f:
    f.write(bytes_)
strip_ansi_escape(p, 'cowsay-plain.txt')

