#!/usr/bin/env nextflow
nextflow.enable.dsl = 2


include { CGPHYLOGENY } from './workflows/cgphylogeny'

workflow {
    CGPHYLOGENY()
}

