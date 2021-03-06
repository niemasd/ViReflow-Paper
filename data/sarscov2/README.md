This used the AHFGT7DRXY NovaSeq run. The benchmarking over multiple values of *n* used random subsamples of this sample:
```
SEARCH-19280__D101810__M11__210529_A00953_0313_AHFGT7DRXY__S49_L002
```

# ViReflow command

```bash
ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d OUTPUT_S3_DIR -id REPNUM -o REPNUM.rf R1_FASTQ_S3 R2_FASTQ_S3
```

# Subsample FASTQ files for each replicate

```bash
# replace 'n=1' with whatever n (total number of samples)
# replace 'R=10' with whatever R (total number of technical replicates)
# replace 'G=29903' with the genome length
# replace 'L=151' with the read length
# replace 'C=500' with whatever coverage per FASTQ (so overall coverage is 2C)
n=1; R=10; G=29903; L=151; C=500; NUM_READS=$(echo $G | numlist -mul$C | numlist -div$L | numlist -int); mkdir -p n$n; for r in $(seq -w 1 $R); do mkdir -p n$n/r$r; done; parallel --jobs 7 'SEED=$RANDOM' "&&" seqtk sample '-s$SEED' SEARCH-19280__D101810__M11__210529_A00953_0313_AHFGT7DRXY__S49_L002_R1_001.fastq.gz $NUM_READS ">" n$n/r{1}/n$n.r{1}.s{2}_R1.fastq "&&" seqtk sample '-s$SEED' SEARCH-19280__D101810__M11__210529_A00953_0313_AHFGT7DRXY__S49_L002_R2_001.fastq.gz $NUM_READS ">" n$n/r{1}/n$n.r{1}.s{2}_R2.fastq ::: $(seq -w 1 $R) ::: $(seq -w 1 $n)
```

For big values of *n*, my PC can't store all the files, so the following copies to S3 and removes locally on-the-fly:

```bash
n=10000; R=10; G=29903; L=151; C=500; NUM_READS=$(echo $G | numlist -mul$C | numlist -div$L | numlist -int); mkdir -p n$n; for r in $(seq -w 1 $R); do mkdir -p n$n/r$r; done; parallel --jobs 7 'SEED=$RANDOM' "&&" seqtk sample '-s$SEED' SEARCH-19280__D101810__M11__210529_A00953_0313_AHFGT7DRXY__S49_L002_R1_001.fastq.gz $NUM_READS ">" n$n/r{1}/n$n.r{1}.s{2}_R1.fastq "&&" aws s3 cp n$n/r{1}/n$n.r{1}.s{2}_R1.fastq s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R1.fastq "&&" seqtk sample '-s$SEED' SEARCH-19280__D101810__M11__210529_A00953_0313_AHFGT7DRXY__S49_L002_R2_001.fastq.gz $NUM_READS ">" n$n/r{1}/n$n.r{1}.s{2}_R2.fastq "&&" aws s3 cp n$n/r{1}/n$n.r{1}.s{2}_R2.fastq s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R2.fastq "&&" rm n$n/r{1}/n$n.r{1}.s{2}_R1.fastq n$n/r{1}/n$n.r{1}.s{2}_R2.fastq ::: $(seq -w 1 $R) ::: $(seq -w 1 $n)
```

# Generate batch files for each replicate

```bash
# replace 'n=1' with whatever n (total number of samples)
# replace 'R=10' with whatever R (total number of technical replicates)
n=1; R=10; mkdir -p n$n; for r in $(seq -w 1 $R); do mkdir -p n$n/r$r; done; parallel --jobs 7 ~/ViReflow/ViReflow.py -rf "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas" -rg "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3" -p "https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed" -d s3://niema-test/n$n/r{1}/ -id n$n.r{1}.s{2} -o n$n/r{1}/n$n.r{1}.s{2}.rf s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R1.fastq s3://niema-test/n$n/r{1}/n$n.r{1}.s{2}_R2.fastq ::: $(seq -w 1 $R) ::: $(seq -w 1 $n); parallel --jobs 7 ~/ViReflow/rf_batch.py -o n$n/n$n.r{1}.rf n$n/r{1}/*.rf ::: $(seq -w 1 $R)
```

# Running the batch files
Within the `ViReflow-Paper/data/sarscov2` directory, a given batch file can be run as follows (e.g. for `n=100` and `r=10`):

```bash
time reflow run n100/n100.r10.rf
vi n100/r10/time.txt # write the `time` output here
mv ~/.reflow/runs/* n100/r10/reflow_logs/ # make sure only 1 reflow run's files is present in `~/.reflow/runs`
git add n*/ && git commit -m "Added more results" && git push
```

# Generate batch files for AHFGT7DRXY

```bash
parallel --jobs 7 ~/ViReflow/ViReflow.py -rf https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.fas -rg https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/NC_045512.2.gff3 -p https://raw.githubusercontent.com/niemasd/ViReflow/main/demo/sarscov2_v2_primers_swift.bed -d s3://niema-test/AHFGT7DRXY/ -id "{}" -o "AHFGT7DRXY/samples/{}.rf" "s3://ucsd-all/210529_A00953_0313_AHFGT7DRXY/210529_A00953_0313_AHFGT7DRXY_fastq/{}_R1_001.fastq.gz" "s3://ucsd-all/210529_A00953_0313_AHFGT7DRXY/210529_A00953_0313_AHFGT7DRXY_fastq/{}_R2_001.fastq.gz" ::: $(aws s3 ls s3://ucsd-all/210529_A00953_0313_AHFGT7DRXY/210529_A00953_0313_AHFGT7DRXY_fastq/ | rev | grep "^zg.qtsaf." | cut -d' ' -f1 | cut -d'_' -f3- | rev | uniq | grep "^SEARCH")
~/ViReflow/rf_batch.py -o AHFGT7DRXY/batch.rf AHFGT7DRXY/samples/*.rf
```
