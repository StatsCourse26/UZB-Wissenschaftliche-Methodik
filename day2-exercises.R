# =====================================================================
#  Wissenschaftliche Methodik 2026 - Day 2
#  Thirty minutes of hands-on
#
#  No data files and no packages: the numbers are the ones from the
#  lecture. Run it line by line (Ctrl/Cmd + Enter) and read the output
#  before moving on. Four tasks, marked ### YOUR TURN, with the answer
#  just below each.
# =====================================================================

# The twenty patients from the lecture: chronic periodontitis, ten per
# protocol, reduction in probing depth (mm) after six months. Fixed here
# so that everything you compute matches the slides.
a <- c(2.1, 2.9, 1.8, 3.0, 2.3, 1.4, 0.8, 3.4, 2.6, 1.9)   # protocol A
b <- c(1.6, 0.8, 2.1, 2.8, 1.7, 0.9, 0.1, 2.2, 1.5, 3.5)   # protocol B
a; b


# ---------------------------------------------------------------------
# 1.  Describe, and look
# ---------------------------------------------------------------------
mean(a); mean(b)                 # 2.22 and 1.72 mm
sd(a); sd(b)                     # 0.79 and 1.00 mm
median(a); median(b)             # 2.20 and 1.65 mm
IQR(a); IQR(b)                   # 1.00 and 1.13 mm, the middle half
sd(a) / sqrt(10)                 # standard error of the mean of a: 0.25
sd(b) / sqrt(10)                 # and of b: 0.31

boxplot(a, b, names = c("A", "B"), ylab = "reduction in probing depth (mm)")

### YOUR TURN
# Work out the 95% confidence interval for protocol A by hand, using
# mean +/- 1.96 * SEM, and compare it with what t.test(a) reports.

mean(a) + c(-1.96, 1.96) * sd(a) / sqrt(10)   # by hand

t.test(a)                        # look at the 95 percent interval it prints
# Ignore the rest of that output: with one group, t.test compares the
# mean against zero, and nobody asked whether protocol A does nothing at
# all. The interval is what we came for.
# By hand 1.73 to 2.71, from R 1.66 to 2.78 - a little wider, because R
# uses t for 9 df (2.262) instead of 1.96.


# ---------------------------------------------------------------------
# 2.  Look at the shape, then the t-test
# ---------------------------------------------------------------------
# Judge this by eye. The points should follow the straight line, and
# the box plot from task 1 should show no patient stranded on their own.
qqnorm(a, main = "Protocol A"); qqline(a)
qqnorm(b, main = "Protocol B"); qqline(b)

hist(a); hist(b)
# With ten patients a histogram is coarse - the Q-Q plot and the box
# plot carry more information here. All three agree: no long tail, no
# second peak, nobody far from the rest. A t-test is a fair choice.

t.test(a, b, var.equal = TRUE)

# Read it in this order: the two means (2.22 and 1.72 mm), the 95% CI of
# the difference, then t and df, and the p-value of 0.23 last. Twenty
# patients were not enough to settle it - the numbers from the lecture.

### YOUR TURN
# Run the same comparison as a split-mouth study, where both protocols
# are used in every patient. Why does the p-value fall so far?

# twelve mouths, side A against side B
left  <- c(2.4, 3.1, 2.0, 2.8, 1.9, 2.6, 3.0, 2.2, 2.5, 1.8, 2.7, 2.9)
right <- c(1.8, 2.2, 1.6, 2.5, 1.1, 2.1, 3.4, 1.0, 2.1, 1.8, 1.6, 1.3)
left - right                     # the only column the test uses
t.test(left, right, paired = TRUE)
# Mean difference 0.62 mm, t = 3.91 on 11 df, p = 0.0024. The same half
# millimetre or so, now clearly there: each patient is their own control,
# so the differences between patients drop out. Twelve mouths settled
# what twenty could not.


# ---------------------------------------------------------------------
# 3.  When the t-test does not apply
# ---------------------------------------------------------------------
# Money, not millimetres: what it cost to treat each patient (CHF).
# A few expensive patients drag the mean away from everyone else, so we
# compare ranks instead of means.
cost_a <- c(320, 410, 380, 450, 290, 510, 360, 430, 340, 620)
cost_b <- c(480, 700, 560, 640, 520, 880, 610, 750, 590, 1400)

median(cost_a); median(cost_b)   # 395 and 625 CHF
boxplot(cost_a, cost_b, names = c("A", "B"), ylab = "cost per patient (CHF)")

wilcox.test(cost_a, cost_b)      # W = 6, p = 0.0003: the two groups differ
# No two costs are the same, so R can give the exact p-value here. With
# tied values - a pain grade, say - it warns you and uses an approximation
# instead. Same conclusion, different route.

# Counts: complete denture, yes or no, in men and women over seventy.
tab <- matrix(c(10, 40, 38, 32), nrow = 2, byrow = TRUE)
dimnames(tab) <- list(sex = c("men", "women"), denture = c("yes", "no"))
tab
prop.table(tab, 1) * 100         # 20% of the men, 54% of the women
chisq.test(tab, correct = FALSE) # chi-square 14.29, p = 0.0002
# Compare $expected with tab: the four totals are unchanged, only the
# inside moves. Without correct = FALSE, R applies Yates' correction and
# prints 0.0003. The slide quotes the uncorrected value.
chisq.test(tab, correct = FALSE)$expected   # 20, 30, 28, 42

### YOUR TURN
# A small pilot: pulpal anaesthesia was achieved in 8 of 10 patients with
# articaine and in 3 of 10 with mepivacaine. The expected counts are 4.5
# and 5.5, so chi-square is out of its depth - use Fisher's exact test.

# rows: articaine, mepivacaine. columns: achieved, not achieved.
small <- matrix(c(8, 2, 3, 7), nrow = 2, byrow = TRUE)
small
fisher.test(small)               # p = 0.07: not enough patients to tell


# ---------------------------------------------------------------------
# 4.  How many patients would the next study need?
# ---------------------------------------------------------------------
# The formula needs the spread WITHIN a group, so average the two
# variances and take the square root. Not sd(c(a, b)): pouring the two
# groups into one vector adds the difference between them to the spread.
sigma <- sqrt((var(a) + var(b)) / 2)   # 0.90 mm

power.t.test(delta = 0.5, sd = sigma, sig.level = 0.05, power = 0.80)
# 52 per group - the 51 from the lecture, give or take the rounding.

### YOUR TURN
# What power did ten per group have against a difference of 0.5 mm?
# And how many patients would you need if you halved that difference?

power.t.test(n = 10, delta = 0.5, sd = sigma)
# power = 0.22. Ten per group had roughly a one-in-five chance of finding
# 0.5 mm even if it was really there - which is why the comparison in
# task 2 came back at p = 0.23. The study was too small before it began,
# and no analysis afterwards can repair that.
# Note what this is NOT: 0.5 mm is the difference we decided in advance
# was worth finding, not the 0.50 mm the study happened to produce.
# Power computed from your own result tells you nothing you do not
# already know from the p-value.

power.t.test(delta = 0.25, sd = sigma, power = 0.80)
# 204 per group, against 52 for the full 0.5 mm. Halving the difference
# quadruples the study: it sits squared in the denominator of the formula.
