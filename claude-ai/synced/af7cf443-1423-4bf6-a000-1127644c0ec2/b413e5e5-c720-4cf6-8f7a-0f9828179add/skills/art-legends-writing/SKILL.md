---
name: "art-legends-writing"
description: "Write, convert or check figure legends (main, supplementary, Extended Data) in Arthur Skoultchi's style and in the exact format of the target journal (PNAS, Nature, Science, Genes Dev, JBC, BMC, PLoS)."
---

# Writing figure legends the way Art writes them

Derived from every main and supplementary legend in the 13 last-author Skoultchi papers 2007–2020. Legends in these papers are self-contained experimental records: a reader with only the figure and its legend can tell what was done, to what, how it is displayed, and how many times it was seen. They are not summaries of the Results text and they rarely interpret.

When the user supplies a panel list or sketch, produce the finished legend in the requested journal format. When asked to check a legend, list what is missing against the checklist in §5.

## 1. Anatomy of a legend

```
Fig. N. <Title: a declarative claim or a neutral description>. (A) <What was done, passive, past tense> … <what is plotted / shown, present tense> … <replicates and error bars> … <stats> … <abbreviations, colors, symbols>. (B and C) <…> as in A … (Lower) … (Right) …
```

**Title.** A complete sentence ending in a period. For a data figure it is the finding, phrased exactly like a Results subsection heading:
- "H1 stoichiometry regulates chromatin compaction in spatially defined nuclear compartments."
- "H1 is required for transcriptional repression of several classes of repetitive elements."
- "PU.1 is an integral repressor of a core erythroid network, and conversely, GATA-1 represses numerous PU.1 myelo-lymphoid gene targets in erythroid progenitors."
- "The H1 C-terminal domain is required and sufficient for binding to Su(var)3-9, and the H1 globular domain is sufficient for binding to HP1."
For a figure that establishes a tool or a system, the title is a neutral noun phrase: "Depletion of histone H1 in Drosophila."; "Chromatin accessibility of the Pu.1 locus changes during erythropoiesis."; "Properties of chromatin assembled in vitro with C-terminally truncated H1 variant proteins."; "Correlation analysis of TF mRNA with Pu.1 mRNA in fetal liver scRNAseq data." Never a question, never a fragment such as "H1 and compaction".

**Panel sentences, in this order (omit what does not apply, never reorder):**
1. *Material and perturbation* — genotype/cell line/tissue, treatment, time: "Transcript levels of the indicated repetitive sequences were measured by RT-qPCR in WT, TKO, H1-low, and H1 rescue lines stably expressing H1d."
2. *Method* — one clause, with the pointer to Methods if there is detail: "qChIP was performed with antisera specific for the indicated proteins and histone modifications on cross-linked chromatin from…", "as described in Materials and Methods", "as described under 'Experimental Procedures'", "(see Methods)".
3. *What is displayed and how it was computed* — present tense: "The bars indicate the percentage of input DNA fragment … in specific immunoprecipitates after subtracting the percentage in immunoprecipitates using isotype-matched control antibodies."; "Enrichment is expressed as log2(IP reads/input reads)."; "Values were normalized to Gapdh mRNA using the ΔΔCt method."; "Data are shown as relative to DMSO control at 24 h."; "Numbers above indicate expression relative to WT."
4. *Replication and error* — "Error bars indicate the SD of triplicate determinations."; "Error bars represent SEM of three or four independently derived clones per condition."; "n = 2 or 3 independent clones per condition."; "(n = 4 (spleen), 3 (thymus) and 3 (bone marrow) mice per genotype)"; "Similar results were obtained in three repeat experiments."; "Similar results were obtained with several other ES cell lines of the same genotypes."; "All experiments were performed in triplicate."; "Representative images are shown; data from large numbers of samples are compiled in Table 3."; "Data are from three technical replicates of the indicated cell line."
5. *Statistics* — test named, thresholds listed once at the end of the legend: "ns, not statistically significant; *P ≤ 0.05; **P < 0.01; ***P < 0.001; ****P < 0.0001."; "Unpaired t test with Welch's correction was used to test statistical significance."; "The Wilcoxon signed-rank test was used to test for significance in B."; "as determined by two-tailed Mann–Whitney tests (all P < 0.001)"; "Data were analyzed by t test using a false discovery rate of 10%. ns, not statistically significant; * q ≤ 0.05; *** q < 0.001."; "Probability values are calculated by the χ2 two-way test."
6. *Keys* — colors, symbols, lane labels, abbreviations: "(Blue) DAPI; (red) HP1; (green) H3K9Me2."; "Black bars, H1-depleted SGs; gray bars, H1-depleted UAS:Su(var)3-9-eGFP SGs."; "Thy, thymus; Sp, spleen; BM, bone marrow"; "CMP, common myeloid progenitors; ES, embryonic stem cell; GMP, granulocyte–macrophage progenitors"; "Prom., promoter."; "Open triangles indicate the positions of the hexanucleosome bands in each sample. (M) 123-bp DNA ladder."; "Scale bar represents 10 μm."; "White arrowheads, positions of multiple HP1- or H3K9me2-containing foci."
7. *Controls and loading* — always named: "Input lanes are 5% of the extract used for immunoprecipitation."; "Lysates of cells transfected with an empty expression vector (Vector) served as negative controls."; "A HA antibody was used as an isotype control."; "The myogenin gene serves as a negative control."; "Protein loading was controlled by immunoblotting for tubulin."; "Coomassie blue-stained SDS/PAGE gel of purified proteins showing equal loading (Lower)."; "H1-depleted (H1-RNAi) and control RNAi (Nau-RNAi) animals served as positive and negative controls, respectively."

**Compression across panels.** Once a method is described, later panels refer back: "as in A"; "as in (B)"; "GST pulldown assays as in A with the indicated proteins."; "QRT-PCR assays were performed as in (C)."; "Other details are as described in Fig. 1."; "The data were analyzed as in Fig. 1B."; "H1 and H3 occupancy were determined using CUT&Tag and normalized as in Fig. 2h." Group panels that share a method: "(A and B)", "(C and D)", "(A–G)", "a–e,", "c–h,".

**Interpretation inside the legend.** Journal-dependent. Nature/Science/PNAS legends state zero interpretation beyond the title. Genes Dev, Epigenetics & Chromatin and JBC legends carry a one-sentence descriptive reading per panel, placed as the panel's first sentence and phrased as an observation, not a conclusion: "(B) H1 depletion causes abnormal polytene chromosome morphology and the loss of the H3K9Me2 marker in pericentric heterochromatin. Salivary glands from control… were squashed…"; "Note the decreasing size of chromatosome particles formed with truncated H1 polypeptides."; "Control chromosomes (CON) have a uniform regular structure of bands and interbands…, whereas no such uniform banding pattern or the chromocenter are apparent in the H1-depleted polytene chromosomes (H1 KD)." Match the target journal; when unknown, default to the PNAS (no-interpretation) style.

**Schematic/model figures** get a key-first legend: "Nucleosomes, H1, HP1, STAT, and JAK are represented by light-gray ovals, red rectangles, blue ovals, orange hexagons, and light-green rectangles, respectively." then a walk through the panels as a narrative in present tense.

## 2. Journal format switches

| Journal | Figure label | Panel label | Sub-panel locators | Supplementary refs |
|---|---|---|---|---|
| PNAS | `Fig. 1.` | `(A)`, `(B and C)`, `(A–G)` | `(Upper)`, `(Lower)`, `(Left)`, `(Right)`, `(C, Right)` | `SI Appendix, Fig. S1 A and B`; `Fig. S2` (older) |
| Nature | `Fig. 1 \|` | `a,` `b, c,` `c–h,` (lowercase, comma, no parentheses) | `(top)`, `(bottom)`, `(left)` | `Extended Data Fig. 5a, b`; Extended Data legends begin `Extended Data Fig. 1 \| Title.` |
| Science | `Fig. 1.` then title on its own line | `(A)` | `(Left)`, `(Top)`, `(Bottom)` | `fig. S1A`, `table S1` |
| Genes Dev | `Figure 1.` | `(A)` | `(Left panel)`, `(Right panel)`, `(Top)`, `(Bottom)` | `Supplemental Fig. 1` |
| JBC | `FIGURE 1.` | `A,` `B,` (italic letter, comma) | `(left panels)`, `(right panels)` | `supplemental Fig. 1A` |
| Epigenetics & Chromatin / BMC | `Figure 1` (no period) | `(A)` | `Top,` `Middle,` `Bottom,` | `Additional file 1: Figure S2A` |
| PLoS Genetics | `Figure 1.` | `(A)` | `(left)`, `(right)` | `Figure S1`; ends with `Found at: doi:…` |

Keys in Nature use "wild-type (black) and H1cTKO;Vav-iCre (red)"; in Genes Dev the parenthesis-first form "(Blue) DAPI; (red) HP1"; in PNAS "(H1+, black bars) or without H1 (H1–, gray bars)".

## 3. Lexicon

- Verbs for what was done: "was/were measured", "was performed", "were analyzed by", "were subjected to", "were incubated with", "were stained with", "was quantified using ImageJ", "were isolated by FACS", "were immunoprecipitated with", "was calculated as", "was determined by", "were identified", "were compared to matched control genomic regions".
- Verbs for what is shown: "are shown", "is displayed", "is expressed as", "indicate(s)", "represent(s)", "is plotted as a function of", "Shown is…", "The ordinate indicates…", "the x-axis is displayed as…".
- Quantities: "the percentage of input DNA fragment recovered", "relative to input DNA", "normalized to the level of GAPDH mRNA", "fold changes were calculated as a ratio of signals for H1-depleted samples to those for control samples and normalized to RP49", "log2(observed/expected) overlap", "the number of a given read length normalized to region size".
- Cell/animal descriptors are complete on first mention within the legend: "two stably transfected TKO ES cell lines expressing exogenous H1d (R-12 and R-32)"; "H1-depleted (pINT-1-H15M + Tubulin-GAL4) and control (pINT-1-Nau + Tubulin-GAL4) L3 larvae"; "The animals were incubated at 29°C throughout their life cycle." (repeated in every fly panel that depends on it).
- Pointers: "Specificity of the H1d antibody is demonstrated in Fig. S5."; "The H1 histone subtype stoichiometries in the cell lines are shown in Fig. S2."; "For quantitation, see Table 1."; "Corresponds to g."; "(see Fig. 1 B and C, Upper, ChIP regions)".
- Never: "as expected", "clearly", "dramatic" (use "marked"), "significant" without a test, "representative" without saying what was quantified elsewhere, "respectively" chains longer than three items.

## 4. Worked exemplar (PNAS style)

Input: panel list — A, ChIP-qPCR of H1 at repeats in WT ESC; B, RT-qPCR of satellite transcripts in WT/TKO/H1-low/rescue; C, H3K9me3 ChIP in same lines; D, MNase ladder.

Output:
"Fig. 2. H1 is required for transcriptional repression of major satellite sequences and promotes their H3K9 trimethylation. (A) Enrichment of H1a at repetitive elements. ChIP-qPCR was performed on fixed chromatin from WT mESCs using H1a and control IgG antisera. Enrichment is expressed as a percentage of input DNA fragment recovered. (B) Major satellite transcripts were measured by RT-qPCR in WT, TKO, H1-low, and H1 rescue lines stably expressing H1d. Values were normalized to Gapdh mRNA using the ΔΔCt method. Error bars represent SEM of three or four independently derived clones per condition. (C) H3K9me3 ChIP-qPCR in the cell lines described in B. Cross-linked chromatin was immunoprecipitated with an H3K9me3 antibody, and recovered DNA was quantified by PCR using primers for major satellite sequences. Data are shown as a percentage of input DNA fragments; error bars as in B. (D) Nucleosome spacing in WT and H1-low mESCs. Nuclei were subjected to limited digestion with micrococcal nuclease, and DNA was purified and analyzed by nondenaturing agarose gel electrophoresis followed by ethidium bromide staining. ns, not statistically significant; *P ≤ 0.05; **P < 0.01; ***P < 0.001."

## 5. Checklist before returning a legend

1. Title is a full sentence with a period; a claim for data figures, a description for method/tool figures.
2. Every panel letter in the figure appears in the legend, in order, in the journal's label format.
3. Each panel names: material (genotype/line/tissue), perturbation, method, what is plotted, how it was normalized.
4. Replicates: n and what n counts (clones, mice, technical replicates, nuclei) and what the error bars are.
5. Statistical test named once; asterisk key given once at the end.
6. Every color, symbol, lane label and abbreviation used in the figure is defined (or pointed to an earlier figure).
7. Controls and loading controls are named.
8. Repeated methods are compressed with "as in A" / "Other details are as described in Fig. 1."
9. No conclusions in Nature/Science/PNAS legends; one observational sentence per panel is allowed in Genes Dev/JBC/BMC style.
10. Nomenclature (H1c/d/e, TKO, H1-low, mESCs, qChIP, H3K9me3 vs H3K9Me2) is identical to the Results text and to `art_results_writing`.