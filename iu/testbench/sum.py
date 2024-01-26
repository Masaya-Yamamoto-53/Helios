import os

filenames = [
          '00_br'
        , '00_sethi'
        , '01_call'
        , '02_alu'
        , '02_sft'
        , '02_sext'
        , '02_mul'
        , '03_ldst'
        , '03_jmpl'
        , '03_psr'
        , '04_illegal_instruction'
        , '04_mem_address_not_aligned'
        , '06_fwd'
        , '06_hdu'
        , '99_binary_search'
        , '99_bubble_sort'
        , '99_gcd'
        , '99_div'

]

def check_files_match(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        contents1 = f1.read()
        contents2 = f2.read()

    if contents1 == contents2:
        return True
    else:
        return False

log_dir = './log'
log_files = [file for file in os.listdir(log_dir) if file.endswith('.log')]
max_file_length = max(len(file) for file in log_files)

print("================================================================================")
print("= Unit Test Result                                                             =")
print("================================================================================")

for file_name in log_files:
    pass_count = 0
    total_count = 0
    all_pass = True

    with open(os.path.join(log_dir, file_name), 'r') as file:
        lines = file.readlines()
        for line in lines:
            total_count += 1
            if 'pass' in line:
                pass_count += 1
            else:
                all_pass = False

    result = 'pass' if all_pass else '\033[91mfail\033[0m'

    print(f"{file_name.ljust(max_file_length)} {result} {pass_count}/{total_count}")

print("================================================================================")
print("= Integration Test Result                                                      =")
print("================================================================================")

for filename in filenames:
    test_result = './log/' + filename + '.dump'
    test_excepted = './excepted/' + filename

    if check_files_match(test_result, test_excepted):
        print(filename + ': pass')
    else:
        print(filename + ': \033[91mfail\033[0m')
