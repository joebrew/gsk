library(gsheet)

# Get link of master spreadsheet of vaccination costs
url_data <- 'https://docs.google.com/spreadsheets/d/1inbYJUdu5uMC0pJOJAA25QCUZ6xFyvWmldjChWlGZok/edit?usp=sharing'
url_papers <- 'https://docs.google.com/spreadsheets/d/1If4C6jECPifBweOCsdlQm4E7pC3xTf_B_Blt2ufWYQo/edit?usp=sharing'

# Read in as dataframe
df <- gsheet2tbl(url_data)
papers <- gsheet2tbl(url_papers)

# Sort by malaria status
papers$has_malaria <- grepl('malaria', tolower(papers$abstract)) | grepl('malaria', tolower(papers$title))

x = papers[papers$has_malaria,]
