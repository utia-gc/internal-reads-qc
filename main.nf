/*
---------------------------------------------------------------------
    utia-gc/internal-reads-qc
---------------------------------------------------------------------
https://github.com/utia-gc/internal-reads-qc
*/

nextflow.enable.dsl = 2

include { fastqc } from './modules/fastqc.nf'
include { multiqc } from './modules/multiqc.nf'

workflow {
    inputFastqs_ch = channel.fromPath(
            file(params.readsDir).resolve('*.fastq.gz')
        )
        .filter { fastqPath ->
            fastqPath.name ==~ /^(?!Undetermined_S0).*/
        }

    // gather input FASTQs into groups of size `params.bufferSize` for batch processing
    bufferedFastqs_ch = inputFastqs_ch.buffer(size: params.bufferSize, remainder: true)
    fastqc(bufferedFastqs_ch)

    ch_multiqc = Channel
        .empty()
        .concat(fastqc.out.zip)
        .collect(sort: true)

    multiqc(
        ch_multiqc,
        params.projectName,
    )
}
