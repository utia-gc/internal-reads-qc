/*
---------------------------------------------------------------------
    utia-gc/internal-reads-qc
---------------------------------------------------------------------
https://github.com/utia-gc/internal-reads-qc
*/

nextflow.enable.dsl = 2

include { fastqc } from './modules/fastqc.nf'
include { fastqc_summary } from './modules/fastqc_summary'
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

    fastqc_summary(fastqc.out.zip)
    fastqcSummary_ch = fastqc_summary.out.fastqcSummary
        .flatMap { fastqcSummaryJsons ->
            def fastqcSummaries = fastqcSummaryJsons.collect { fastqcSummaryJson ->
                def fastqcSampleName = fastqcSummaryJson.name.replace('_fastqc-summary.json', '')

                def baseCount = new groovy.json.JsonSlurper().parseText(fastqcSummaryJson.text)['base_count'] as Long
                def readCount = new groovy.json.JsonSlurper().parseText(fastqcSummaryJson.text)['read_count'] as Long

                return "${fastqcSampleName}\t${readCount}\t${baseCount}"
            }

            return fastqcSummaries
        }
        .collectFile(
            name: 'fastqc-summary.tsv',
            newLine: true,
            seed: "fastq_name\tread_count\tbase_count",
            sort: true,
        )

    ch_multiqc = channel.empty()
        .concat(fastqc.out.zip)
        .mix(fastqcSummary_ch)
        .collect(sort: true)

    multiqc(
        ch_multiqc,
        file("${projectDir}/assets/multiqc_config.yaml"),
        params.projectName,
    )
}
