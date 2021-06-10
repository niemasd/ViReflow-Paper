ViReflow command:

```bash
ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://vireflow-demo/benchmark -mt 1 -id repnum -o repnum.rf s3://vireflow-demo/benchmark/sarscov2_R1.fastq s3://vireflow-demo/benchmark/sarscov2_R2.fastq
```

Copy FASTQ files for each replicate:

```bash
# replace 'n=10' with whatever n
n=10; parallel --jobs 7 aws s3 cp s3://vireflow-demo/benchmark/sarscov2_R{2}.fastq s3://vireflow-demo/benchmark/n$n.r{1}_R{2}.fastq ::: $(seq -w 1 $n) ::: 1 2
```

Generate batch files for each replicate:

```bash
# replace 'n=10' with whatever n
n=10; parallel --jobs 7 ~/ViReflow/ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://vireflow-demo/benchmark -mt 1 -id n$n.r{} -o n$n.r{}.rf s3://vireflow-demo/benchmark/n$n.r{}_R1.fastq s3://vireflow-demo/benchmark/n$n.r{}_R2.fastq ::: $(seq -w 1 $n)
```

Results:

| Number of Samples | ViReflow Walltime (seconds) | ViReflow Cost (dollars) |
| ----------------- | --------------------------- | ----------------------- |
|                 1 |                    2145.172 |                     TBD |
|                10 |                    2086.650 |                     TBD |
