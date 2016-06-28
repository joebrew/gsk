library(readr)
library(beepr)
source('search_pubmed.R')
# results <- 
#   pubmed(start_year = 2000,
#          end_year = 2016,
#          search_topic = '((vaccine) OR (vaccination) OR (immunization)) AND (cost) AND (africa)',
#          counts_only = FALSE)
# write.csv(results, 'pubmed_results.csv')
results <- read_csv('pubmed_results.csv')
results$abstract <- as.character(results$abstract)

# Create a column indicating whether the article is useful or not
results$useful <- 'no'

# Go through each result and open the url
for (i in 901:nrow(results)){
  # beep()
  message(paste0('Result number ', i, '\n',
                 results$title[i]))
  abstract_length <- nchar(as.character(results$abstract[i]))
  sleep_time <- abstract_length / 250
  # browseURL(url = results$url[i])
  print(results$abstract[i])
  # Sys.sleep(sleep_time)
}

# As you go through each webpage, flag the number if it's useful
useful <- c(1, 2, 14, 18, 23, 29, 35, 36, 48, 49, 53,
            61, 66, 70, 72, 94, 100, 112, 126, 130,
            135, 137, 140, 148, 153, 160, 162, 167,
            169, 176, 197, 199, 201, 205, 211, 218,
            219, 220, 221, 222, 228, 229, 237, 244, 245,
            246, 247, 248, 250, 254, 255, 262, 266,
            271, 273, 280, 283, 286, 296, 299, 314, 320,
            335, 337, 339, 348, 355, 357, 359, 361,
            374, 375, 376, 378, 380, 381, 382, 392,
            393, 408, 410, 411, 420, 421, 422, 426,
            427, 430, 432, 435, 439, 441, 446, 452,
            462, 465, 473, 476, 488, 492, 494, 504,
            511, 513, 522, 523, 524, 525, 526, 529,
            550, 553, 565, 566, 571, 575, 582, 588,
            596, 609, 637, 640, 645, 646, 657, 661, 
            662, 687, 689, 694, 698, 705, 706, 707,
            708, 710, 734, 735, 750, 759, 775, 776,
            779, 784, 787, 795, 796, 801, 807, 814,
            823, 828, 829, 830, 831, 833, 837, 845,
            859, 860, 881, 897, 902, 903, 904, 905,
            906: 910, 916, 917, 933, 934, 959, 961, 
            963, 981)
# 564
# Determinants of uptake
others <- c(468, 475, 883, 898, 904, 921)

# 685
# costs of malaria
others_b <- c(685)

# Keep only the useful ones
to_use <- results[useful,]
# Write a csv
# write_csv(to_use, 'papers_to_use.csv')
