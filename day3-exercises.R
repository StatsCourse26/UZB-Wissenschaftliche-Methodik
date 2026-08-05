# ==================================================================
#  Day 3 - Resampling: hands-on
#  Base R only. Nothing to download.
#  Put the cursor on a line and press Ctrl+Enter (Mac: Cmd+Enter).
# ==================================================================


# ---- 0. Make the data --------------------------------------------
#  Just run this block. It invents 20 patients so that we have
#  something to work with. How it works is a topic for another day.

set.seed(2026)

group <- rep(c("diabetes", "control"), each = 10)
true_depth <- c(rnorm(10, mean = 3.4, sd = 0.35),   # 10 with diabetes
                rnorm(10, mean = 2.8, sd = 0.35))   # 10 without

site1 <- round(true_depth + rnorm(20, 0, 0.30), 1)  # four sites around
site2 <- round(true_depth + rnorm(20, 0, 0.30), 1)  # one tooth,
site3 <- round(true_depth + rnorm(20, 0, 0.30), 1)  # probing depth in mm
site4 <- round(true_depth + rnorm(20, 0, 0.30), 1)

cost <- round(rlnorm(20, log(280), 0.55), -1)       # in CHF

d <- data.frame(patient = 1:20, group, site1, site2, site3, site4, cost)


# ---- 1. Look at it -----------------------------------------------

d                 # 20 rows: small enough to print the whole table
View(d)           # or open it as a spreadsheet - capital V

table(d$group)    # 10 patients in each group

# View() is a viewer, not an editor. You change data in the script,
# never in that window.


# ---- 2. One number per patient -----------------------------------
# The deepest of the four sites is what decides the treatment.

d$depth <- pmax(d$site1, d$site2, d$site3, d$site4)

d                 # a new column on the right - check a row by eye

a <- d$depth[d$group == "diabetes"]     # the 10 diabetic patients
b <- d$depth[d$group == "control"]      # the 10 others

mean(a)                # 3.54
mean(b)                # 3.03
mean(a) - mean(b)      # 0.51 mm deeper

boxplot(depth ~ group, data = d, ylab = "deepest pocket (mm)")


# ---- 3. Permutation test -----------------------------------------
# Question: could chance alone produce a gap of 0.51 mm?

obs  <- mean(a) - mean(b)     # the number we have to judge
pool <- c(a, b)               # all 20 patients, labels thrown away

# One shuffle: pick 10 of the 20 at random, call them "diabetes",
# and see what difference comes out.
i <- sample(20, 10)
mean(pool[i]) - mean(pool[-i])       # pool[-i] means "all the others"

# Now do that 10 000 times and keep every answer.
diffs <- replicate(10000, {
  i <- sample(20, 10)
  mean(pool[i]) - mean(pool[-i])
})

hist(diffs, breaks = 40, xlab = "difference in mm",
     main = "What chance alone produces")
abline(v = obs, col = "red", lwd = 2)

mean(abs(diffs) >= abs(obs))     # the p-value  ->  0.008

# The classical test, for comparison:
t.test(depth ~ group, data = d)  # p = 0.012
# It prints -0.51 because R puts "control" first. Same difference.


# ---- 4. Bootstrap -------------------------------------------------
# Question: the median cost is 235 CHF - how precise is that?

hist(d$cost, breaks = 12, xlab = "CHF", main = "Cost per patient")
mean(d$cost)          # 316  - dragged up by a few expensive patients
median(d$cost)        # 235  - the typical patient

# One redraw: 20 patients drawn from our 20, with repeats allowed.
median(sample(d$cost, 20, replace = TRUE))

# Now 10 000 redraws, and the middle 95% of the answers.
meds <- replicate(10000, median(sample(d$cost, 20, replace = TRUE)))

quantile(meds, c(0.025, 0.975))      # 160 to 380 CHF

hist(meds, breaks = 40, xlab = "CHF", main = "10 000 bootstrap medians")

# Your turn: put mean in place of median in the two lines above.
# Nothing else has to change - that is the point of the method.


# ==================================================================
#  Extra, if there is time
# ==================================================================

# How big must the real study be? delta is the difference you would
# not want to miss - your judgement, not a calculation.

# The spread we need is the spread WITHIN the groups, from all 20:
sd(a)                              # 0.28 mm in the diabetic arm
sd(b)                              # 0.48 mm in the control arm
s <- sqrt((var(a) + var(b)) / 2)   # both arms together
s                                  # 0.39 mm

power.t.test(delta = 0.3, sd = s, power = 0.80)   # 28 patients per group

# And s itself comes from only 20 patients, so it is shaky too.
# Redraw both arms 2 000 times and recompute the sample size:
ns <- replicate(2000, {
  s2 <- sqrt((var(sample(a, 10, replace = TRUE)) +
              var(sample(b, 10, replace = TRUE))) / 2)
  power.t.test(delta = 0.3, sd = s2, power = 0.80)$n
})
quantile(ns, c(0.025, 0.975))      # 11 to 46 - plan for the top end
hist(ns, breaks = 30, xlab = "n", main = "Required n per group")


# ==================================================================
#  replace = FALSE  ->  shuffle  ->  is there a difference?
#  replace = TRUE   ->  redraw   ->  how precise is the estimate?
#
#  Change set.seed(2026) to any other number, run the script again,
#  and watch every answer move. That is sampling variation.
# ==================================================================
