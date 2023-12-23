import os

log_dir = './log'

log_files = [file for file in os.listdir(log_dir) if file.endswith('.log')]

max_file_length = max(len(file) for file in log_files)

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
