# == Schema Information
#
# Table name: quiz_responses
#
#  id                :integer          not null, primary key
#  quiz_question_id  :integer
#  candidate_quiz_id :integer
#  response          :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

class QuizResponse < ActiveRecord::Base
  belongs_to :quiz_question
  belongs_to :candidate_quiz

  validates :response, presence: true
  validates :quiz_question_id, presence: true
  validates :candidate_quiz_id, presence: true

  def correct?
    response.downcase.split(',').map { |str| str.strip } ==
      self.quiz_question.answer.downcase.split(',').map { |str| str.strip }
  end
end
