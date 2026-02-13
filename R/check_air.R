#' Check `air` setup
#'
#' `check_air()` checks the `air` setup
#' @examples
#' \dontrun{
#'   check_air()
#' }
#' @return `NULL` invisibly.  As a side effect prints a message.
#' @seealso [use_tld_air()]
#' @export
check_air <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	message <- character(0L)
	if (file.exists("air.toml")) {
		message <- c(message, "x" = "`.air.toml` is preferred to `air.toml`")
	}

	message <- c(message, check_file(".air.toml"))
	message <- c(message, check_file(".editorconfig"))
	message <- c(message, check_file(".pre-commit-config.yaml"))
	message <- c(message, check_file(".github/workflows/air-check.yaml"))

	if (!file.exists(".git/hooks/pre-commit")) {
		message <- c(message, "x" = "Pre-commit hook not installed")
	} else {
		message <- c(message, "v" = "Pre-commit hook installed")
	}

	patterns <- c(
		"^\\.air.toml$",
		"^\\.editorconfig$",
		"^\\.git$",
		"^\\.github$",
		"^\\.pre-commit-config.yaml$"
	)

	message <- c(message, check_Rbuildignore(patterns))

	cli_inform(message, class = "tldtools_check_air")
	invisible(NULL)
}

#' Use Trevor's preferred `air` settings
#'
#' `use_tld_air()` uses Trevor's preferred `air` settings.
#' @examples
#' \dontrun{
#'   use_tld_air()
#' }
#' @return `NULL` invisibly.  As a side effect writes several files.
#' @seealso [check_air()]
#' @export
use_tld_air <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	file.copy(tld_file(".air.toml"), ".air.toml", overwrite = TRUE)
	file.copy(tld_file(".editorconfig"), ".editorconfig", overwrite = TRUE)
	file.copy(tld_file(".pre-commit-config.yaml"), ".pre-commit-config.yaml", overwrite = TRUE)
	if (!dir.exists(".github/workflows")) {
		dir.create(".github/workflows", recursive = TRUE)
	}
	file.copy(tld_file("air-check.yaml"), ".github/workflows/air-check.yaml", overwrite = TRUE)

	invisible(NULL)
}


#' Use Trevor's preferred `.Rbuildignore` file
#'
#' `use_tld_Rbuildignore()` uses Trevor's preferred `.Rbuildignore` file.
#' @examples
#' \dontrun{
#'   use_tld_Rbuildignore()
#' }
#' @return `NULL` invisibly.  As a side effect write a file.
#' @export
use_tld_Rbuildignore <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	file.copy(tld_file(".Rbuildignore"), ".Rbuildignore", overwrite = TRUE)
	invisible(NULL)
}
