library(readr)
source('search_pubmed.R')
results <- 
  pubmed(start_year = 2000,
         end_year = 2016,
         search_topic = '((vaccine) OR (vaccination) OR (immunization)) AND (cost) AND (africa)',
         counts_only = FALSE)
write.csv(results, 'pubmed_results.csv')