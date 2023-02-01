library(tidyverse)

# Import paths

loc_raw <- c("/vortexfs1/omics/huber/data/frenemies-metaG-jan2023/Frenemies_MCR_metag_2022_done")

paths <- as.data.frame(list.files(path = loc_raw, pattern = ".fastq.gz", full.names = FALSE))

colnames(paths)[1]<-"FASTQ"

paths$PATH <- loc_raw

paths_run <- paths %>% 
	separate(FASTQ, into = c("SAMPLEID", "S_ID", "LANE", "READ", "else"), remove = FALSE, sep = "_") %>%
	pivot_wider(names_from = "READ", values_from = "FASTQ") %>%
	mutate(LAB_NUM = as.factor(SAMPLEID)) %>% select(-SAMPLEID, -`else`, -S_ID) %>%
	unite("SAMPLEID", LAB_NUM, LANE, sep = "_", remove = FALSE)

metadata <- read_delim("../mcr-metag-samplelist.txt")

metadata_rev <- metadata %>%
		mutate(LAB_NUM = as.factor(LAB_NUM)) %>%
			select(LAB_NUM, FULL_NAME = SITE_SEQ_NUM_VENT_SAMPLEID,
			ASSEMBLY_GROUPING = VENT, VENT_formatted)

paths_run_rev <- paths_run %>%
	filter(LAB_NUM != "Undetermined") %>%
	right_join(metadata_rev) %>%
	add_column(OMIC = "METAGENOMIC") %>%
	select(SAMPLEID, OMIC, FULLPATH = PATH,
		R1, R2, ASSEMBLY_GROUPING, LAB_NUM, FULL_NAME)

write_delim(paths_run_rev, file = "sample_list_metagenomic.txt", delim = "\t")
