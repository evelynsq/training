#!/usr/bin/env nextflow

include { IDENTIFY_LANGUAGE } from './modules/langid.nf'
include { COWPY } from './modules/cowpy.nf'

workflow  {

    ch_datasheet = channel.fromPath("./data/datasheet.csv")
        .splitCsv(header: true)
        .map { row -> [ [id: row.id, character: row.character], row.recording] }

    IDENTIFY_LANGUAGE(ch_datasheet)
    IDENTIFY_LANGUAGE.out
        .map { meta, file, lang_id ->
            [meta + [lang: lang_id], file]
        }
        .map { meta, file ->
            def lang_group = "unknown"
            if (meta.lang.equals("de") || meta.lang.equals("en")) {
                lang_group = "germanic"
            }
            else if (meta.lang in ["fr", "it", "es"]) {
                lang_group = "romance"
            }
            [meta + [lang_group: lang_group], file]
        }
        // give the output its own name to easily feed it into next process
        .set { ch_languages }

    /* ch_languages.map { meta, file -> file }.view { file -> "File: " + file },
    ch_languages.map { meta, file -> meta.character }.view { character -> "Character: " + character }

    Mapping methods before cowpy process changed to take in metadata

    Single map option
    COWPY(
        ch_languages.map { meta, file -> file },
        ch_languages.map { meta, file -> meta.character }
    )

    Multi-map option
    COWPY(
        ch_languages.multiMap { meta, file ->
                file: file
                character: meta.character
            }
    )*/

    // Now passing entire Meta Map
    COWPY(ch_languages)

}
