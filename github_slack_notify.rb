require "octokit"
require "slack-notifier"
require "./github_interactor"
require "./slack_message_sender"

GithubInteractor.new.pull_requests
