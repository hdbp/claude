---
name: h1nucratio-local
description: Calculate linker histone H1 stoichiometry (H1 per nucleosome) and H1 subtype composition (% of total H1) from RP-HPLC A214 peak areas of acid-extracted histones, using the Skoultchi-lab / Fan et al. 2003 method (peak area ÷ peptide bonds, total H1 ÷ half of H2B). Use this skill whenever the user asks for the H1 ratio, H1/nucleosome, H1 per nucleosome, H1:H2B, H1 stoichiometry, H1 subtype percentages, or uploads/pastes HPLC histone peak areas (H1°/H1.0, H1a, H1b, H1c, H1d/e, H2B) — including spreadsheets like "HPLC_Calc.xlsx" — even if they don't say "nucleosome" explicitly. Also use it to audit someone else's H1 ratio spreadsheet.
---

# H1 per nucleosome from RP-HPLC

## The method

A214 absorbance of a histone peak is roughly proportional to its number of peptide bonds, so peak area divided by peptide bonds gives a relative molar amount. From that:

- **% of total H1** for subtype x = mol(H1x) / Σ mol(H1) × 100
- **H1 per nucleosome** = Σ mol(H1) / (mol(H2B) / 2), because each nucleosome contains two H2B
- **Subtype per nucleosome** = mol(H1x) / (mol(H2B) / 2)

The factor of 2 is the step that goes wrong most often. Apply it exactly once. Some lab spreadsheets hide it by entering H2B with doubled peptide bonds (248 instead of 124), which makes a column labeled "H1 to H2B" actually mean H1 per nucleosome. When auditing a sheet, check the H2B bond count first. If it is ~248 the ÷2 is already built in; if it is ~124 and there is no explicit ÷2, the reported value is H1:H2B, which is half of H1/nucleosome.

Sanity ranges: wild-type mESCs are about 0.5 H1/nucleosome, and many differentiated tissues (thymus, liver) are about 0.8. H1 triple-knockout (H1c/d/e) mESCs are about half of wild type. A value near 1.0 for ES cells, or near 0.25 for WT ES cells, suggests a factor-of-2 error.

## Default peptide-bond counts (mouse)

| Histone | Bonds | Notes |
|---|---|---|
| H1° (H1.0) | 193 | Often absent or <1% in mESCs |
| H1a (H1.1) | 212 | |
| H1b (H1.5) | 222 | |
| H1c (H1.2) | 220 | Verify against UniProt before publication |
| H1d/e (H1.3/H1.4) | 219 | Co-elute on C18, quantified as one peak |
| H2B | 124 | Single molecule. Never enter 248 here when using the script |

If the user's sheet provides its own bond counts, use theirs. The script does this automatically and only fills missing values from the defaults.

## Integrating peaks from raw chromatograms: two baseline methods

When the areas come from raw traces (not a ready-made table), integrate every peak with **both** baselines and carry both through the whole calculation. The choice of baseline changes total H1/nucleosome by roughly 10% (and the sign of the change varies by sample), which is as large as many of the differences being tested.

1. **Single straight baseline.** One line per sample: the lower-convex-hull edge under the window, from just before H1b to a few minutes past the end of the H2B cluster, never above the signal. Every peak is integrated against that one line. It is reproducible and operator-free, but it overestimates small peaks sitting on a rising or curved baseline (H1a/H1d/e/H1c were 27-63% above ChemStation in one sample).
2. **Local chords (per-peak baselines).** Each peak is integrated against a straight chord between its own start and end points (signal smoothed ~7 points at the endpoints). Neighbouring peaks share the valley point between them, so H1a, H1d/e and H1c get chords that meet at the valleys; H2B's chord runs from its start to the valley with the next peak. This is how ChemStation integrates: local-chord H1a/H1d/e/H1c areas matched ChemStation's to within 1% in one sample. It removes more area from H2B than the single baseline, so it can move the ratio either way.

Peak starts and ends come from the same peak detection for both methods, so the two differ only in the baseline. Pin the H2B peak by hand when the run has an artifact spike taller than H2B (use the first peak of the first big cluster after H1c, not the tallest peak). Time axes differ between columns and gradients (the same peaks can elute 30 min later, and run length can differ), so check the full trace before applying fixed retention windows.

```r
# area of one peak against its own chord; t in min, y raw, ys smoothed (7-pt moving average)
s <- which.min(abs(t - start_min)); e <- which.min(abs(t - end_min))
bl <- approx(c(t[s], t[e]), c(ys[s], ys[e]), t[s:e])$y
area <- sum(diff(t[s:e] * 60) * (head(y[s:e] - bl, -1) + tail(y[s:e] - bl, -1)) / 2)   # mAU*s
```

Run `h1_nuc_ratio()` once per method (and once more on ChemStation's areas as a cross-check when they are available).

## Workflow

1. Get the peak areas. They may come from an uploaded xlsx (lab layout: A1 = sample name; column A = histone, B = peak area, C = peptide bonds; one sample per sheet), a CSV with columns `sample, histone, area[, bonds]`, or numbers pasted in chat. Treat an empty peak as 0, meaning not detected.
2. Run the bundled R script. The user works in R, so use R. Get Rscript and readxl into the container if they are missing (apt `r-base-core r-cran-readxl`). For pasted numbers, build the data.frame directly:
   ```bash
   Rscript scripts/h1nucratio.R input.xlsx out_prefix   # writes out_prefix_h1nucratio.csv
   ```
   ```r
   source("scripts/h1nucratio.R")
   res <- h1_nuc_ratio(df)                              # df: sample, histone, area[, bonds]
   summarize_groups(res, c(WT_1 = "WT", WT_2 = "WT"))   # mean ± SD for replicates
   ```
   The script normalizes names (H10/H1°/H1.0 → H1_0; H1e/d, H1d/e → H1d/e). It detects a doubled H2B bond count (>200), halves it, and applies ÷2 explicitly, printing a note when it does so.
3. **Always report results from both integration methods** (single baseline and local chords), side by side, whenever areas come from raw traces. Give total H1/nucleosome, each subtype's per-nucleosome value and % of H1 for each method, plus the per-peak areas so differences can be traced, and ChemStation's areas/ratio when available. Never present one method's number alone as the answer; state how far apart the two are. If the user supplies areas that were already integrated, say which baseline they correspond to and that only one method is available. Report the results in prose plus a compact table. Include total H1 per nucleosome and each subtype's per-nucleosome value and % of H1. Compare total H1 per nucleosome to the sanity range for the cell type, and flag anything outside it. When comparing conditions (for example WT vs H1-low or TKO), give the fold change in total H1/nucleosome and which subtypes account for the loss.
4. If the user supplied a spreadsheet, audit it against this method. Check how the ÷2 is handled, whether labels like "ratio to H2B" misdescribe per-nucleosome values, the bond counts, and whether there are replicates. Point out problems, but don't rewrite the sheet unless asked.
5. If a plot is requested, use a stacked bar of subtype per nucleosome by sample, which shows both total stoichiometry and composition. These are not scatter plots, so the density-coloring preference does not apply.

## Caveats to mention when relevant

- Baseline choice is a systematic uncertainty: report both methods (see above) and treat the spread between them as a minimum error bar on a single run.
- Single HPLC runs are noisy. Published values are means of several determinations, so recommend at least technical triplicates and consistent integration windows.
- The peptide-bond correction assumes equal A214 response per bond. That is standard practice, but it is an approximation.
- H2B variants elute in the H2B peak and are counted as H2B, which is correct for nucleosome counting.

Reference: Fan Y, et al. (2003) Mol Cell Biol 23:4559–4572, Table 2 footnotes (total H1 A214 over half the H2B A214, both corrected for peptide bonds).
