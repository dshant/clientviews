class AddNotificationSlackChannelToSurveys < ActiveRecord::Migration[6.1]
  def change
    add_column :surveys, :notification_slack_channel, :string
  end
end
