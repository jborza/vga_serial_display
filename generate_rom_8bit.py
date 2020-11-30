from PIL import Image
# assuming 1bpp 320x240 png
im = Image.open('g2.png')

def print_row(y):
    #get 8 bits at a time
    for x in range(0,320,8):
        byte = 0
        for x_offset in range(0,8):
            if(x_offset > 0):
                byte = byte << 1
            px = im.getpixel((x+x_offset,y))
            byte = byte | px
            #print(px, end='\n')
        print(f'{byte:08b}')

for y in range(0,240):
    print_row(y)
    
