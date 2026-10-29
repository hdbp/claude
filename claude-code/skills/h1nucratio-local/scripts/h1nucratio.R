#!/usr/bin/env Rscript
# h1nucratio.R — H1 subtype composition and H1-per-nucleosome stoichiometry
# from RP-HPLC (A214) peak areas of acid-extracted histones.
#
# Method (Fan et al. 2003 MCB; Skoultchi lab):
#   relative moles   = peak area / no. of peptide bonds
#   % of total H1    = mol(H1x) / sum(mol(H1)) * 100
#   H1 per nucleosome = sum(mol(H1)) / (mol(H2B) / 2)     # 2 H2B per nucleosome
#
# Usage as a script:
#   Rscript h1nucratio.R input.xlsx [output_prefix]
# Usage as a library:
#   source("h1nucratio.R"); res <- h1_nuc_ratio(df)   # df: sample, histone, area [, bonds]

# Default peptide-bond counts (lab spreadsheet values; H2B = single-molecule count).
# H1c (220) should be verified against UniProt before publication.
DEFAULT_BONDS <- c(H1_0 = 193, H1a = 212, H1b = 222, H1c = 220, `H1d/e` = 219, H2B = 124)

normalize_histone <- function(x) {
  y <- trimws(gsub("[[:space:]]+", "", x))
  y[grepl("^H1(0|°|o|_0|\\.0|zero)$", y, ignore.case = TRUE)] <- "H1_0"
  y[grepl("^H1(e/d|d/e|d\\+e|e\\+d|de|ed)$", y, ignore.case = TRUE)] <- "H1d/e"
  y[grepl("^H2B$", y, ignore.case = TRUE)] <- "H2B"
  y
}

# Read the lab sheet layout: A1 = sample name; col A = histone, B = peak area,
# C = peptide bonds (optional). One sample per sheet; all sheets are read.
read_hplc_xlsx <- function(path) {
  stopifnot(requireNamespace("readxl", quietly = TRUE))
  out <- lapply(readxl::excel_sheets(path), function(sh) {
    raw <- suppressMessages(readxl::read_excel(path, sheet = sh, col_names = FALSE,
                                               col_types = "text"))
    sample <- as.character(raw[[1]][1])
    if (is.na(sample) || sample == "") sample <- sh
    body <- raw[-1, , drop = FALSE]
    hist <- normalize_histone(as.character(body[[1]]))
    keep <- !is.na(hist) & (grepl("^H1", hist) | hist == "H2B") & !grepl("total", hist, TRUE)
    data.frame(sample  = sample,
               histone = hist[keep],
               area    = suppressWarnings(as.numeric(body[[2]][keep])),
               bonds   = if (ncol(body) >= 3) suppressWarnings(as.numeric(body[[3]][keep])) else NA_real_,
               stringsAsFactors = FALSE)
  })
  do.call(rbind, out)
}

h1_nuc_ratio <- function(df, default_bonds = DEFAULT_BONDS) {
  df$histone <- normalize_histone(df$histone)
  df$area[is.na(df$area)] <- 0                       # empty peak = not detected
  if (!"bonds" %in% names(df)) df$bonds <- NA_real_
  miss <- is.na(df$bonds)
  df$bonds[miss] <- default_bonds[df$histone[miss]]
  if (any(is.na(df$bonds)))
    stop("No peptide-bond count for: ", paste(unique(df$histone[is.na(df$bonds)]), collapse = ", "))

  # Guard: some sheets encode the /2 by doubling H2B bonds (e.g. 248). Undo it so
  # the /2 is applied exactly once, explicitly.
  h2b_dbl <- df$histone == "H2B" & df$bonds > 200
  if (any(h2b_dbl)) {
    message("Note: H2B peptide bonds > 200 (", paste(unique(df$bonds[h2b_dbl]), collapse = ","),
            ") look doubled to encode 2 H2B/nucleosome; halving them and applying /2 explicitly.")
    df$bonds[h2b_dbl] <- df$bonds[h2b_dbl] / 2
  }

  df$mol <- df$area / df$bonds
  res <- do.call(rbind, lapply(split(df, df$sample), function(d) {
    h2b <- d$mol[d$histone == "H2B"]
    if (length(h2b) != 1 || h2b <= 0) stop("Sample ", d$sample[1], ": need exactly one positive H2B peak")
    h1  <- d[d$histone != "H2B", ]
    nuc <- h2b / 2
    rbind(data.frame(sample = d$sample[1], histone = h1$histone,
                     pct_of_H1 = 100 * h1$mol / sum(h1$mol),
                     per_nucleosome = h1$mol / nuc),
          data.frame(sample = d$sample[1], histone = "Total_H1", pct_of_H1 = 100,
                     per_nucleosome = sum(h1$mol) / nuc))
  }))
  rownames(res) <- NULL
  res
}

# Mean ± SD across samples sharing a group label (e.g. technical replicates)
summarize_groups <- function(res, group) {
  res$group <- group[res$sample]
  agg <- aggregate(cbind(pct_of_H1, per_nucleosome) ~ group + histone, res,
                   function(v) c(mean = mean(v), sd = if (length(v) > 1) sd(v) else NA, n = length(v)))
  do.call(data.frame, agg)
}

if (sys.nframe() == 0) {
  args <- commandArgs(trailingOnly = TRUE)
  if (length(args) < 1) stop("Usage: Rscript h1nucratio.R input.xlsx|input.csv [output_prefix]")
  inp <- args[1]
  df <- if (grepl("\\.xlsx?$", inp, TRUE)) read_hplc_xlsx(inp) else read.csv(inp, stringsAsFactors = FALSE)
  res <- h1_nuc_ratio(df)
  print(format(res, digits = 3), row.names = FALSE)
  prefix <- if (length(args) >= 2) args[2] else sub("\\.[^.]+$", "", basename(inp))
  write.csv(res, paste0(prefix, "_h1nucratio.csv"), row.names = FALSE)
  cat("\nWritten:", paste0(prefix, "_h1nucratio.csv"), "\n")
}
