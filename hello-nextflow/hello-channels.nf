#!/usr/bin/env nextflow

/*
 * Use echo to print 'Hello World!' to a file
 */
process sayHello {

    input:
    val greeting

    output:
    path "${greeting}_output.txt"

    script:
    """
    echo '${greeting}' > ${greeting}_output.txt
    """
}

/*
 * Pipeline parameters
 */
params {
    input: Path = 'data/greetings.csv'
}

workflow {

    main:
    // create channel and only take the first column of input data
    greetings_ch = channel.of(params.input)
        .splitCsv()
        .map { rowarray -> rowarray[0] }
        .view()

    // emit a greeting
    sayHello(greetings_ch)

    publish:
    first_output = sayHello.out
}

output {
    first_output {
        path 'hello_channels'
        mode 'copy'
    }
}
