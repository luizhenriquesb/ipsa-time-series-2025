
# 1. Library --------------------------------------------------------------

library(tidyverse)
library(devtools)
library(vdemdata)
library(janitor)

# 2. Import ---------------------------------------------------------------

# V-DEM dataset
df <- as_tibble(vdemdata::vdem)

# V-DEM codebook
codebook <- vdemdata::codebook |> as_tibble()

# 3. Transform ------------------------------------------------------------

latin_american_countries <- c(
  "Argentina", "Bolivia", "Brazil", "Chile", "Colombia", "Costa Rica", 
  "Cuba", "Dominican Republic", "Ecuador", "El Salvador", "Guatemala", 
  "Honduras", "Mexico", "Nicaragua", "Panama", "Paraguay", "Peru", 
  "Uruguay", "Venezuela"
)

# Filtering only latin american countries
df <- df |> 
  filter(country_name %in% latin_american_countries) 

df |> 
  distinct(country_name)

# 4. Select variables -----------------------------------------------------

glimpse(df)

codebook |> 
  filter(str_detect(name, "[Pp]ola|[Ii]nfla")) |> 
  select(name, tag, question)

codebook |> 
  filter(str_detect(name, "Elect")) |> 
  select(name, tag, question)

df <- df |> 
  select(
    country_name,
    year,
    # To what extent are elections free and fair?
    v2xel_frefair
  )

summary(df['v2xel_frefair'])

# 5. Exporting ------------------------------------------------------------

write_csv(
  x = df,
  file = "02_outputs/data.csv"
)

haven::write_dta(
  data = df,
  path = "02_outputs/data.dta"
)

df <- df |> 
  filter(country_name == "Brazil", year >= 1889)

haven::write_dta(
  data = df,
  path = "02_outputs/datav2.dta"
)


