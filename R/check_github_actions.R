#' Check GitHub Actions setup
#'
#' `check_github_actions()` checks the GitHub Actions setup
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
#'   check_github_actions()
#' }
#' @return `NULL` invisibly.  As a side effect prints a message.
#' @seealso [use_tld_github_actions()]
#' @export
check_github_actions <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	message <- character(0L)

	message <- c(message, check_file(".github/workflows/R-CMD-check.yaml"))
	message <- c(message, check_file(".github/workflows/air-check.yaml"))
	message <- c(message, check_file(".github/workflows/test-coverage.yaml"))

	patterns <- "^\\.github$"
	message <- c(message, check_Rbuildignore(patterns))

	df <- ghcli::gh_secret_list()
	if ("CODECOV_TOKEN" %in% df$name) {
		message <- c(message, "v" = "`CODECOV_TOKEN` is a repository secret")
	} else {
		message <- c(message, "x" = "`CODECOV_TOKEN` is not a repository secret")
	}

	cli_inform(message, class = "tldtools_check_github_actions")
	invisible(NULL)
}

#' Use Trevor's preferred GitHub Actions
#'
#' `use_tld_github_actions()` uses Trevor's preferred GitHub Actions
#' @examples
#' \dontrun{
#'   use_tld_github_actions()
#' }
#' @return `NULL` invisibly.  As a side effect writes several files.
#' @seealso [check_github_actions()]
#' @export
use_tld_github_actions <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	if (!dir.exists(".github/workflows")) {
		dir.create(".github/workflows", recursive = TRUE)
	}
	file.copy(tld_file("R-CMD-check.yaml"), ".github/workflows/R-CMD-check.yaml", overwrite = TRUE)
	file.copy(tld_file("air-check.yaml"), ".github/workflows/air-check.yaml", overwrite = TRUE)
	file.copy(
		tld_file("test-coverage.yaml"),
		".github/workflows/test-coverage.yaml",
		overwrite = TRUE
	)

	invisible(NULL)
}
