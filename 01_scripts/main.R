
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

# Brazil's inflation
inflation <- readxl::read_xls(
  "00_data/ipca_202412SerieHist.xls",
  skip = 6
) |> clean_names()

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

# Remove the first line because it is null
inflation <- inflation[-1,]

# Adjusting columns names in inflation df
inflation

colnames(inflation)[1] <- "year"
colnames(inflation)[2] <- "month"
colnames(inflation)[3] <- "num_index"

# Selecting the columns of interest
inflation <- inflation |> 
  select(
    year,
    month,
    annual_rate = ano
  )

# Drop the NA values and change the type of columsn annual_rate
inflation <- inflation |> 
  drop_na(annual_rate) |> 
  mutate(annual_rate = as.numeric(annual_rate)) |> 
  drop_na(annual_rate)

inflation <- inflation |> 
  fill(year, .direction = "down")

inflation <- inflation |> 
  filter(month == "DEZ")

inflation <- inflation |> 
  mutate(year = as.numeric(year))

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
    year,
    historical_date,
    #v2smpolsoc, 
    #v2cacamps, 
    #e_miinflat,
    #v2x_libdem,
    
    # Was this national election multiparty?
    v2elmulpar,
    
    # In this national election, was there evidence of vote and/or turnout 
    # buying? 
    v2elvotbuy,
    
    # Which of the following best describes the nature of electoral support 
    # for major parties (those gaining over 10 % of the vote)?
    v2pscomprg,   
    
    # Is there any (institutionalized) political competition?
    e_polcomp,
    
    # Were there allegations of significant vote-fraud by any Western monitors?
    v2elwestmon,
    
    # To what extent are elections free and fair?
    v2xel_frefair,
    
    # Does the Election Management Body (EMB) have autonomy from government to apply
    # election laws and administrative rules impartially in national elections?
    v2elembaut,
    
    country_name
  )

summary(df['v2elmulpar'])

# 5. Joins ----------------------------------------------------------------

df |> arrange(desc(year)) |> print(n=100)
# inflation |> arrange(desc(year)) |> print(n=50)

data <- left_join(
  x = df,
  y = inflation,
  by = "year"
) |> 
  arrange(desc(year)) 

data |>
  select(year, historical_date, v2elembaut, v2xel_frefair, v2pscomprg) |> 
  arrange(desc(year)) |> print(n=100)

# 6. Exploratory Data Analysis --------------------------------------------

data |> 
  ggplot() +
  aes(x = v2pscomprg, y = v2xel_frefair) +
  geom_jitter() +
  geom_smooth(method = lm) +
  theme_classic()

data |> 
  #filter(year > 1990) |> 
  ggplot() +
  aes(x = historical_date, y = v2pscomprg) +
  geom_line() +
  theme_classic()

data |> 
  #filter(year > 1990) |> 
  ggplot() +
  aes(x = historical_date, y = v2xel_frefair) +
  geom_line() +
  theme_classic()

model <- lm(
  v2xel_frefair ~ v2pscomprg + v2elembaut, data = data
)

summary(model)

#usethis::use_git()
#usethis::use_github()

write_csv(
  x = data,
  file = "02_outputs/data.csv"
)

haven::write_dta(
  data = data,
  path = "02_outputs/data.dta"
)

