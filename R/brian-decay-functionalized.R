library(dplyr)
library(ggplot2)
library(magrittr)
library(purrr)

try_to_decay_a_particle <- function(particle) {
  decay_probability <- 0.5
  does_particle_decay <- (runif(1, 0, 1) >= decay_probability)
  if (particle == 0 && does_particle_decay) {
    particle <- 1L
  }
  return (particle)
}

try_to_decay_particles <- function (particles) {
  decay_probability <- 0.5
  does_particle_decay <- (runif(particles, 0, 1) >= decay_probability)
  particles[particles == 0 & does_particle_decay] <- 1
  return (particles)
}

# myData[myData$thing == 0]
# with(myData, )

evolve_system <- function (particles, decay_data, time_step, maximum_time) {
  if (time_step > maximum_time) {
    return (decay_data)
  } else {
    evolved_particles <- try_to_decay_particles(particles)
    percent_decayed <- mean(evolved_particles) * 100
    percent_remaining <- 100 - percent_decayed
    return (
      evolve_system(
        evolved_particles,
        decay_data %>% rbind(c(time_step + 1, percent_decayed, percent_remaining)),
        time_step + 1,
        maximum_time
      )
    )
  }
}

result <- evolve_system(
  particles = rep(0L, 10000L),
  decay_data = tibble::tribble(
    ~time, ~percentage_decayed, ~percentage_remaining,
    0, 0, 100
  ),
  time_step=0,
  maximum_time = 10
)

graph_decay_data <- function(decay_data) {
  ggplot(data=decay_data) +
    geom_line(
      aes(
        x=time,
        y=percentage_decayed
      )
    ) +

    geom_line(
      aes(
        x = time,
        y = percentage_remaining
      ),
      color='red'
    ) +

    theme_bw() +

    labs(title = "TITLE",
         subtitle = "Sub",
         caption = "source: original data",
         x = "Time",
         y = "Percent of Original Sample")

}

result # %>% graph_decay_data()

# To simulate radioactivity
#   start with some particles
#   decay those particles over time
#   graph the decay over time

# To decay particles over time
#   remember the particles' initial state
#   for each time step
#     compute which particles have decayed
#     update the decay data with the time step number, percent decayed, and percent remaining
#     carry forward the decay data and particles collection

