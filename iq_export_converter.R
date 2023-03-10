wd <- getwd() # get working directory
dirs <- list.dirs() # get list of directories withing working directory

for(i in 1:length(dirs)){
  
  temp <- list.files(path = dirs[i] , pattern = "*.iqdat") # get list of .iqdat-files within the current directory
  
  check_invalid <- identical(temp, character(0)) | # check if directory is empty (of .iqdat-files) or
                    length(temp) == 1               # or if there is only a single files (which is likely some summary file)
  
  # if directory contains .iqdat files, join and export them as .csv-files
  if(check_invalid == 0) {
    
  list_files <- lapply(paste0(dirs[i], "/", temp), read.delim, stringsAsFactors = F) # import all files in a list
  dat <- do.call(rbind, list_files) # bind elements of the file list to a data.frame
  filename <- paste0(gsub("./", "", dirs[i]), ".csv") # define file name for new data.frame
  write.csv2(dat, file = paste0(wd, "/", filename), row.names = FALSE) # export data.frame to working directory       
        
  print(paste0("Files in", dirs[i], " joined and exported."))
  
  # if directory contains <= 2 .iqdat-files, print note and proceed with next directory
  } else {
    
    print(paste("Directory", "'", dirs[i], "' is empty or only contains a single .iqdat-file."))
    
  }

}

