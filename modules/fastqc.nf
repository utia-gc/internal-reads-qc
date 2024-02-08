process fastqc {
    tag "${metadata.sampleName}"

    label 'fastqc'

    label 'med_cpu'
    label 'def_mem'
    label 'med_time'

    input:
        tuple val(metadata), path(reads1), path(reads2)

    output:
        path('*.html'), emit: html
        path('*.zip'),  emit: zip

    script:
        def r1Name = "${metadata.sampleName}_R1.fastq.gz"

        if(metadata.readType == 'single') {
            """
            # rename files through softlinks if necessary
            [ ! -f ${r1Name} ] && ln -s ${reads1} ${r1Name}

            fastqc \\
                --quiet \\
                --threads 1 \\
                ${r1Name}
            """
        } else if(metadata.readType == 'paired') {
            def r2Name = "${metadata.sampleName}_R2.fastq.gz"
            
            """
            # rename files through softlinks if necessary
            [ ! -f ${r1Name} ] && ln -s ${reads1} ${r1Name}
            [ ! -f ${r2Name} ] && ln -s ${reads2} ${r2Name}

            fastqc \\
                --quiet \\
                --threads 2 \\
                ${r1Name} \\
                ${r2Name}
            """
        }
}
