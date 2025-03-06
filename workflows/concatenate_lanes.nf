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
            .branch { consensusMetadata, reads1sSorted, reads2sSorted ->
                needsCat: reads1sSorted.size() > 1 && reads2sSorted.size() > 1
                noCat: reads1sSorted.size() == 1 && reads2sSorted.size() == 1
            }
            .set { ch_groupedReads }
        ch_groupedReads.needsCat.dump(tag: "CONCATENATE_LANES: reads to concatenate")

        // concatenate reads in groups
        cat_reads(ch_groupedReads.needsCat)
        cat_reads.out.cat_reads
            .dump(tag: "CONCATENATE_LANES: cat_reads.out.cat_reads")

        // reshape reads that don't need concatenation
        ch_groupedReads.noCat
            .map { metadata, reads1List, reads2List ->
                return [ metadata, reads1List[0], reads2List[0] ]
            }
            .mix(cat_reads.out.cat_reads)
            .dump(tag: "CONCATENATE_LANES: mixed reads")
            .set { ch_readsForQC }

    emit:
        readsForQC = ch_readsForQC
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
