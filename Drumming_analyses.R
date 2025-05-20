# Load libraries
library(readxl)
library(dplyr)
library(ggplot2)
library(lme4)
library(lmerTest)  # gives p-values
library(rptR)
library(tidyr)


# Load data
data <- read_excel("data.xlsx")

# Load detailed sound data
sound_data <- read_excel("drumming_sounds.xlsx")

# Create a lookup table of bat_id to sex (drop duplicates)
sex_lookup <- original_data %>%
  select(bat_id, sex) %>%
  distinct()

# Merge sex into the new sound data
merged_data <- sound_data %>%
  left_join(sex_lookup, by = "bat_id")

# Check the result
head(merged_data)

# Convert amplitude columns to numeric (force non-numeric to NA)
data <- data %>%
  mutate(
    max_amp = as.numeric(max_amp),
    mean_amp = as.numeric(mean_amp)
  )


# Summarize by sex
summary <- data %>%
  group_by(sex) %>%
  summarise(
    mean_time = mean(time_drumming, na.rm = TRUE),
    sd_time = sd(time_drumming, na.rm = TRUE),
    mean_max_amp = mean(max_amp, na.rm = TRUE),
    sd_max_amp = sd(max_amp, na.rm = TRUE),
    mean_mean_amp = mean(mean_amp, na.rm = TRUE),
    sd_mean_amp = sd(mean_amp, na.rm = TRUE),
    n = n()
  )

print(summary)

# Plot: Time spent drumming by sex
ggplot(data, aes(x = sex, y = time_drumming)) +
  geom_boxplot() +
  theme_minimal() +
  labs(y = "Time (s)", x = "Sex")

# Filter for amplitude data
amp_data <- data %>% filter(!is.na(max_amp))

# Plot: Max amplitude by sex
ggplot(amp_data, aes(x = sex, y = max_amp, fill = sex)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Max Amplitude by Sex", y = "Max Amplitude (dB)", x = "Sex")

# Plot: Mean amplitude by sex
ggplot(amp_data, aes(x = sex, y = mean_amp, fill = sex)) +
  geom_boxplot() +
  theme_minimal() +
  labs(title = "Mean Amplitude by Sex", y = "Mean Amplitude (dB)", x = "Sex")


#___________________________________________________________________
#Models


# Mixed model: Time spent drumming ~ sex + (1 | bat_id)
model_time <- lmer(time_drumming ~ sex + (1 | bat_id), data = data)
summary(model_time)

# Check assumptions for time model
par(mfrow = c(2, 2))
plot(model_time)  # residuals vs. fitted, scale-location
qqnorm(resid(model_time))
qqline(resid(model_time))

# Add a small constant to avoid log(0)
data <- data %>%
  mutate(log_time_drumming = log(time_drumming + 0.01))

# Refit model with log-transformed response
model_log_time <- lmer(log_time_drumming ~ sex + (1 | bat_id), data = data)
summary(model_log_time)

# Check assumptions again
par(mfrow = c(2, 2))
plot(model_log_time)
qqnorm(resid(model_log_time))
qqline(resid(model_log_time))

# Run repeatability analysis
rpt_result <- rpt(log_time_drumming ~ sex + (1 | bat_id), 
                  grname = "bat_id", 
                  data = data, 
                  datatype = "Gaussian", 
                  nboot = 1000, npermut = 0)

summary(rpt_result)


# Max amplitude model
model_max <- lmer(max ~ sex + (1 | bat_id), data = merged_data)
summary(model_max)

# Check assumptions for max amplitude model
par(mfrow = c(2, 2))
plot(model_max)  # residuals vs fitted, scale-location, leverage
qqnorm(resid(model_max))
qqline(resid(model_max))

# Repeatability for max amplitude
rpt_max <- rpt(max ~ sex + (1 | bat_id), 
               grname = "bat_id", 
               data = merged_data, 
               datatype = "Gaussian", 
               nboot = 1000, npermut = 0)
summary(rpt_max)

# Max amplitude boxplot
ggplot(merged_data, aes(x = sex, y = max, fill = sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.2, alpha = 0.5) +
  theme_minimal() +
  labs(title = "Max Amplitude by Sex", y = "Max Amplitude (dB)", x = "Sex")



# Mean amplitude model
model_mean <- lmer(mean ~ sex + (1 | bat_id), data = merged_data)
summary(model_mean)

# Check assumptions for mean amplitude model
par(mfrow = c(2, 2))
plot(model_mean)
qqnorm(resid(model_mean))
qqline(resid(model_mean))

# Repeatability for mean amplitude
rpt_mean <- rpt(mean ~ sex + (1 | bat_id), 
                grname = "bat_id", 
                data = merged_data, 
                datatype = "Gaussian", 
                nboot = 1000, npermut = 0)
summary(rpt_mean)

# Mean amplitude boxplot
ggplot(merged_data, aes(x = sex, y = mean, fill = sex)) +
  geom_boxplot() +
  geom_jitter(width = 0.2, alpha = 0.5) +
  theme_minimal() +
  labs(title = "Mean Amplitude by Sex", y = "Mean Amplitude (dB)", x = "Sex")


#------------------------------ Behavior-vocal analysis -------------------------------------------

# install/ load packages
sketchy::load_packages(packages = c("Rraven","readxl","dplyr","tidyr", "purrr", "stringr"))

# Import the experiment dataset
expe <- read_excel("./Datos(Hoja1).xlsx")

# Import selection tables from Raven software
seltab <- imp_raven(
    path = "./SELTABLE",
    warbler.format = FALSE,
    all.data = TRUE,
    only.spectro.view = TRUE,
    recursive = FALSE,
    name.from.file = TRUE,
    ext.case = 'upper',
    parallel = 1,
    pb = TRUE
)


# Inspect the structure of the imported data
str(seltab)

seltab <- seltab %>%
    # Eliminar columnas Tipo e Id 
    select(-Tipo, -Id) %>%
    # Renombrar la columna sound.files a video
    rename(Video = sound.files) %>%
    # Quitar todo después del primer punto en video
    mutate(Video = str_extract(Video, "^[^\\.]+")) %>%
    #cambiar nombre de determinación para que no genere problema
    rename(sound = Determinaci\xf3n)


seltab <- seltab %>% filter(!is.na(video)) # Remove rows where video is NA

# Merge experiment dataset with selection table
# Keeping all rows from the experiment dataset
merged_data <- merge(seltab, expe, by.y = 'Video', all.y = TRUE)

write.csv(merged_data, "seltab_expe.csv", row.names = FALSE)

# Load data (adjust the path according to your file)
data <- read.table("C:...seltab_expe.txt", header = TRUE, sep = "\t")


# Load data (adjust the path according to your file)
data <- read.table("C:/Users/Cable/OneDrive - Pontificia Universidad Católica del Ecuador/Documents/UCR/Chaverri Lab/drumming/seltab_expe.txt", header = TRUE, sep = "\t")

# Filter rows with NA in key columns and convert to factors
data_clean <- data %>%
  filter(!is.na(Behavior), !is.na(sound)) %>%
  mutate(
    Behavior = as.factor(Behavior),
    sound = as.factor(sound),
    bat_id = as.factor(bat_id)
  )

# Contingency table between Behavior and sound
table(data_clean$Behavior, data_clean$sound)

# Frequency per bat_id
table(data_clean$bat_id)

# Fit the model
modelo <- glmer(
  sound ~ Behavior + (1 | bat_id),  # Model structure
  data = data_clean,
  family = binomial(link = "logit"),     # Binomial for presence/absence
  control = glmerControl(optimizer = "bobyqa")
)

# Model summary
summary(modelo)

# Convert "no vocal" to 0, "vocal" to 1
data_clean$sound_numeric <- ifelse(data_clean$sound == "vocal", 1, 0)

# Repeatability analysis for vocal drumming
rpt_drumming <- rpt(
  sound_numeric ~ Behavior + (1 | bat_id), 
  grname = "bat_id", 
  data = data_clean, 
  datatype = "Binary", 
  nboot = 1000, 
  npermut = 0
)

# View results
summary(rpt_drumming)
