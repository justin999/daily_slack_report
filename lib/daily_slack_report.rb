require "daily_slack_report/version"
require "daily_slack_report/o_auth"
require "slack"
require "Time"
require "Date"

module DailySlackReport
  # Your code goes here...
  def self.export_nippo(channel_name = 'general', target_date)
    client = DailySlackReport.client
    channle_id = DailySlackReport.get_channel_id(client, channel_name)
    DailySlackReport.get_chat_history(client, channle_id, target_date)
  end

  def self.client
    require "slack"
    Slack.configure do |config|
      config.token = "your_token"
    end
    Slack.client
  end

  def self.get_channel_id(client, channel_name = 'general')
    params = {}
    list = client.channels_list params
    channel_id = ""
    list["channels"].each do |channel|
      if channel["name"] == channel_name
        channel_id = channel["id"]
      end
    end
    channel_id
  end

  def self.get_chat_history(client, channel_id, target_date)
    options = {
      channel: channel_id,
      latest: Time.new(target_date.year, target_date.month, target_date.day, 23, 59, 59).to_i,
      oldest: Time.new(target_date.year, target_date.month, target_date.day,  0,  0,  0).to_i
    }
    data = client.channels_history options
    messages = []
    data["messages"].each do |message|
      messages.unshift message["text"]
    end
    messages
  end
end
