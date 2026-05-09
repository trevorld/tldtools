#' Check GitHub sponsor button setup
#'
#' `check_github_sponsors()` checks the GitHub sponsor button setup.
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
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

	nwo <- ghcli::gh_repo_view(fields = "nameWithOwner")[["nameWithOwner"]]
	parts <- strsplit(nwo, "/")[[1L]]
	result <- ghcli::gh_api_graphql(
		'query($owner: String!, $name: String!) {
		    repository(owner: $owner, name: $name) { hasSponsorshipsEnabled }
		}',
		variables = list(owner = parts[1L], name = parts[2L])
	)
	if (isTRUE(result[["repository"]][["hasSponsorshipsEnabled"]])) {
		message <- c(message, "v" = "GitHub Sponsors button enabled")
	} else {
		message <- c(message, "x" = "GitHub Sponsors button not enabled")
	}

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
