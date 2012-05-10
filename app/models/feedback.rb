class Feedback < ActiveRecord::Base
  belongs_to :user
  validates_uniqueness_of :user_id
  
  def self.create_or_update_feedback(user, recommendation, comment)
    return nil unless ["yes", "no"].include?(recommendation) || user.nil?
    recommendation = (recommendation == "yes" ? true : false)
    feedback = user.feedback
    if feedback.present?
      feedback.update_attributes({:recommendation => recommendation, :comment => comment})
    else
      feedback = Feedback.create(:user_id => user.id, :recommendation => recommendation, :comment => comment)
    end
    return feedback
  end
end
