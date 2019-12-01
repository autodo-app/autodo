workflow "on push" {
  on = "push"
  resolves = ["dartfmt"]
}

# Used for fix on review
# Don't enable if you plan using autofix on push
# Or there might be race conditions
workflow "on review" {
  resolves = ["dartfmt"]
  on = "pull_request_review"
}

action "dartfmt" {
  uses = "bltavares/actions/dartfmt@master"
  # Enable autofix on push
  # args = ["autofix"]
  # Used for pushing changes for `fix` comments on review
  secrets = ["${{ secrets.TOKEN }}"]
}