class AnswersController < ApplicationController
  def create
    # byebug
    @question = Question.find(params[:question_id])
    answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new(answer_params)
    @answer.question = @question
    #@answer = @question.answers.build(answer_params)

    if @answer.save
      #sending an email to Question user
      # AnswersMailer.notify_question_owner(@answer).deliver_now
      AnswersMailer.notify_question_owner(@answer).deliver_later

      redirect_to question_path(@question), notice:'Answer Created'
    else
      #redirect_to question_path(@question), alert: "Couldn't Create Answer!"
      render '/questions/show'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    answer.destroy
    redirect_to question_path(answer.question), notice: "Answer deleted!"
  end
end
