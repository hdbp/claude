---
name: paperclip
description: Search and read biomedical papers, regulatory documents, clinical trials, protein databases, and NCBI GEO datasets with the paperclip CLI. Run `paperclip skill` to load the current documentation before using it.
---

# Paperclip

Paperclip is a virtual filesystem of biomedical papers, regulatory documents, clinical trials, protein databases, and NCBI GEO datasets.

**Before doing any Paperclip work, run `paperclip skill` to load the full documentation, available routines, and domain references.** If the user's request matches an available routine, load it with `paperclip routines show <name>` and follow its instructions. For domain-specific work, load the reference with `paperclip skill <name>`. Run `paperclip <command> --help` for detailed help on any individual command.

**Persistent dataset routing:** Requests to create, build, or populate a dataset,
data-curation grid, or spreadsheet with defined rows and columns must load
`paperclip routines show paperclip-data-extraction`. Never substitute a table
formatted only in chat. If the routine cannot load, stop and report the routing
or authentication failure.

**Active-routine context rule:** Do not voluntarily invoke context compaction while a routed routine is active or summarize away its orchestrator. Automatic compaction can still happen. After compaction, a resumed session, or uncertainty about the current phase, stop before doing more work: run `paperclip skill`, reload the routine with `paperclip routines show <routine>`, and follow that orchestrator's recovery procedure. Never choose the next phase from a conversation summary alone.
