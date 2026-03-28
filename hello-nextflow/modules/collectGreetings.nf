/*
* combine all converted greetings from their files into one file
*/
process collectGreetings {

    input:
    path combined_files
    val batch_name

    output:
    path "COMBINED-${batch_name}-output.txt", emit: outfile
    path "num_files-${batch_name}-output.txt", emit: report

    script:
    files_num = combined_files.size()
    """
    cat ${combined_files} > 'COMBINED-${batch_name}-output.txt'
    echo 'There were ${files_num} greetings in the files.' > 'num_files-${batch_name}-output.txt'
    """
}
