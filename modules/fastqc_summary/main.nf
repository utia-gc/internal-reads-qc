process fastqc_summary {
    tag "batch_${task.index}"

    label 'fastqc_summary'

    label 'def_cpu'
    label 'def_mem'
    label 'def_time'

    input:
    path fastqcZips, arity: '1..*'

    output:
    path '*_fastqc-summary.json', arity: '1..*', emit: fastqcSummary

    script:
    """
    for fastqc_zip_base in ${fastqcZips.collect { fastqcZip -> fastqcZip.baseName }.toSorted().join(' ')}; do
        fastqc-summary \\
            --output "\${fastqc_zip_base}-summary.json" \\
            "\${fastqc_zip_base}.zip"
    done
    """
}
