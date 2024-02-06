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
