/*
 * Convert all lower case letters into upper case
 */
process convertToUpper {
    input:
    path greeting_file

    output:
    path "UPPER-${greeting_file}"

    script:
    """
    cat ${greeting_file} | tr '[a-z]' '[A-Z]' > 'UPPER-${greeting_file}'
    """
}
