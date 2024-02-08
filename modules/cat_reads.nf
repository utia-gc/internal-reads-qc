process cat_reads {
    tag "${prefix}"

    label 'base'

    label 'def_cpu'
    label 'def_mem'
    label 'sup_time'

    input:
        tuple val(metadata), path(reads1), path(reads2)

    output:
        tuple val(metadata), path("${prefix}_R1.fastq.gz"), path("${prefix}_R2.{.fastq.gz,.fastq.gz.EMPTYFILE}"), emit: cat_reads

    script:
        prefix = metadata.sampleName
        def r1Name = "${prefix}_R1.fastq.gz"
        def r2Name = (metadata.readType == 'single') ? "${prefix}_R2.fastq.gz.EMPTYFILE" : "${prefix}_R2.fastq.gz"

        """
        cat ${reads1} > ${r1Name}
        cat ${reads2} > ${r2Name}
        """
}
