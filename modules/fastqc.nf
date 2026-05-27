process fastqc {
    tag "batch_${task.index}"

    label 'fastqc'

    label 'med_time'

    // scale number CPUs to match number FASTQ files
    cpus { fastq_files.size() }
    // scale memory to be 2GB overhead + 0.5GB per FASTQ files
    memory { 2048.MB + 512.MB * fastq_files.size() }

    input:
    path fastq_files, arity: '1..*'

    output:
    path ('*.html'), arity: '1..*', emit: html
    path ('*.zip'), arity: '1..*', emit: zip

    script:
    """
    fastqc \\
        --quiet \\
        --threads ${task.cpus} \\
        --dir \${PWD} \\
        --nogroup \\
        ${fastq_files}
    """
}
