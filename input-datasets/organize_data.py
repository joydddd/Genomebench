#!/usr/bin/env python3
#ouput: files with binned reads for testing

import sys
import os
#input FASTA file 
ip ="bsw/large/bandedSWA_SRR7733443_1m_input.txt"

count_total = 0
length_total = 0


f_sample = open("bsw/large/bandedSWA_SRR7733443_500k_input.txt","w+")


#binning reads from input file
with open(ip, 'r') as f:
    for line in f:
        if (count_total > 5000000): break
        header = line.strip()
        seq0 = next(f).strip()
        seq1 = next(f).strip()
        count_total += 1
        f_sample.write(header + '\n' + seq0 + '\n' + seq1 + '\n')
        length_total += len(seq0) + len(seq1)

print("Total number of reads: ", count_total)
print("Total legnth of reads: ", length_total)
f.close()
f_sample.close()

