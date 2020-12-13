# this is used to generate a binary file that we send over serial to display

from PIL import Image
import sys
# assuming 1bpp 320x240 png
im = Image.open(sys.argv[1])

def print_row(y):
    #get 8 bits at a time
    for x in range(0,320,8):
        byte = 0
        for x_offset in range(0,8):
            if(x_offset > 0):
                byte = byte << 1
            px = im.getpixel((x+x_offset,y))
            byte = byte | px
        sys.stdout.buffer.write(byte.to_bytes(1, 'big'))
        #print(f'{byte:08b}')

for y in range(0,240):
    print_row(y)
