
#Generate assembly group files for metagenomic and metatranscriptomic sample lists

library(tidyverse)

# Import:


metag_in <- read.delim(list.files(pattern = "metagenomic.txt"))

metag_assemble <- metag_in %>%
    group_by(ASSEMBLY_GROUPING) %>%
    summarize(SAMPLE_LIST=paste(unique(SAMPLEID), collapse=",")) %>%
    as.data.frame

write_delim(metag_assemble, "assembly-list-metaG.txt", delim = "\t")

