ViralFlow v0.0.6

```bash
viralflow --run -inputDir viralflow/ -referenceGenome reference.fasta -adaptersFile adapters.fasta -totalCpus 2 -depth 5 -minLen 0 -minDpIntrahost 100 -trimLen 0 -nxtDtset nextclade-sars-cov-2/
```

ViReflow v1.0.19

```bash
ViReflow.py -d "s3://niema-test/ViReflow-ViralFlow-test" -rf "https://github.com/niemasd/ViReflow-Paper/raw/main/data/pipeline_comparison_PRJEB47823/run_files/SARS-CoV-2.reference.fasta" -rg "https://github.com/niemasd/ViReflow-Paper/raw/main/data/pipeline_comparison_PRJEB47823/run_files/SARS-CoV-2.reference.gff3" -p "https://github.com/niemasd/ViReflow-Paper/raw/main/data/pipeline_comparison_PRJEB47823/run_files/SARS-CoV-2.primer.bed" PRJEB47823.csv
```
