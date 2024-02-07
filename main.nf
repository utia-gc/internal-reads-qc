/*
---------------------------------------------------------------------
    utia-gc/internal-reads-qc
---------------------------------------------------------------------
https://github.com/utia-gc/internal-reads-qc
*/

nextflow.enable.dsl=2

include { PREPARE_INPUTS } from './workflows/prepare_inputs.nf'

workflow {
    PREPARE_INPUTS(params.readsDir)
}
