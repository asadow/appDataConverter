library(readxl)
library(dplyr)
library(janitor)
library(tidyr)
library(stringr)

sitenumber <- read_excel("data-raw/site-numbers_2022-10-05.xls", skip = 2)

sitenumber <- sitenumber |>
  clean_names() |>
  separate(
    col = site_name,
    into = c("bldg_no", "bldg_name"),
    sep = "-",
    extra = "drop",
    fill = "right",
    remove = FALSE) |>
  # Some rows do not have a building number preceded by BLDG
  mutate(bldg_no = str_extract(bldg_no, "\\d+") |> as.numeric())

usethis::use_data(sitenumber, overwrite = TRUE)
