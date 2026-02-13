tld_github_labels <- tibble::tribble(
    ~name, ~description, ~color, ~to_edit,
    "bug", "an unexpected problem or unintended behaviour", "#D55E00", "bug",
    "documentation", "improvements or additions to documentation", "#0072B2", "documentation",
    "duplicate", "this issue or PR already exists", "#000000", "duplicate",
    "external", "related to external software", "#E69F00", "upstream",
    "feature", "a feature request or enhancement", "#56B4E9", "enhancement",
    "good first issue", "good issue for first-time contributors", "#009E73", "good first issue",
    "help wanted", "we'd love your help", "#009E73", "help wanted",
    "invalid", "this doesn't seem right", "#000000", "invalid",
    "question", "further information is requested", "#CC79A7", "question",
    "reprex", "needs a minimal reproducible issue", "#F0E442", "reprex",
    "upkeep", "maintenance, infrastructure, and similar", "#0072B2", "chore",
    "wontfix", "this will not be worked on", "#FFFFFF", "wontfix"
)
class(tld_github_labels$color) <- "gh_color"

#' Check GitHub labels
#'
#' `check_github_labels()` checks GitHub labels.
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
#'   check_github_labels()
#' }
#' @return `NULL` invisibly.  As a side effect prints a message.
#' @seealso [use_tld_github_labels()]
#' @export
check_github_labels <- function() {
	message <- character(0L)

	df <- ghcli::gh_label_list()

	# labels in `df` but not in `tld_github_labels`
	only_in_df <- setdiff(df$name, tld_github_labels$name)
	if (length(only_in_df)) {
		message <- c(
			message,
			"x" = paste("GitHub has extra labels:", paste(only_in_df, collapse = ", "))
		)
	} else {
		message <- c(message, "v" = "GitHub does not have extra labels")
	}

	# labels in `tld_github_labels` but not in `df`
	only_in_tld <- setdiff(tld_github_labels$name, df$name)
	if (length(only_in_tld)) {
		message <- c(
			message,
			"x" = paste("GitHub is missing labels: ", paste(only_in_tld, collapse = ", "))
		)
	} else {
		message <- c(message, "v" = "GitHub is not missing labels")
	}

	# labels in both but different descriptions
	in_both <- intersect(df$name, tld_github_labels$name)
	df_b <- df[which(df$name %in% in_both), ] |>
		dplyr::arrange(.data$name)
	tld_b <- tld_github_labels[which(tld_github_labels$name %in% in_both), ] |>
		dplyr::arrange(.data$name)

	descriptions_different <- which(df_b$description != tld_b$description)
	if (length(descriptions_different)) {
		message <- c(
			message,
			"x" = paste(
				"Different label descriptions: ",
				paste(df_b$name[descriptions_different], collapse = ", ")
			)
		)
	} else {
		message <- c(message, "v" = "Label descriptions are as expected")
	}

	# labels in both but different color
	colors_different <- which(tolower(df_b$color) != tolower(tld_b$color))
	if (length(colors_different)) {
		message <- c(
			message,
			"x" = paste(
				"Different label colors: ",
				paste(df_b$name[colors_different], collapse = ", ")
			)
		)
	} else {
		message <- c(message, "v" = "Label colors are as expected")
	}

	cli_inform(message, class = "tldtools_check_github_settings")
	invisible(NULL)
}

#' Use Trevor's preferred GitHub labels
#'
#' `use_tld_github_labels()` uses Trevor's preferred GitHub labels.
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
#'   use_tld_github_labels()
#' }
#' @return `NULL` invisibly.  As a side effect edits GitHub labels
#' @seealso [check_github_labels()]
#' @export
use_tld_github_labels <- function() {
	df <- ghcli::gh_label_list()

	to_edit <- intersect(tld_github_labels$to_edit, df$name)
	df_to_edit <- tld_github_labels[which(tld_github_labels$to_edit %in% to_edit), ]
	l <- purrr::pmap(df_to_edit, ghcli::gh_label_edit)

	to_edit2 <- intersect(tld_github_labels$name, df$name)
	df_to_edit2 <- tld_github_labels[which(tld_github_labels$name %in% to_edit2), 1:3] |>
		dplyr::rename(to_edit = .data$name)
	l <- purrr::pmap(df_to_edit2, ghcli::gh_label_edit)

	df <- ghcli::gh_label_list()
	to_add <- setdiff(tld_github_labels$name, df$name)
	df_to_add <- tld_github_labels[which(tld_github_labels$name %in% to_add), 1:3]
	l <- purrr::pmap(df_to_add, ghcli::gh_label_create)

	invisible(NULL)
}
