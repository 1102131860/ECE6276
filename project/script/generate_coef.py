# Define the coefficient list
coef_list = [7, 3, -8, -5, 2, -2]
n = len(coef_list)

print(f"Generating all {2**n} combinations:\n")

# Loop over all 2^6 combinations
for i in range(2**n):
    terms = []   # to collect each term's string representation
    total = 0    # to store the resulting sum for this combination

    # For each coefficient, decide whether to include it (1) or not (0)
    for j in range(n):
        # Extract the j-th bit from i; bit0 corresponds to coef_list[0]
        bit = (i >> j) & 1
        total += bit * coef_list[j]
        # Format term: if the coefficient is negative, add parentheses
        if coef_list[j] < 0:
            term = f"{bit}x({coef_list[j]})"
        else:
            term = f"{bit}x{coef_list[j]}"
        terms.append(term)
    
    # Build the expression string by joining terms in order (coef0 to coef5)
    expression = "+".join(terms)
    # Generate the binary literal (6-bit format). format(i, '06b') gives the conventional MSB-to-LSB order.
    bin_literal = format(i, '06b')
    
    # Print the output for the current combination
    print(f"{expression} = {total} (0b{bin_literal})")
