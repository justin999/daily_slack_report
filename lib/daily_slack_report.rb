require "daily_slack_report/version"
require "daily_slack_report/o_auth"
require "slack"

module DailySlackReport
  # Your code goes here...
  def self.client
    require "slack"
    Slack.configure do |config|
      config.token = "your_token"
    end
    client = Slack.client
  end

  def self.get_channel_id(client, channel_name = 'general')
    params = {
      token: "your_token",
    }
    list = client.channels_list params
    channel_id = ""
    list["channels"].each do |channel|
      if channel["name"] == channel_name
        channel_id = channel["id"]
      end
    end
    channel_id
  end

  def self.get_chat_history(client, channels_id, target_date)
    require 'Time'
    options = {
      channels_id: channels_id,
      latest: Time.new(target_date.year, target_date.month, target_date.day,  0,  0,  0),
      oldest: Time.new(target_date.year, target_date.month, target_date.day, 23, 59, 59)
    }
    client.channels_history options
  end
end
