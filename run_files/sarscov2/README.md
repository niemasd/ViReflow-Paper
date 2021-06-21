This used the AHFGT7DRXY NovaSeq run. The benchmarking over multiple values of *n* used random subsamples of this sample:
```
SEARCH-19280__D101810__M11__210529_A00953_0313_AHFGT7DRXY__S49_L002
```

# ViReflow command

```bash
ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d OUTPUT_S3_DIR -mt 1 -id REPNUM -o REPNUM.rf R1_FASTQ_S3 R2_FASTQ_S3
```
# Copy FASTQ files for each replicate

```bash
# replace 'n=1' with whatever n (total number of samples)
# replce 'r=10' with whatever r (total number of technical replicates)
n=1; r=10; parallel --jobs 7 aws s3 cp s3://niema-test/SEARCH-19469_R{3}.fastq s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R{3}.fastq ::: $(seq -w 1 $r) ::: $(seq -w 1 $n) ::: 1 2
```

# Generate batch files for each replicate

```bash
# replace 'n=1' with whatever n (total number of samples)
# replace 'R=10' with whatever R (total number of technical replicates)
n=1; R=10; for r in $(seq -w 1 $R); do mkdir -p r$r; done; parallel --jobs 7 ~/ViReflow/ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://niema-test/n$n/r{1}/ -mt 1 -id n$n.r{1}.s{2} -o r{1}/n$n.r{1}.s{2}.rf s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R1.fastq s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R2.fastq ::: $(seq -w 1 $R) ::: $(seq -w 1 $n); parallel --jobs 7 ~/ViReflow/rf_batch.py -o n$n.r{1}.rf r{1}/*.rf ::: $(seq -w 1 $R)
```

# Results

| Number of Samples | ViReflow Walltime (seconds) | ViReflow Cost (dollars) | ViReflow Cost/Sample (dollars) |
| ----------------: | --------------------------: | ----------------------: | -----------------------------: |
|                 1 |                         ??? |                    $??? |                           $??? |
|                10 |                         ??? |                    $??? |                           $??? |
|               100 |                         ??? |                    $??? |                           $??? |
|              1000 |                         ??? |                    $??? |                           $??? |
|             10000 |                         ??? |                    $??? |                           $??? |
|            100000 |                         ??? |                    $??? |                           $??? |
|      Full NovaSeq |                         ??? |                    $??? |                           $??? |
