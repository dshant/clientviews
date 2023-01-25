class ResponsesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:view_reply, :respond]

  def index
    @responses = Response.includes(:video_asset, :survey).where(survey_id: Current.account.surveys.pluck(:id).compact).order(created_at: :desc)
    @tags = ActsAsTaggableOn::Tagging.includes(:tag).where(taggable_type: "Response", taggable_id: Current.account.surveys.includes(:responses).flat_map(&:responses).pluck(:id))
    if params[:view] == "conversations"
      @responses = @responses.where.not(email: [nil, ""])
    elsif params[:view] == "no_info"
      @responses = @responses.where(email: [nil, ""])
    elsif params[:tag].present?
      searched_tags = @tags.where({tag: {name: params[:tag]}})
      rids = searched_tags.pluck(:taggable_id)
      @responses = @responses.where(id: rids)
    end
    @pagy = pagy(@responses).first
  end

  def update
    @response = Response.find(params[:id])
    @response.tag_list = params.dig(:response, :tag_list)&.reject!(&:blank?) || []
    if @response.save
      msg = {success: 'Tag(s) were updated'}
    else
      msg = {warning: 'Tag(s) were unable to be saved'}
    end
    redirect_to response_path(@response), flash: msg
  end

  def reply
    @response = Response.find(params[:response_id])
    @reply = @response.replies.new(message: params[:message], from: Current.user.id, source: 'userveys')
    if @reply.save
      msg = {success: 'Reply was added'}
    else
      msg = {warning: 'Reply was unable to be saved'}
    end
    ProcessReplyJob.perform_later(@reply)
    redirect_to response_path(@response), flash: msg
  end

  def view_reply
    @reply = Reply.includes(:response).find(params[:id])
    render layout: 'layouts/reply'
  end

  def respond
    @response = Response.find(params[:response_id])
    @reply = @response.replies.new(message: params[:message], from: @response.email, source: 'visitor')
    if @reply.save
      msg = {success: 'Reply was added'}
    else
      msg = {warning: 'Reply was unable to be saved'}
    end
    ProcessReplyJob.perform_later(@reply)
    redirect_to response_view_reply_path(@response, @reply), flash: msg
  end

  def show
    @response = Response.find(params[:id])
  end

  def destroy
    @response = Response.find(params[:id])

    @response.destroy

    redirect_back(fallback_location: responses_path)
  end

  private

  def response_params
    params.require(:response).permit(:tag_list)
  end
end
