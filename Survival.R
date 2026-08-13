# ---------------------------------------------------------------------
# 6.  Optional: time to implant loss - Kaplan-Meier and log-rank
# ---------------------------------------------------------------------
# A closed cohort: forty patients with a short posterior maxilla, all
# operated at time zero, twenty with a short implant and twenty with a
# long implant plus sinus lift, then followed for up to five years.
# months = time under observation; lost = 1 means the implant was lost
# at that time, lost = 0 means the patient was still event-free when we
# last saw them (censored: moved away, or the study simply ended at 60).

implants <- data.frame(
  patient = 1:40,
  group   = rep(c("short implant", "long + sinus lift"), each = 20),
  months  = c( 8, 14, 20, 28, 40, 12, 24, 36, 60, 60,
              60, 60, 60, 60, 60, 60, 60, 60, 60, 60,
              24, 48, 18, 30, 44, 60, 60, 60, 60, 60,
              60, 60, 60, 60, 60, 60, 60, 60, 60, 60),
  lost    = c( 1,  1,  1,  1,  1,  0,  0,  0,  0,  0,
               0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
               1,  1,  0,  0,  0,  0,  0,  0,  0,  0,
               0,  0,  0,  0,  0,  0,  0,  0,  0,  0))

View(implants)                   # opens the data like an Excel sheet -
                                 # one row per patient, read a few rows
                                 # and say out loud what each one means

library(survival)                # comes with R, nothing to install

fit <- survfit(Surv(months, lost) ~ group, data = implants)

plot(fit, col = c("blue", "red"), lwd = 2, ylim = c(0.5, 1),
     mark.time = TRUE,           # draw a tick at every censored patient
     xlab = "months since surgery", ylab = "implant survival")
legend("bottomleft", c("long + sinus lift", "short implant"),
       col = c("blue", "red"), lwd = 2)
# Every step down is a lost implant; the little ticks are censored
# patients - they leave the curve without pulling it down. At five
# years: 89% vs 73%.

survdiff(Surv(months, lost) ~ group, data = implants)   # log-rank test
# p = 0.2. The curves LOOK different, and the test says: with 5 losses
# against 2, chance alone produces a gap this size about once in five
# studies. 