# == Schema Information
#
# Table name: quiz_questions
#
#  id         :integer          not null, primary key
#  question   :string(255)
#  answer     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class QuizQuestion < ActiveRecord::Base
  has_many :candidate_quizzes, through: :quiz_responses
  has_many :quiz_responses

  validates :question, presence: true
  validates :answer, presence: true
end
