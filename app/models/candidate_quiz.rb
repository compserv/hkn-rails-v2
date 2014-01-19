# == Schema Information
#
# Table name: candidate_quizzes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  score      :integer
#  created_at :datetime
#  updated_at :datetime
#

class CandidateQuiz < ActiveRecord::Base
  belongs_to :user
  has_many :quiz_questions, through: :quiz_responses
  has_many :quiz_responses
  before_create :set_default_quiz_score

  validates :user_id, presence: true, uniqueness: true

  def set_quiz_score
    self.score ||= 0
  end

  def grade
    self.score = 0
    self.quiz_responses.each do |resp|
      self.score += 1 if resp.correct?
    end
    self.save
  end
end
