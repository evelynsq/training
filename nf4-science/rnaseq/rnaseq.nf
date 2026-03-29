#!/usr/bin/env nextflow

// Module INCLUDE statements
include { FASTQC } from './modules/fastqc.nf'
include { TRIM_GALORE } from './modules/trim_galore.nf'
include { HISAT2_ALIGN } from './modules/hisat2_align.nf'

/*
 * Pipeline parameters
 */
params {
    // Primary input
    input: Path

    // Reference genome archive
    hisat2_index_zip: Path
}

workflow {

    main:
    // Create input channel
    reads_ch = channel.fromPath(params.input)

    // Initial quality control
    FASTQC(reads_ch)

    // Adapter trimming and post-trimming QC
    TRIM_GALORE(reads_ch)

    // Alignment to a reference genome
    HISAT2_ALIGN(TRIM_GALORE.out.trimmed_read, file(params.hisat2_index_zip))

    publish:
    // Declare outputs to publish
    fastqc_zip = FASTQC.out.zip
    fastqc_html = FASTQC.out.html
    trimmed_reads = TRIM_GALORE.out.trimmed_read
    trimming_reports = TRIM_GALORE.out.trimming_reports
    trimming_fastqc = TRIM_GALORE.out.fastqc_reports
    bam = HISAT2_ALIGN.out.bam
    align_log = HISAT2_ALIGN.out.log
}

output {
    // Configure publish targets
    fastqc_zip {
        path 'fastqc'
    }
    fastqc_html {
        path 'fastqc'
    }
    trimmed_reads {
        path 'trimming'
    }
    trimming_reports {
        path 'trimming'
    }
    trimming_fastqc {
        path 'trimming'
    }
    bam {
        path 'align'
    }
    align_log {
        path 'align'
    }
}
