#' Check GitHub sponsor button setup
#'
#' `check_github_sponsors()` checks the GitHub sponsor button setup.
#' @examples
#' \dontrun{
#'   check_github_sponsors()
#' }
#' @return `NULL` invisibly.  As a side effect prints a message.
#' @seealso [use_tld_github_sponsors()]
#' @export
check_github_sponsors <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	message <- character(0L)
	message <- c(message, check_file(".github/FUNDING.yml"))
	message <- c(message, check_Rbuildignore("^\\.github$"))

	cli_inform(message, class = "tldtools_check_github_sponsors")
	invisible(NULL)
}

#' Use Trevor's preferred GitHub sponsor button settings
#'
#' `use_tld_github_sponsors()` uses Trevor's preferred GitHub sponsor button settings.
#' @examples
#' \dontrun{
#'   use_tld_github_sponsors()
#' }
#' @return `NULL` invisibly.  As a side effect writes a file.
#' @seealso [check_github_sponsors()]
#' @export
use_tld_github_sponsors <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	if (!dir.exists(".github")) {
		dir.create(".github")
	}
	file.copy(tld_file("FUNDING.yml"), ".github/FUNDING.yml", overwrite = TRUE)

	invisible(NULL)
}
