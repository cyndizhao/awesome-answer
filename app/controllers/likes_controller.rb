class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    user = User.find(params[:user_id])
    @questions = user.liked_questions

    render 'questions/index'
    #!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!html using "@questions here, not @question in questions_controller index action!!!!!!!!!!"
    #Thus, we only list the questions that have been favourited by current user
  end

  def create
    question = Question.find(params[:question_id])
    if cannot? :like, question
      redirect_to question_path(question), alert: 'liking your own question is disgusting'
      return
    end


    like = Like.new(user: current_user, question: question)
    if like.save
      redirect_to question_path(question), notice: 'Question liked'
    else
      redirect_to question_path(question), alert: like.errors.full_messages.join(', ')
    end
  end

  def destroy
    like = Like.find(params[:id])
    if cannot? :like, like.question
      redirect_to question_path(like.question), alert: 'Can not Unliking your own question'
      return
    end

    if like.destroy
      redirect_to question_path(like.question), notice:'Un-liked question!'
    else
      redirect_to question_path(like.question), alert: like.errors.full_messages.join(', ')
    end
  end
end
