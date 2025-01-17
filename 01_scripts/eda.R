
library(tidyverse)
library(glue)

df <- haven::read_dta("02_outputs/data.dta")

df <- df |> 
  filter(year >= 1889)

g1 <- df |> 
  ggplot() +
  aes(x = v2xel_frefair) +
  geom_histogram(
    bins = nclass.Sturges(df$v2xel_frefair),
    colour = "black",
    fill = "royalblue"
  ) +
  theme_classic() +
  labs(
    title = "Clean Election Index in Brazil (V-DEM)",
    x = "",
    y = ""
  )

g1

mean_latam <- df |> 
  summarise(mean = mean(v2xel_frefair, na.rm = TRUE)) |> 
  pull(mean)

mean_brazil <- df |>
  filter(country_name == "Brazil") |> 
  summarise(mean = mean(v2xel_frefair, na.rm = TRUE)) |> 
  pull(mean)

g2 <- df |> 
  filter(country_name == "Brazil") |> 
  ggplot() +
  aes(x = v2xel_frefair) +
  geom_density(
    color = "black",
    fill = "royalblue",
    alpha = 0.5
  ) +
  geom_vline(xintercept = mean_brazil, colour = "royalblue", size = 1) +
  geom_vline(xintercept = mean_latam, linetype = "dashed") +
  theme_bw() +
  labs(
    title = "Distribution of Clean Election Index in Brazil (V-DEM)",
    x = "",
    y = "",
    fill = "Country"
  ) +
  theme(
    title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12),
  ) +
  annotate(
    "text", 
    x = 0.43, 
    y =1.3,
    label = glue("Brazil Average: {round(mean_brazil, 2)}"), 
    color = "royalblue",
    hjust = 0,
    size = 6
  ) +
  annotate(
    "text", 
    x = 0.09, 
    y =1.5,
    label = glue("Latam Average: {round(mean_latam, 2)}"), 
    color = "black",
    hjust = 0,
    size = 6
  )
g2

time_points <- df |> 
  filter(country_name == "Brazil") |> 
  count(year) |> 
  summarise(total = sum(n)) |> 
  pull(total)

df |> 
  filter(country_name == "Brazil") |> 
  summarise(
    mean = mean(v2xel_frefair),
    median = median(v2xel_frefair),
    sd = sd(v2xel_frefair),
    min = min(v2xel_frefair), 
    max = max(v2xel_frefair)
    )

g3 <- df |> 
  filter(country_name == "Brazil") |> 
  ggplot() +
  aes(x = year, y = v2xel_frefair) +
  geom_line(
    size = 1,
    color = "royalblue"
  ) +
  geom_point(
    color = "royalblue"
  ) +
  theme_bw() +
  labs(
    title = "Clean Election Index in Brazil (V-DEM) over time (1889 - 2023)",
    x = "",
    y = ""
  ) +
  scale_x_continuous(
    breaks = seq(1880, 2023, by = 20)
  ) +
  theme(
    title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(size = 12),
    axis.text.y = element_text(size = 12)
  ) +
  annotate(
    "text", 
    x = 2000, 
    y =1,
    label = glue("Time points: {time_points}"), 
    color = "black",
    hjust = 0,
    size = 6
  )
g3

ggsave(
  filename = "02_outputs/g1.png",
  plot = g1,
  width = 8,
  height = 6,
  dpi = 800
)

ggsave(
  filename = "02_outputs/g2.png",
  plot = g2,
  width = 10,
  height = 8,
  dpi = 800
)

ggsave(
  filename = "02_outputs/g3.png",
  plot = g3,
  width = 12,
  height = 6,
  dpi = 800
)

