process multiqc {
    label 'multiqc'
    
    label 'def_cpu'
    label 'def_mem'
    label 'lil_time'

    publishDir(
        path: "${params.publishDirReports}",
        mode: 'copy'
    )

    input:
        path '*'

    output:
        path '*'

    script:
        """
        multiqc \\
            --interactive \\
            --data-dir \\
            --data-format tsv \\
            --filename fastqc_multiqc \\
            .
        """
}
