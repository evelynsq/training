// Generate ASCII art with cowpy
process COWPY {

    publishDir "results/", mode: 'copy'

    container 'community.wave.seqera.io/library/cowpy:1.1.5--3db457ae1977a273'

    input:
    tuple val(meta), path(input_file)

    output:
    path "./${meta.lang_group}/${meta.lang}-${input_file}"

    script:
    """
    if [ ! -d "${meta.lang_group}" ]; then
        mkdir ${meta.lang_group}
    fi
    cat ${input_file} | cowpy -c ${meta.character} > ./${meta.lang_group}/${meta.lang}-${input_file}
    """
}
