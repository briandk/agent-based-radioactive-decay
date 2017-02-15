library(magrittr)
library(tidyverse)

time_steps <- 1:10
particles <- rep(0, 10000)
decay_data <- tibble::tribble(
  ~time_step, ~percent_decayed, ~percent_remaining,
  0, 0, 100
)

try_to_decay_a_particle <- function(particle) {
  decay_probability <- 0.5
  does_particle_decay <- (runif(1, 0, 1) >= decay_probability)
  if (particle == 0 & does_particle_decay) {
    particle <- 1
  }
  return (particle)
}

for (time_step in time_steps) {
  particles <- map_dbl(particles, try_to_decay_a_particle)
  percent_decayed <- mean(particles) * 100
  decay_data %<>% rbind(
    c(time_step, percent_decayed, 100 - percent_decayed)
  )
}

print(decay_data)