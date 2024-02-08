/*
---------------------------------------------------------------------
    utia-gc/internal-reads-qc
---------------------------------------------------------------------
https://github.com/utia-gc/internal-reads-qc
*/

nextflow.enable.dsl=2

include { CONCATENATE_LANES } from './workflows/concatenate_lanes.nf'
include { PREPARE_INPUTS    } from './workflows/prepare_inputs.nf'

workflow {
    PREPARE_INPUTS(params.readsDir)
      | CONCATENATE_LANES

    PREPARE_INPUTS.out.reads.dump(tag: "MAIN: Read pairs")
    CONCATENATE_LANES.out.cat_reads.dump(tag: "MAIN: Catted read pairs")
}
