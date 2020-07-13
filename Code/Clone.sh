#!/bin/bash
#$ -S /bin/bash
#$ -cwd

PyClone build_mutations_file \
--in_file pyclone/tsv/' + tumorID  +'.tsv \
--out_file pyclone/yaml/' + tumorID +'.yaml \
--prior total_copy_number


## If you need more help, Please visit https://bitbucket.org/aroth85/pyclone for installation and usage help.
