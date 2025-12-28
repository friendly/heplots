# GitHub Actions for {heplots} Package

## Basic Setup

You'll need to create a `.github/workflows/` directory in your package repository and add YAML workflow files there. Each YAML file defines one workflow with specific triggers and jobs.

## Core Options for R Package CI/CD

### R-CMD-check
The essential workflow for any R package. This runs `R CMD check` across multiple platforms (Windows, macOS, Linux) and R versions. It catches installation issues, documentation problems, test failures, and CRAN compliance issues before submission. The standard approach uses `r-lib/actions/check-r-package`, which handles most of the complexity for you.

### Test Coverage
Track what percentage of your code is tested using {covr} and services like Codecov. This helps identify untested code paths and provides a badge for your README. The workflow typically runs your tests with coverage enabled and uploads results after each push.

### pkgdown Site
Automatically build and deploy your package documentation website to GitHub Pages. This creates a professional-looking site from your function documentation, vignettes, and README. It can rebuild on every push to main or on a schedule.

### Rendering Vignettes/README
If you have computational vignettes or a README.Rmd that generates plots or examples, you can have Actions render these automatically and commit the results. This is particularly useful for your visualization package where examples show actual plots.

## Platform and Version Testing

For a CRAN package like {heplots}, you'll want to test on:
  - Multiple OS: Ubuntu (Linux), Windows, macOS
- Multiple R versions: release, devel, and possibly oldrel
- The workflow can use a matrix strategy to run all combinations efficiently

## Getting Started Quickly

The {usethis} package makes this trivial:
  
  ```r
usethis::use_github_action("check-standard")  # Basic R CMD check
usethis::use_github_action("test-coverage")   # Codecov integration
usethis::use_github_action("pkgdown")         # Documentation site
```

These commands create pre-configured workflow files that work out of the box for most packages.

## Considerations for {heplots}

Since your package focuses on visualization with base R graphics, you might want to ensure your workflows have the necessary graphics devices available. The standard workflows typically handle this, but you may need to verify that any vignettes generating plots render correctly in the CI environment.

## Additional Resources

- [r-lib/actions](https://github.com/r-lib/actions) - Collection of GitHub Actions for R
- [GitHub Actions documentation](https://docs.github.com/en/actions)
- [usethis documentation](https://usethis.r-lib.org/reference/github_actions.html)

## Next Steps

1. Decide which workflows you need (at minimum, R-CMD-check is recommended)
2. Use `usethis::use_github_action()` to set up the workflow files
3. Commit and push the `.github/workflows/` directory to your repository
4. Monitor the Actions tab on GitHub to see your workflows run
5. Add status badges to your README to show build status

---
  
  *Generated: December 2, 2025*