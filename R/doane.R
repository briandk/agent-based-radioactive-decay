library(dplyr)
library(ggplot2)
library(magrittr)
library(purrr)

next_gen <-
  function(particles) {
    particles + runif(length(particles), 0, 1) %>%
      round
  }

particles <- rep(0, 10000)

for (i in 1:10) {
  particles <- next_gen(particles) %>% pmin(1)
  message(particles)
  message(sum(particles), "... ", mean(particles))
}

