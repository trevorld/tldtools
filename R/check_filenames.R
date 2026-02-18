#' Check R file extensions
#'
#' `check_filenames()` checks that all R files use `.R` extension instead of `.r`
#' and that there is no `raw-data` directory (use `data-raw` instead).
#' @examples
#' \dontrun{
#'   check_filenames()
#' }
#' @return `NULL` invisibly.  As a side effect prints a message.
#' @seealso [use_tld_filenames()]
#' @export
check_filenames <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	r_files <- list.files(".", pattern = "\\.r$", recursive = TRUE)
	if (length(r_files)) {
		msg_r <- c("x" = "{length(r_files)} R files use an `.r` extension instead of `.R`")
	} else {
		msg_r <- c("v" = "All R files use `.R` extension")
	}

	if (dir.exists("raw-data")) {
		msg_dir <- c("x" = "Directory `raw-data` exists, use `data-raw` instead")
	} else {
		msg_dir <- c("v" = "No `raw-data` directory found")
	}

	cli_inform(c(msg_r, msg_dir), class = "tldtools_check_filenames")
	invisible(NULL)
}

#' Rename `.r` files to `.R`
#'
#' `use_tld_filenames()` renames all R files ending with `.r` to use `.R` instead.
#' @examples
#' \dontrun{
#'   use_tld_filenames()
#' }
#' @return `NULL` invisibly.  As a side effect renames files and runs `devtools::document()`.
#' @seealso [check_filenames()]
#' @export
use_tld_filenames <- function() {
	stopifnot(file.exists("DESCRIPTION"))

	r_files <- list.files(".", pattern = "\\.r$", recursive = TRUE, full.names = TRUE)
	R_files <- sub("\\.r$", ".R", r_files)
	for (i in seq_along(r_files)) {
		status <- system2("git", c("mv", r_files[i], R_files[i]), stdout = FALSE, stderr = FALSE)
		if (status != 0L) {
			file.rename(r_files[i], R_files[i])
		}
	}
	if (length(r_files)) {
		devtools::document()
	}

	invisible(NULL)
}
