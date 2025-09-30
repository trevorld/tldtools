#' Check GitHub settings
#'
#' `check_github_settings()` checks GitHub settings
#' @examples
#' \dontrun{
#'   # requires `gh` installed and authenticated and working directory in Github repository
#'   check_github_settings()
#' }
#' @return `NULL` invisibly.  As a side effect prints a message.
#' @export
check_github_settings <- function() {
     fields <- c(
         "nameWithOwner",
         "deleteBranchOnMerge",
         "description",
         "hasDiscussionsEnabled",
         "hasIssuesEnabled",
         "hasProjectsEnabled",
         "hasWikiEnabled",
         "homepageUrl",
         "isEmpty",
         "isFork",
         "mergeCommitAllowed",
         "rebaseMergeAllowed",
         "squashMergeAllowed",
         "visibility"
     )
    l <- gh_repo_view(fields = fields)
    mca <- isTRUE(l[["mergeCommitAllowed"]])
    sqa <- isTRUE(l[["squashMergeAllowed"]])
    rma <- isTRUE(l[["rebaseMergeAllowed"]])
    dbom <- isTRUE(l[["deleteBranchOnMerge"]])
    message <- character(0L)
    if (!mca && sqa && rma && dbom)
        message <- c(message, "v" = "Merge settings okay")
    if (mca)
        message <- c(message, "x" = "Merge commits enabled")
    if (!sqa)
        message <- c(message, "x" = "Squash merges disabled")
    if (!rma)
        message <- c(message, "x" = "Rebase merges disabled")
    if (!dbom)
        message <- c(message, "x" = "Delete branch on merge disabled")

    if (nzchar(l[["description"]]))
        message <- c(message, "v" = "Has non-empty description")
    else
        message <- c(message, "x" = "Has empty description")
    if (nzchar(l[["homepageUrl"]]))
        message <- c(message, "v" = "Has non-empty homepage URL")
    else
        message <- c(message, "x" = "Has empty homepage URL")

    hde <- isTRUE(l[["hasDiscussionsEnabled"]])
    hie <- isTRUE(l[["hasIssuesEnabled"]])
    hpe <- isTRUE(l[["hasProjectsEnabled"]])
    hwe <- isTRUE(l[["hasWikiEnabled"]])
    if (!hde && hie && !hpe && !hwe)
        message <- c(message, "v" = "GitHub feature settings okay")
    if (hde)
        message <- c(message, "x" = "GitHub Discussions enabled")
    if (!hie)
        message <- c(message, "x" = "GitHub Issues disabled")
    if (hpe)
        message <- c(message, "x" = "GitHub Projects enabled")
    if (hwe)
        message <- c(message, "x" = "GitHub Wiki enabled")

    cli_inform(message, class = "tldtools_check_github_settings")
    invisible(NULL)
}

