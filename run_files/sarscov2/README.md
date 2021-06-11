ViReflow command:

```bash
ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d OUTPUT_S3_DIR -mt 1 -id REPNUM -o REPNUM.rf R1_FASTQ_S3 R2_FASTQ_S3
```

Copy FASTQ files for each replicate:

```bash
# replace 'n=1' with whatever n
n=1; parallel --jobs 7 aws s3 cp s3://niema-test/sarscov2_R{2}.fastq s3://niema-test/n$n/n$n.r{1}_R{2}.fastq ::: $(seq -w 1 $n) ::: 1 2
```

Generate batch files for each replicate:

```bash
# replace 'n=1' with whatever n
n=1; parallel --jobs 7 ~/ViReflow/ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://niema-test/n$n -mt 1 -id n$n.r{} -o n$n.r{}.rf s3://niema-test/n$n/n$n.r{}_R1.fastq s3://niema-test/n$n/n$n.r{}_R2.fastq ::: $(seq -w 1 $n)
```

Results:

| Number of Samples | ViReflow Walltime (seconds) | ViReflow Cost (dollars) |
| ----------------: | --------------------------: | ----------------------: |
|                 1 |                    2198.452 |                     ??? |
|                 2 |                    2179.952 |                     ??? |
|                10 |                    2147.104 |                     ??? |
