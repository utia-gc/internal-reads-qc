include { cat_reads } from '../modules/cat_reads.nf'

workflow CONCATENATE_LANES {
    take:
        reads

    main:
        // group reads by sample name
        reads
            // pull out samplename as grouping key
            .map { metadata, reads1, reads2 ->
                [ metadata.sampleName, metadata, reads1, reads2 ]
            }
            // group by sample name
            .groupTuple()
            // drop lane from metadata and sort grouped reads to keep read pairs together
            .map { sampleNameKey, metadata, reads1s, reads2s ->
                // build a consensus metadata map for each sample. here this should essentially just drop the `lane` key
                def consensusMetadata = intersectListOfMetadata(metadata)

                // sort reads
                def reads1sSorted = reads1s.sort { a, b ->
                    a.name.compareTo(b.name)
                }
                def reads2sSorted = reads2s.sort { a, b ->
                    a.name.compareTo(b.name)
                }

                [ consensusMetadata, reads1sSorted, reads2sSorted ]
            }
            .dump(tag: "ch_grouped_reads")
            .set{ ch_grouped_reads }

        // concatenate reads in groups
        cat_reads(ch_grouped_reads)
        cat_reads.out.cat_reads
            .dump(tag: "cat_reads.out.cat_reads")

    emit:
        cat_reads = cat_reads.out.cat_reads
}


/**
 * Find the intersection of a list of metadata maps.
 *
 * @params metadataList A list of metadata maps.
 *
 * @return LinkedHashMap A map of the consensus metadata, i.e. the intersection of all key:value pairs from the list of metadata maps.
 */
LinkedHashMap intersectListOfMetadata(metadataList) {
    def metadataIntersection = metadataList[0]

    metadataList.each { metadata ->
        metadataIntersection = metadataIntersection.intersect(metadata)
    }

    // drop 'lane' key(s) from the interstected metadata map if they survived the intersection
    metadataIntersection.removeAll { k,v -> k == 'lane' }

    return metadataIntersection
}
