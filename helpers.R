thinnedSpatialPoly <- function(SP, tolerance, minarea) {
  if (!require(shapefiles)) stop("shapefiles package is required")
  stopifnot(inherits(SP, "SpatialPolygons"))
  
  # TODO: determine and set defaults for tolerance, minarea 
  # TODO: suppress warnings: "In Polygon(crds_s) : Non-finite label 
  # point detected and replaced"
  pls <- slot(SP, "polygons")
  pls_dp <- vector(mode="list", length=length(pls))
  for (i in 1:length(pls)) {
    Pls <- slot(pls[[i]], "Polygons")
    Pls_dp <- vector(mode="list", length=length(Pls))
    for (j in 1:length(Pls)) {
      crds <- slot(Pls[[j]], "coords")
      crds_s <- dp(list(x=crds[,1], y=crds[,2]), tolerance=tolerance)
      crds_s <- do.call("cbind", crds_s)
      if(!identical(crds_s[1,], crds_s[nrow(crds_s),]))
        crds_s <- rbind(crds_s, crds_s[1,])
      Pls_dp[[j]] <- Polygon(crds_s)
    }
    Keep <- logical(length(Pls_dp))
    for (j in 1:length(Pls_dp)) {
      Keep[j] <- TRUE
      if (slot(Pls_dp[[j]], "area") < minarea) Keep[j] <- FALSE
    }
    Pls_dp <- Pls_dp[Keep]
    pls_dp[[i]] <- Polygons(Pls_dp, ID=slot(pls[[i]], "ID"))
  }
  SP_dp <- SpatialPolygons(pls_dp, proj4string=slot(SP, "proj4string"))
  if(inherits(SP, "SpatialPolygonsDataFrame")) {
    data <- slot(SP, "data")
    SP_dp <- SpatialPolygonsDataFrame(SP_dp, data=data)
  }
  SP_dp
}

# Define function for printing nice html tables
prettify <- function (the_table, remove_underscores_columns = TRUE, cap_columns = TRUE, 
                      cap_characters = TRUE, comma_numbers = TRUE, date_format = "%B %d, %Y", 
                      round_digits = 2, remove_row_names = TRUE, remove_line_breaks = TRUE, 
                      data_table = TRUE, nrows = 5, download_options = TRUE) 
{
  column_names <- names(the_table)
  the_table <- data.frame(the_table)
  names(the_table) <- column_names
  classes <- lapply(the_table, function(x) {
    unlist(class(x))[1]
  })
  if (cap_columns) {
    names(the_table) <- Hmisc::capitalize(names(the_table))
  }
  if (remove_underscores_columns) {
    names(the_table) <- gsub("_", " ", names(the_table))
  }
  for (j in 1:ncol(the_table)) {
    the_column <- the_table[, j]
    the_class <- classes[j][1]
    if (the_class %in% c("character", "factor")) {
      if (cap_characters) {
        the_column <- as.character(the_column)
        the_column <- Hmisc::capitalize(the_column)
      }
      if (remove_line_breaks) {
        the_column <- gsub("\n", " ", the_column)
      }
    }
    else if (the_class %in% c("POSIXct", "Date")) {
      the_column <- format(the_column, format = date_format)
    }
    else if (the_class %in% c("numeric", "integer")) {
      the_column <- round(the_column, digits = round_digits)
      if (comma_numbers) {
        the_column <- scales::comma(the_column)
      }
    }
    the_table[, j] <- the_column
  }
  if (remove_row_names) {
    row.names(the_table) <- NULL
  }
  if (data_table) {
    if (download_options) {
      the_table <- DT::datatable(the_table, options = list(pageLength = nrows, 
                                                           dom = "Bfrtip", buttons = list("copy", "print", 
                                                                                          list(extend = "collection", buttons = "csv", 
                                                                                               text = "Download"))), rownames = FALSE, extensions = "Buttons")
    }
    else {
      the_table <- DT::datatable(the_table, options = list(pageLength = nrows, 
                                                           columnDefs = list(list(className = "dt-right", 
                                                                                  targets = 0:(ncol(the_table) - 1)))), rownames = FALSE)
    }
  }
  return(the_table)
}