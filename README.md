# internal-reads-qc

A Nextflow pipeline for internal QC of sequencing reads.

## Test data

Downloaded test data from [utia-gc/ngs-test](https://github.com/utia-gc/ngs-test/tree/ngs).

```bash
wget \
    --no-clobber \
    --directory-prefix=tests/data/reads/raw \
    https://github.com/utia-gc/ngs-test/raw/ngs/data/reads/raw/SRR6924569_S1_L001_R1_001.fastq.gz \
    https://github.com/utia-gc/ngs-test/raw/ngs/data/reads/raw/SRR6924569_S1_L001_R2_001.fastq.gz \
    https://github.com/utia-gc/ngs-test/raw/ngs/data/reads/raw/SRR6924569_S1_L002_R1_001.fastq.gz \
    https://github.com/utia-gc/ngs-test/raw/ngs/data/reads/raw/SRR6924569_S1_L002_R2_001.fastq.gz \
    https://github.com/utia-gc/ngs-test/raw/ngs/data/reads/raw/SRR1066657_S3_L001_R1_001.fastq.gz \
    https://github.com/utia-gc/ngs-test/raw/ngs/data/reads/raw/SRR1066657_S3_L002_R1_001.fastq.gz
```

Fetch Ultima UG100 data from SRA and sample to 25,000 reads.

```bash
# fetch the FASTQ file
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR303/089/SRR30357389/SRR30357389.fastq.gz -o tests/data/reads/SRR30357389_Deep_RNA-seq_R1.fastq.gz

# sample to 25k reads
apptainer exec "https://depot.galaxyproject.org/singularity/fq%3A0.12.0--h9ee0642_0" fq \
    subsample \
    --record-count 25000 \
    --seed 20260116 \
    --r1-dst tests/data/reads/raw/SRR30357389_Deep_RNA-seq_R1.fastq.gz \
    tests/data/reads/SRR30357389_Deep_RNA-seq_R1.fastq.gz

# remove the full FASTQ file
rm tests/data/reads/SRR30357389_Deep_RNA-seq_R1.fastq.gz
```
