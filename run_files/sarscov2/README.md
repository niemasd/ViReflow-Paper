ViReflow command:

```bash
ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://vireflow-demo/benchmark -mt 1 -id repnum -o repnum.rf s3://vireflow-demo/benchmark/sarscov2_R1.fastq s3://vireflow-demo/benchmark/sarscov2_R2.fastq
```

| Number of Samples | ViReflow Walltime (seconds) | ViReflow Cost (dollars) |
| ----------------- | --------------------------- | ----------------------- |
|                 1 |                    2145.172 |                     TBD |
