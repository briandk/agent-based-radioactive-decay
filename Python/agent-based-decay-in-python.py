import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import seaborn as sns

time_steps = np.linspace(
    start = 1,
    stop = 10,
    num = 10
)

particles = pd.Series(
    np.zeros(10000)
)

decay_data = pd.DataFrame({
    'time_step': [0],
    "percent_decayed": [0],
    "percent_remaining": [100]
})

def try_to_decay (particle):
    decay_probability = 0.5
    does_particle_decay = np.random.random() > decay_probability
    
    if (particle == 0 and does_particle_decay):
        particle = 1
        
    return particle

def evolve_system (particles):
    return particles.map(try_to_decay)

for time_step in time_steps:
    particles = evolve_system(particles)
    percent_decayed = particles.mean() * 100
    new_data = pd.DataFrame(
        {
            'time_step': [time_step],
            'percent_decayed': percent_decayed,
            'percent_remaining': (100 - percent_decayed)
        },
        index = [0]
    )
    
    decay_data = decay_data.append(new_data)

plt.plot(
    decay_data.time_step,
    decay_data.percent_decayed,
    decay_data.time_step,
    decay_data.percent_remaining
)

plt.show()
