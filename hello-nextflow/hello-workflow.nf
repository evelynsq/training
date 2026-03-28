#!/usr/bin/env nextflow

include { sayHello } from './modules/sayHello.nf'
include { convertToUpper } from './modules/convertToUpper.nf'
include { collectGreetings } from './modules/collectGreetings.nf'

/*
 * Pipeline parameters
 */
params {
    input: Path = 'data/greetings.csv'
    batch_name: String = 'batch'
}

workflow {

    main:
    // create a channel for inputs from a CSV file
    greeting_ch = channel.fromPath(params.input)
                        .splitCsv()
                        .map { line -> line[0] }
    // emit a greeting
    sayHello(greeting_ch)
    convertToUpper(sayHello.out)
    collectGreetings(convertToUpper.out.collect(), params.batch_name)

    publish:
    first_output = sayHello.out
    second_output = convertToUpper.out
    outfile_output = collectGreetings.out.outfile
    report_output = collectGreetings.out.report
}

output {
    first_output {
        path 'hello_workflow'
        mode 'copy'
    }
    second_output {
        path 'hello_workflow'
    }
    outfile_output {
        path 'hello_workflow'
    }
    report_output {
        path 'hello_workflow'
    }
}
