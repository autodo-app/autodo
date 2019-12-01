workflow "on reviews" {
  on = "pull_request_review"
  resolves = ["shfmt"]
}

action "shfmt" {
  uses = "bltavares/actions/shfmt@master"
  args = ["autofix"]
  env = {
    AUTOFIX_EVENTS="pull_request|push"
  }
  secrets = ["GITHUB_TOKEN"]
  needs = ["action-filter"]
}

action "action-filter" {
  uses = "actions/bin/filter@master"
  args = "action 'opened|ready_for_review|synchronize'"
}