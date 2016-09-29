class SlackMessageSender
  def initialize(message)
    @message = message
  end

  def send
    slack_poster.ping @message
  end

  private

  def slack_poster
    # YOUR SLACK WEBHOOK
    @slack_poster = Slack::Notifier.new ""
  end
end
