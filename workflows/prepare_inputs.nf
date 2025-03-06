workflow PREPARE_INPUTS {
    take:
        reads_dir

    main:
        Channel
            .fromFilePairs(
                file(reads_dir).resolve('*_R{1,2}_001.fastq.gz'),
                size: -1
            )
            // filter out "Undetermined" files
            .filter { sampleInfo, reads ->
                sampleInfo ==~ /^(?!Undetermined_S0).*/
            }
            // reshape reads to get a collection of format [sampleInfo, reads1, reads2]
            // for single-end reads, reads2 is an empty file
            .map { sampleInfo, reads ->
                if(reads.size() == 2) {
                    return [ sampleInfo, reads[0], reads[1] ]
                } else if(reads.size() == 1) {
                    // create an empty R2 file when reads are single-end
                    def emptyR2Path = file(workDir).resolve(reads[0].getName().replaceFirst(/_R1_001/, "_R2_001") + '.EMPTYFILE')
                    def emptyR2 = file(emptyR2Path)
                    // have to write to file to create it
                    emptyR2.write('')
                    return [ sampleInfo, reads[0], emptyR2 ]
                }
            }
            // cast sampleInfo to a map
            .map { sampleInfo, reads1, reads2 ->
                [
                    populateMetadata(sampleInfo, reads1, reads2),
                    reads1,
                    reads2
                ]
            }
            .set { ch_readPairs }
        ch_readPairs.view()

    emit:
        reads = ch_readPairs
}


def populateMetadata(sampleInfo, reads1, reads2) {
    // store metadata in a Map
    LinkedHashMap metadata = [:]

    // capture metadata from sample information
    // captures lane number if it exists
    def capturePattern = /^(.*?)_S(\d+)(?:_L(\d+))?_R[12]_001\.fastq\.gz$/
    def fastqSampleMatcher = (reads1.getName() =~ capturePattern)

    // populate metadata with captured sample information
    if(fastqSampleMatcher.find()) {
        metadata.put('sampleName', fastqSampleMatcher.group(1))
        metadata.put('lane', fastqSampleMatcher.group(3) ?: '')
    } else {
        metadata.put('sampleName', sampleInfo)
        metadata.put('lane', '')
    }

    // populate library read type metadata from investigating reads2 file
    // existant and non-empty reads2 file means paired-end reads
    // assume that reads1 exists and is non empty
    metadata.put('readType', (reads2.exists() && reads2.isEmpty()) ? 'single' : 'paired')

    return metadata
}
