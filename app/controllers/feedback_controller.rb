class FeedbackController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    recommendation = params[:recommendation]
    comment = params[:comment]
    feedback = Feedback.create_or_update_feedback(current_user, recommendation, comment)
    if feedback.present?
      @message = "Thanks for your feedback!"
      @success = true
    else
      @message = "Please give us your recommendation"
    end
  end
end
