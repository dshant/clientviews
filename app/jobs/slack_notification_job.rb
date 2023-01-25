class SlackNotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers
  queue_as :default

  def perform(response)
    text = {
      blocks: [
        {
          type: "section",
    			text: {
    				type: "mrkdwn",
    				text: "Sweet! You have a new response to your survey. Check it out below."
    			}
    		},
        {
          type: "section",
    			text: {
    				type: "mrkdwn",
    				text: "> #{msg(response)}"
    			}
    		},
        {
    			type: "actions",
    			elements: [
            {
      				type: "button",
      				text: {
      					type: "plain_text",
      					text: "Check it out!",
      					emoji: true
      				},
      				url: response_url(response),
      				action_id: "button-action"
            }
    			]
    		}
      ]
    }

    puts "JSON: #{JSON.dump(text)}"

    client = Slack::Web::Client.new(token: response.survey.account.slack.settings.dig('access_token'))

    client.chat_postMessage(channel: response.survey.notification_slack_channel, **text)
    # Do something later
  end

  def msg(response)
    msg_txt = "#{response.value}"
    msg_txt += " of #{response.survey.counter_max}" if response.survey_type.in? %w(scale scale_w_text)
    msg_txt += " of 5 #{response.survey.rating_icon == 'stars' ? ':star:' : ':heart'}'s" if response.survey_type.in? %w(rating rating_w_text)
    msg_txt += "\nAdditional Message: \n>#{response.extra_text}" if response.extra_text.present?
    msg_txt
  end

end
