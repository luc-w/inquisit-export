wd <- getwd() # get working directory
dirs <- list.dirs() # get list of directories withing working directory

for (i in 1:length(dirs)) {
  
  temp <- list.files(path = dirs[i] , pattern = "*.iqdat") # get list of .iqdat-files within the current directory
  
  valid <- identical(temp, character(0)) | # check if directory is empty (of .iqdat-files) or
                     length(temp) == 1               # or if there is only a single files (which is likely some summary file)
  
  # if directory contains .iqdat files, join and export them as .csv-files
  if (valid == 0) {
    
  list_files <- lapply(paste0(dirs[i], "/", temp), read.delim, stringsAsFactors = F) # import all files in a list
  dat <- do.call(rbind, list_files) # bind elements of the file list to a data.frame
  
    if (grepl("survey", dirs[i])){ # check if data stems from a "survey" (type of inquisit study)
      filename <- paste0(sub("/", "_", sub("/", "_", sub("./", "", dirs[i]))), ".csv") # set file name for survey data
    } else {
      filename <- paste0(sub("/", "_", sub("./", "", dirs[i])), ".csv") # set file name for experiment data
    }
    
  write.csv2(dat, file = paste0(wd, "/", filename), row.names = FALSE) # export data.frame to working directory       
  print(paste0("Files in", dirs[i], " joined and exported."))
  
  # if directory contains <= 2 .iqdat-files, print note and proceed with next directory
  } else {
    
    print(paste("Directory", "'", dirs[i], "' is empty or only contains a single .iqdat-file."))
    
  }

}