/*
---------------------------------------------------------------------
    utia-gc/internal-reads-qc
---------------------------------------------------------------------
https://github.com/utia-gc/internal-reads-qc
*/

nextflow.enable.dsl=2

workflow {
    Channel
        .fromFilePairs(
            file(params.readsDir).resolve('*_R{1,2}_001.fastq.gz'),
            size: -1
        )
        .set { ch_reads }
}
