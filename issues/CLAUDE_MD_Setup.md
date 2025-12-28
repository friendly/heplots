# Setting Up CLAUDE.md for R Package Development

**Date**: December 2, 2024  
**Context**: Conversation about creating guidelines for Claude Code when working on R packages

---

## Initial Request

**Michael**: I'm just getting started with Claude Code on Windows, trying to set this up. For my R packages, I'd like to set up instructions for how Claude should write code. For example, for console output, you usually use `sprintf()` rather than the simpler versions using `paste()` or `glue::glue()` which I prefer. Also, wherever possible, I prefer vectorized solutions to loops. Can you help on this, with a sample `CLAUDE.md` file?

**Claude Response**: Created a comprehensive CLAUDE.md file with guidelines covering:
- String formatting preferences (glue::glue())
- Vectorization over loops
- Function documentation (roxygen2)
- Error handling and validation
- Graphics and visualization
- Testing strategies
- Package-specific conventions for heplots

---

## Refinement: Using glue:: Namespace

**Michael**: With respect to `glue()`, I don't want to import the entire {glue} package. Please change to avoid `library(glue)` and use the form `glue::glue()` throughout. Add a statement that this requires: `Suggests: glue` in the DESCRIPTION file and `@importFrom glue glue` somewhere in the package R files.

**Claude Response**: Updated all examples to use `glue::glue()` notation and added:

```r
# In DESCRIPTION:
# Suggests: glue

# In R/utils.R or R/heplots-package.R:
#' @importFrom glue glue
NULL
```

---

## Implementation Question

**Michael**: When I add this `CLAUDE.md` to the root directory of the package (or any other R package), how do I ask you to read it when I start a new topic? In general, I provide you with a link to the GitHub repo or a file when I start a new topic via this Claude App interface.

**Claude Response**: Provided several approaches:

### Recommended Methods:

1. **Explicit Request**: "Please read the CLAUDE.md file first"
2. **Include in Initial Request**: Combine with question
3. **Direct Link**: Provide raw.githubusercontent.com link

### Template:
```
Working on: https://github.com/friendly/heplots
Read CLAUDE.md first: https://raw.githubusercontent.com/friendly/heplots/master/CLAUDE.md

[Your question/task here]
```

### For Claude Code:
CLAUDE.md is automatically read from the repository root - no need to ask!

---

## Setting Up Automatic Behavior

**Michael**: Yes, please do [remember to check for CLAUDE.md], as long as it will not create problems if CLAUDE.md is not in a package repo.

**Claude Response**: Agreed to implement the following workflow:

When a GitHub repository is mentioned:
1. Automatically try to fetch CLAUDE.md from root (master or main branch)
2. If found: Read silently and apply guidelines
3. If not found: Continue normally without error or comment

This ensures:
- ✅ R packages with CLAUDE.md: Automatic convention following
- ✅ Repos without CLAUDE.md: No problems, normal operation
- ✅ No extra work required

---

## Key Takeaways

1. **CLAUDE.md Location**: Root directory of repository
2. **Usage in Claude App**: Mention the GitHub repo, Claude will auto-check for CLAUDE.md
3. **Usage in Claude Code**: Automatically read from current directory
4. **Preferences Captured**:
   - Use `glue::glue()` for string formatting (not sprintf or paste)
   - Prefer vectorized solutions over loops
   - Use Suggests: glue in DESCRIPTION
   - Add @importFrom glue glue in package files

---

## Files Created

1. **CLAUDE.md** - Complete guidelines document
2. **CLAUDE_MD_Setup_Conversation.md** - This conversation summary

---

## Related Context

This conversation followed work on:
- Fixing `boxM()` function to handle singular covariance matrices
- Extending `label.ellipse()` to support diagonal compass directions (NE, SE, SW, NW)
- Development practices for the heplots package focused on multivariate statistical visualization
