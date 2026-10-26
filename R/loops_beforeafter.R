
# This loop aims to : 
  # 1. handle missing data by imputation
  # 2. create new column for every imputed variable 
  # 3. count NA value before and after imputation
  # 4. display before and after plot


File <- read.table("yourdata.csv", sep = ",", header= TRUE)

# Assign which columns we want to iterate. This assumes they are continuous
start <- which(names(File) == "col_name1")
end <- which(names(File) == "col_name2")

for (i in start:end){
  
  # assign name for imputed variable (ex : "Heightimp") 
  imp <- paste0(names(File)[i], "imp")
  
  # replace NA with 0 and store them in a new column
  File[[imp]] <- replace_na(File[[i]], 0)
  
  # before after NA counts
  cat(
    "Variable :", names(File)[i], "\n",
    "No of NA before: ", sum(is.na(File[[i]])), "\n", 
    "No of NA after: ", sum(is.na(File[[imp]])), "\n"
  )
  
  # before and after plot 
  boxplot(
    File[[i]], 
    File[[imp]], 
    names = c("Original data", "NA replaced with 0"), 
    main = names(File)[i]
  )
} 
