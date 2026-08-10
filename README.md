# Syllabus

## Studiendesign und Statistik** — three sessions of 90 minutes.

Audience: dentists and dental researchers. No prior statistics, no prior programming.
Format: Day 1 is a lecture with quizzes. Days 2 and 3 are 60 minutes of lecture followed by
30 minutes of hands-on work in R.

For an introduction to R you may also want to refer to 
Yarr: The Pirates Guide to R’ by Nathaniel Phillips.
https://nathanieldphillips-yarrr.share.connect.posit.cloud/


## Day 1 · Clinical Epidemiology & Study Design

**By the end you should be able to**

- state a research question as an occurrence relation: outcome as a function of determinants
- distinguish prevalence, cumulative incidence and incidence rate, and say which one a paper is
  actually reporting
- calculate and interpret a relative risk, a risk difference and an attributable risk
- recognise each of the main designs from its description, and name what it can and cannot show
- explain why randomisation works, and what blinding adds on top of it
- separate selection bias, information bias and confounding, and say which one a given problem is
  

## Day 2 · Introduction to Biostatistics & Hands-on in R

**By the end you should be able to**

- name the scale of a variable and let it choose the summary and the test
- say what a standard deviation describes and what a standard error describes
- interpret a confidence interval
- state what a p-value asks and what it cannot answer
- pick the right test from the decision table for a two-group comparison
- read the output of `t.test`, `wilcox.test`, `chisq.test`, `fisher.test` and `power.t.test`
- explain why a split-mouth design settles with twelve patients what twenty could not


## Day 3 · Introduction to Resampling Statistics & Hands-on in R

**By the end you should be able to**

- explain what the classical tests assume and why those assumptions are artefacts of hand
  computation
- run a permutation test and say exactly what was reshuffled
- run a bootstrap and put a confidence interval on a statistic that has no formula — a median, a
  ratio, anything you can compute
- recognise clustered data (several teeth per patient) and handle it rather than ignore it
- turn a pilot study into a sample size, and see how uncertain that number is


## What to take away

1. Look at the data before you test it.
2. The scale of the outcome and the design pick the test. Nothing else does.
3. Report the effect with its confidence interval. A p-value alone tells the reader neither how
   large the difference is nor how precisely it was measured.
4. A non-significant result is not a negative result. It may mean no effect, or it may mean too
   few patients — only the interval distinguishes them.
5. Power is bought before the study, never calculated after it.
