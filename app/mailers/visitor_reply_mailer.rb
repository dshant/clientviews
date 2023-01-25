class VisitorReplyMailer < ApplicationMailer
  def notification_email
    @reply = params[:reply]
    to = @reply.response.survey.account.users.first.email
    @preview = "On of your visitors has responded!"
    bootstrap_mail(
      to: to,
      subject: "You have a new response on your survey!",
    )
  end
end
