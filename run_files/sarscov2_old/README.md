This used an internal NovaSeq dataset, but for the actual paper, we should use an already-published dataset.

# ViReflow command

```bash
ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d OUTPUT_S3_DIR -mt 1 -id REPNUM -o REPNUM.rf R1_FASTQ_S3 R2_FASTQ_S3
```

# Copy FASTQ files for each replicate

```bash
# replace 'n=1' with whatever n
n=1; parallel --jobs 7 aws s3 cp s3://niema-test/sarscov2_R{2}.fastq s3://niema-test/n$n/n$n.r{1}_R{2}.fastq ::: $(seq -w 1 $n) ::: 1 2
```

# Generate batch files for each replicate

```bash
# replace 'n=1' with whatever n
n=1; parallel --jobs 7 ~/ViReflow/ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://niema-test/n$n -mt 1 -id n$n.r{} -o n$n.r{}.rf s3://niema-test/n$n/n$n.r{}_R1.fastq s3://niema-test/n$n/n$n.r{}_R2.fastq ::: $(seq -w 1 $n)
```

# Results

| Number of Samples | ViReflow Walltime (seconds) | ViReflow Cost (dollars) | ViReflow Cost/Sample (dollars) |
| ----------------: | --------------------------: | ----------------------: | -----------------------------: |
|                 1 |                    2198.452 |                   $0.07 |                          $0.07 |
|                 2 |                    2179.952 |                   $0.04 |                          $0.02 |
|                 4 |                    2061.226 |                   $0.08 |                          $0.02 |
|                10 |                    2147.104 |                   $0.33 |                          $0.03 |
|                20 |                    2090.673 |                   $0.69 |                          $0.03 |
|                40 |                    2062.069 |                   $1.24 |                          $0.03 |
|               100 |                    2092.231 |                   $4.26 |                          $0.04 |
|               200 |                    2094.054 |                   $4.62 |                          $0.02 |
|               400 |                    2114.001 |                  $11.45 |                          $0.03 |
|              1000 |                    1878.077 |                  $20.34 |                          $0.02 |
|      Full NovaSeq |                    7489.465 |                  $61.95 |                          $0.09 |
