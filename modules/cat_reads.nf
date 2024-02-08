process cat_reads {
    tag "${metadata.sampleName}"

    label 'base'

    label 'def_cpu'
    label 'lil_mem'
    label 'lil_time'

    input:
        tuple val(metadata), path(reads1), path(reads2)

    output:
        tuple val(metadata), path("${metadata.sampleName}_R1.fastq.gz"), path("${metadata.sampleName}_R2.{fastq.gz,fastq.gz.EMPTYFILE}"), emit: cat_reads

    script:
        def r1Name = "${metadata.sampleName}_R1.fastq.gz"
        def r2Name = (metadata.readType == 'single') ? "${metadata.sampleName}_R2.fastq.gz.EMPTYFILE" : "${metadata.sampleName}_R2.fastq.gz"

        """
        cat ${reads1} > ${r1Name}
        cat ${reads2} > ${r2Name}
        """
} 
