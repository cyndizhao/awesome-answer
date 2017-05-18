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
    @question = Question.find(params[:question_id])
    if cannot? :like, @question
      redirect_to question_path(@question), alert: 'liking your own question is disgusting'
      return
    end


    like = Like.new(user: current_user, question: @question)

    respond_to do |format|
      if like.save
        format.html {redirect_to question_path(@question), notice: 'Question liked'}
        format.js {render :render_like}
      else
        format.html {redirect_to question_path(@question), alert: like.errors.full_messages.join(', ')}
        format.js {render :render_like}
      end
    end
  end

  def destroy
    like = Like.find(params[:id])
    @question = Question.find(params[:question_id])
    if cannot? :like, @question
      redirect_to question_path(@question), alert: 'Can not Unliking your own question'
      return
    end

    respond_to do |format|
      if like.destroy
        format.html {redirect_to question_path(@question), notice:'Un-liked question!'}
        format.js {render :render_like}
      else
        format.html {redirect_to question_path(@question), alert: like.errors.full_messages.join(', ')}
        format.js {render :render_like}
      end
    end
  end
end
