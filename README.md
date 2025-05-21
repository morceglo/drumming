# Drumming-in-disk-winged-bats

## Title of project
Drumming as a potential defense strategy against roost intruders in disk-winged bats

## Authors
Gloriana Chaverri, Ana María Ávila-García, José Gabriel Tinajero-Romero, Silvia Chaves-Ramírez

## General info
In this study, we documented and experimentally characterized a novel drumming behavior in the disk-winged bat (Thyroptera tricolor), showing that it is triggered primarily by interspecific intrusions. We quantified its occurrence, acoustic properties, and individual variation, proposing that drumming serves as a context-specific antipredator strategy. 

## Data
* [General data on drumming behavior](https://github.com/morceglo/drumming/blob/main/data.xlsx)
This dataset represents observations of drumming behavior summarized per individual tested and trial. Key to listed variables: group = identity of social group, bat_id = last 4 digits of the RFID tag for each bat, trial = represents either the first or second trial in which we measured drumming behavior, sex = sex of the tested individual, time_drumming = total time the bat spent drumming within each trial, max_amp = average of maximum amplitude for all identified drumming events per trial (in dBFS), mean_amp = average of mean amplitude for all identified drumming events per trial (in dBFS).

* [Drumming sounds](https://github.com/morceglo/drumming/blob/main/drumming_sounds.xlsx)
This dataset represents values of measured sound parameters for each drumming bout detected per individual. Key to listed variables: label = the identity of each drumming bout within a given trial, bat_id = last 4 digits of the RFID tag for each bat, max = peak amplitude at the maximum amplitude of the element (dBFS), mean = peak amplitude at mean spectrum of the entire element (dBFS), trial = represents either the first or second trial in which we measured drumming behavior.

* [Data for drumming-vocal behavior](https://github.com/morceglo/drumming/blob/main/seltab_expe.txt)
Key to listed variables: video = video record identification number, sound = if bat was vocal or no vocal during behavior, Behavior = if bat did drumming or no drumming behavior, bat_id = unique identifier of individuals.

* [Selection tables](https://github.com/morceglo/territoriality-in-disc-winged-bats/blob/main/leaves_inHR.csv)
Folder containing the selection tables extracted from each video analysed in Raven. Each selection table contains the acoustic parameters of the selection and the determination made of vocalization and behaviour.
Key to listed variables:
Selection = Number of the selection   
View = Type of visualization used: spectrogram or oscillogram
Channel = Recording channel (1 or 2)
Begin Time (s) = beginning time in seconds of the vocalization
End Time (s) = end time in seconds of the vocalization
Low Freq (Hz) = low frequency of the vocalization, in hertz
High Freq (Hz) = high frequency of the vocalization, in hertz
Center Freq (Hz) = represents the frequency, in hertz, at which the cumulative energy within a selection reaches 50%
Delta time (s) = duration in seconds of a selected sound segment, calculated as the difference between the selection's end time and start time
Inband Power (dB FS) = the total acoustic energy within a selected time-frequency region of a spectrogram, expressed in decibels relative to full scale (dB FS)
Tipo = Type of sound emitted (biophony, geophony, anthropophony). Note: All selected sounds were biophonic, so this column was not used in these tables.
Id = Species identifier. In all tables here, T. tricolor.
Determinación = Whether the bat vocalized or not (vocal the bat produced sounds or non-vocal no sounds produced) after named as "sound"
Comportamiento = Timing of the vocalization relative to drumming (before,during, after or no drumming). after named as "Behavior"
Calidad = quality of measured vocalization (medium, bad, good)

## Analyses

* [Statistical analyses](https://github.com/morceglo/drumming/blob/main/Drumming_analyses.R)
  

## Status
Project is: Manuscript under consideration in Animal Behaviour

## Contact
Created by [Gloriana_Chaverri](batcr.com/)
