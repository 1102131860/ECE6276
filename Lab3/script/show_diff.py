output = "../run/output_updated.txt"
ref_output = "../run/output_ref.txt"

count = 0
with open(output, "r", encoding="utf-8") as output_file, open(ref_output, "r", encoding="utf-8") as ref_output_file:
    for i, (line_out, line_ref) in enumerate(zip(output_file, ref_output_file)):
        if line_out != line_ref:
            print(f"[+] line {i}: {line_out.strip()}")
            print(f"[-] line {i}: {line_ref.strip()}")
            count += 1
            if count == 99:
                break

print(f"Found {count} differences between two files")
