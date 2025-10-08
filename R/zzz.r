#' @importFrom cli cli_inform
#' @importFrom dplyr .data
NULL

tld_file <- function(filename) system.file("config", filename, package = "tldtools")

are_files_same <- function(local_file, stored_file = basename(local_file)) {
	tools::md5sum(local_file) == tools::md5sum(tld_file(stored_file))
}

check_file <- function(local_file) {
	if (!file.exists(local_file)) {
		c("x" = paste0("`", local_file, "` does not exist"))
	} else if (!are_files_same(local_file)) {
		c("x" = paste0("`", local_file, "` is different from the one provided by {{tldtools}}"))
	} else {
		c("v" = paste0("`", local_file, "` is as expected"))
	}
}

check_Rbuildignore <- function(patterns) {
	message <- character(0L)
	if (file.exists(".Rbuildignore")) {
		rbi <- readLines(".Rbuildignore")
		for (pattern in patterns) {
			if (!(pattern %in% rbi)) {
				message <- c(message, "x" = paste0("`", pattern, "` not in `.Rbuildignore`"))
			}
		}
		if (!length(message)) {
			message <- c(message, "v" = "Expected patterns in `.Rbuildignore`")
		}
	} else {
		message <- c(message, "x" = "`.Rbuildignore` does not exist")
	}
	message
}
