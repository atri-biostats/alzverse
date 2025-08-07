# Build alzverse package ----
devtools::document()
devtools::check(error_on = "error", vignettes = INCLUDE_DERIVED_DATASET)
pkg_dir <- devtools::build(vignettes = INCLUDE_DERIVED_DATASET)
install.packages(pkgs = pkg_dir, repos = NULL)

# Build README.md ----
devtools::build_readme()

# # Build website ----
# # run once:
# # To clean any existing site on local machine
# pkgdown::clean_site()
# # Caution of overwriting any existing `_pkgdown.yml` file
# usethis::use_pkgdown()
# pkgdown::check_pkgdown()
# pkgdown::build_site()
# # Publish website online ----
# # To publish a site online via GitHub repo: PUBLISH_SITE = TRUE
# # PUBLISH_SITE <- FALSE
# if (PUBLISH_SITE) {
#   pkgdown::deploy_to_branch()
# }
