import sys

src_file_path = sys.argv[1]
dst_file_path = sys.argv[2]
rom_file_path = sys.argv[3]

start_pattern = 'signal inst_rom : rom_t := ('
end_pattern   = ');'

with open(rom_file_path, 'r') as rom_file:
    rom_value = rom_file.read()

rom = []
flg = True
for line in rom_value.split():
    if flg:
        flg = False
        rom.append('  ' + '"' + line + '"')
    else:
        rom.append(', ' + '"' + line + '"')

with open(src_file_path) as src_file:
    with open(dst_file_path, 'w') as dst_file:
        for line in src_file:
            if start_pattern in line:
                dst_file.writelines(line.strip() + '\n')
                for rom_line in rom:
                    dst_file.writelines(rom_line + '\n')
            else:
                dst_file.writelines(line.strip() + '\n')
