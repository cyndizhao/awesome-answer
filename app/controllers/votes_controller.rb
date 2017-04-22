class VotesController < ApplicationController
  before_action :authenticate_user!
  # TODO: build and enforce permissions for the actions in this controller

  def create
    # render json: params
    question = Question.find params[:question_id]
    vote = Vote.new is_up: params[:is_up], user: current_user, question: question
    if vote.save
      redirect_to question_path(question), notice: 'Voted'
    else
      redirect_to question_path(question), alert: vote.errors.full_messages.join(", ")
    end
  end

  def update
    vote = Vote.find params[:id]
    vote.is_up = params[:is_up]
    if vote.save
      redirect_to vote.question, notice: 'Vote changed'
    else
      redirect_to vote.question, alert: vote.errors.full_messages.join(', ')
    end
  end

  def destroy
    # render plain: 'in vote destroy'
    vote = Vote.find params[:id]
    vote.destroy
    redirect_to question_path(vote.question), notice: 'Vote removed'
  end
end
