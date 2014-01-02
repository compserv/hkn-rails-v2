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

require 'spec_helper'

describe CandidateQuiz do
    before do
        @quiz = CandidateQuiz.new(id: 1, user_id: 1)
        @question = QuizQuestion.new(id: 1, answer: "answer", question: "test")
        @quiz.save
        @question.save
        @resp = @quiz.quiz_responses.create(quiz_question_id: 1, response: "answer")
    end

    subject { @resp }

    it { should be_valid }
    it { should be_correct }

    describe "incorrect response" do
        before { @resp.response = "not the answer" }
        it { should_not be_correct }
    end

    describe "multi-response" do
        before do
            @question.answer = "navy blue, scarlet"
            @question.save
            @resp.response = "navy blue, scarlet"
        end
        it { should be_correct }

        describe "out of order" do
            before do
                @resp.response = "scarlet, navy blue"
                @question.answer = "navy blue, scarlet"
                @question.save
            end
            it { should_not be_correct }
        end
    end
end
