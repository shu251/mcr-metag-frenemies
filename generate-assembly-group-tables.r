
#Generate assembly group files for metagenomic and metatranscriptomic sample lists

library(tidyverse)

# Import:

## usage: requires input sample list files that have 'metagenomic' and 'metatranscriptomic' in the file name.

metag_in <- read.delim(list.files(pattern = "metagenomic.txt"))
metat_in <- read.delim(list.files(pattern = "metatranscriptomic.txt"))

metag_assemble <- metag_in %>%
    group_by(ASSEMBLY_GROUPING) %>%
    summarize(SAMPLE_LIST=paste(unique(SAMPLEID), collapse=",")) %>%
    as.data.frame
write_delim(metag_assemble, "assembly-list-metaG.txt", delim = "\t")

metat_assemble <- metat_in %>%
    group_by(ASSEMBLY_GROUPING) %>%
    summarize(SAMPLE_LIST=paste(unique(SAMPLEID), collapse=",")) %>%
    as.data.frame
write_delim(metat_assemble, "assembly-list-metaT.txt", delim = "\t")
