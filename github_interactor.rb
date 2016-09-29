require "octokit"
require "slack-notifier"
require "./slack_message_sender"

class GithubInteractor

  def pull_requests
    pull_requests = []
    repo_names.each do |rn|
      temp_pull_requests = client.pull_requests(rn)
      new_pull_requests = temp_pull_requests.select{|pr| old_pull_request(pr) == false}
      
      if new_pull_requests.count > 0
        pull_requests << "*#{rn} (Total Pull Requests: #{new_pull_requests.count})*"
        pull_requests << new_pull_requests.map{|pr| formatted_pull_request(pr)}
      end
    end
    
    if pull_requests.count > 1
      message = pull_requests.join("\n")
      SlackMessageSender.new(message).send
    end
  end

  private
  
  def repos
    @repos ||= client.organization_repositories('Tariffic')
  end

  def repo_names
    [
      # Example: cameronnorman/github_informer
    ]
  end

  def pull_request_user pull_request
    pull_request.user.login
  end

  def pull_request_url pull_request
    pull_request.html_url
  end

  def pull_request_age pull_request
    Date.today.mjd - Date.parse(pull_request.created_at.to_s).mjd
  end

  def formatted_pull_request pull_request
    pull_request_user = pull_request_user pull_request
    pull_request_url = pull_request_url pull_request
    pull_request_days = pull_request_age(pull_request)
    
    "#{pull_request_url} - #{pull_request_user} - _#{pull_request_days} day(s) old_"
  end

  def old_pull_request pull_request
    pull_request_age(pull_request) > 500
  end
  
  def client
    # YOUR GITHUB ACCESS TOKEN
    @client = Octokit::Client.new(:access_token => "")
  end
end
