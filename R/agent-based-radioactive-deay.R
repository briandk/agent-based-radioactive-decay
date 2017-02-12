library(purrr)
library(magrittr)
library(ggplot2)

particles <- rep(0L, 10000)
time <- 0
decay_data <- tibble::tribble(
  ~time, ~percent_decayed, ~percent_remaining,
  0, 0, 100
)

while (time <= 10) {
  particles <- map_int(particles, function(particle) {
    decay_probability <- 0.5
    does_particle_decay <- (runif(1, 0, 1) >= 0.5)
    if (particle == 0 && does_particle_decay) {
      particle <- 1L
    }
    return (particle)
  })
  percent_decayed <- particles %>% mean() * 100
  percent_remaining <- 100 - percent_decayed

  time <- time + 1
  decay_data <- rbind(decay_data, c(
    time,
    percent_decayed,
    percent_remaining))

  message(particles %>% mean())
}

ggplot(data=decay_data) +
  geom_line(
    aes(
      x=time,
      y=percent_decayed
    )
  ) +

  geom_line(
    aes(
      x = time,
      y = percent_remaining
    ),
    color='red'
  ) +

  theme_bw() +

  labs(title = "TITLE",
       subtitle = "Sub",
       caption = "source: original data",
       x = "Time",
       y = "Percent of Original Sample")




