class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user

  def index
    @questions = Question.last(20)
    # render json: @questions
  end

  def show
    @question = Question.find params[:id]
    # render json: question.to_json

    # if the format is JSON and we're using jbuilder as our templating system
    # what file will be rendered?
    # /views/api/v1/questions/show.json.jbuilder
    render json: @question
  end

  private
  def authenticate_user
    @user = User.find_by_api_token params[:api_token]
    # head will send an empty HTTP response with a code that is inferred by the
    # symbol you pass as an argument to the `head` method
    head :unauthorized if @user.blank?
  end

end
