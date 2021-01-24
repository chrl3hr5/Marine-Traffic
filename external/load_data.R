# Loading data (Converting "CSV" to "Feather" for fast loading)
if (file.exists("ships.csv")) {
  Data <- fread("ships.csv")
  write_feather(Data, "ships.feather")
  Data <- read_feather("ships.feather")
  file.remove("ships.csv")
} else {
  Data <- read_feather("ships.feather")
}