#!/usr/bin/env nextflow

process cowpy {

    container 'community.wave.seqera.io/library/pip_cowpy:8b70095d527cd773'
    conda 'conda-forge::cowpy==1.1.5'

    input:
    path input_file
    val character

    output:
    path "cowpy-${character}-${input_file}"

    script:
    """
    cat ${input_file} | cowpy -c "${character}" > "cowpy-${character}-${input_file}"
    """
}
