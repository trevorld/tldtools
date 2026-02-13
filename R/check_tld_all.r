#' Run all checks contained in this package
#'
#' `check_tld_all()` runs all the checks contained in this package.
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
#'   check_all()
#' }
#' @return `NULL` invisibly.  As a side effect prints several messages.
#' @seealso [use_tld_all()]
#' @export
check_all <- function() {
	check_air()
	check_filenames()
	check_github_actions()
	check_github_labels()
	check_github_settings()
	invisible(NULL)
}

#' Use all of Trevor's preferred setups
#'
#' `use_tld_all()` uses all of Trevor's setup functions in this package.
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
#'   use_tld_all()
#' }
#' @return `NULL` invisibly.  As a side effect writes several files.
#' @seealso [check_all()]
#' @export
use_tld_all <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	use_tld_Rbuildignore()
	use_tld_air()
	use_tld_filenames()
	use_tld_github_actions()
	use_tld_github_labels()
	use_tld_github_settings()

	invisible(NULL)
}
