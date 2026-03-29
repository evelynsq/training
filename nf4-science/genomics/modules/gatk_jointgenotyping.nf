#!/usr/bin/env nextflow

/*
 * Combine GVCFs into GenomicsDB datastore and run joint genotyping to produce cohort-level calls
 */
process GATK_JOINTGENOTYPING {

    container 'community.wave.seqera.io/library/gatk4:4.5.0.0--730ee8817e436867'

    input:
    path all_gvcfs
    path all_idxs
    path intervals_list
    val cohort_name
    path ref_fasta
    path ref_idx
    path ref_dict

    output:
    path "${cohort_name}.joint.vcf", emit: vcf
    path "${cohort_name}.joint.vcf.idx" , emit: idx

    script:
    def gvcfs_line = all_gvcfs.collect { gvcf -> "-V ${gvcf}" }.join(' ')
    """
    gatk GenomicsDBImport \
        ${gvcfs_line} \
        -L ${intervals_list} \
        --genomicsdb-workspace-path ${cohort_name}_gdb

    gatk GenotypeGVCFs \
        -R ${ref_fasta} \
        -V gendb://${cohort_name}_gdb \
        -L ${intervals_list} \
        -O ${cohort_name}.joint.vcf
    """
}
