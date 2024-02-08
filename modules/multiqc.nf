process multiqc {
    label 'multiqc'
    
    label 'def_cpu'
    label 'def_mem'
    label 'lil_time'

    publishDir(
        path: "${params.publishDirReports}"
    )

    input:
        path '*'

    output:
        path '*'

    script:
        """
        multiqc \\
            --interactive \\
            --filename fastqc_multiqc \\
            .
        """
}
