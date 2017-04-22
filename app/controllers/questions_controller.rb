class QuestionsController < ApplicationController

  # the `before_action` method registers another method in this case it's the
  # `find_quesiton` method which will be executed just before the actions you
  # specify in the `only` array. Keep in mind that the method that gets executed
  # as a `before_action` happens within the same request/response cycle so if
  # you define an instance variable you can use it within the action / views
  before_action :find_question, only: [:show, :edit, :update, :destroy]
  #before_action :question_params, only: [:create, :update]

  before_action :authenticate_user!, except: [:show, :index]


  def new
    # render plain: 'inside questions new'
    #just for test

    @question = Question.new
    # we instaniate a new `Question` object because it will help us in
    # generating the form in `views/new.html.erb`. We have to make it an
    # instance variable so we can access it in the view file.

  end

  def create
    @question = Question.new question_params
    @question.user = current_user
    #question_params is a function, we use the result it returns here
    if @question.save
      RemindQuestionOwnerJob.set(wait: 5.days).perform_later(@question.id)
      # Rails gives us access to `flash` object which looks like a Hash. flash
      # utilizes cookies to store a bit of information that we can access in the
      # next request. Flash will automatically be deleted when it's displayed.
      flash[:notice] = 'Question created!'


      #three ways
      redirect_to question_path({id: @question.id})
      #redirect_to question_path(@question.id)
      #redirect_to question_path(@question)
      # render plain:'Question created successfully'
    else
      # render plain: "Errors: #{question.errors.full_messages.join(', ')}"
      # if you want to show a flash message when you're doing `render` instead
      # of `redirect` meaning that you want to show he flash message within the
      # same request/response cycle, then you will need to use flash.now
      flash.now[:alert] = 'Please fix errors below'
      render :new
      #render '/questions/new' the same with 'render:new' because '#new' and '#create' are in the same controller
    end

    #Rails.logger.info '>>>>>>>>>>>>>>'
    #Rails.logger.info question.errors.full_message
    #show the information of ROLLBACK ERROR
    #Rails.logger.info '>>>>>>>>>>>>>>'


    #render json: params
    # {
    # "utf8": "✓",
    # "authenticity_token": "2PhUTka2uKXChfH9iSWUc9d9r93kg34rxCi+D3+wM42p2dqULCRtBLmfEnwISFmllJN6LUwp88CEJZiVK+4AEQ==",
    # "question": {
    #   "title": "title1",
    #   "body": "body1"
    # },
    # "commit": "Create Question",
    # "controller": "questions",
    # "action": "create"
    # }
  end

  def show
    # @question = Question.find params[:id]  define in before_action :find_question
    @answer = Answer.new
  end

  def index
    @questions = Question.last(20)
  end

  def edit
    # @question = Question.find params[:id]
    # render plain: 'inside question edit'
    redirect_to root_path, alert:'access denied' unless can? :edit, @question
    # can? is a helper method that came from CanCanCan which helps us enforce
    # permission rules in the controllers and views

  end

  def update
    if !(can? :edit, @question)
      redirect_to root_path, alert:'access denied'
    # @question = Question.find params[:id]
    # question_params = params.require(:question).permit([:title, :body])
    elsif @question.update(question_params)
      #question_params is a function, we call it here and use the result it returns
      redirect_to question_path(@question), notice: 'Question Updated'
      #
    else
      render :edit
    end
  end

  def destroy
    if can? :destroy, @question
      # question = Question.find params[:id]
      @question.destroy
      redirect_to questions_path, notice:'Question Deleted'
    else
      redirect_to root_path, alert:'access denied'
    end

  end

  private

  def find_question
    @question = Question.find params[:id]
  end

  def question_params
  # the line below is what's called "Strong Parameters" feautre that was added
  # to Rails starting with version 4 to help developer be more explicit about
  # the parameters that they want to allow the user to submit
  params.require(:question).permit([:title, :body, { tag_ids:[] }])


  #@question_params = params.require(:question).permit([:title, :body])
  #above works when you use before_action, but we try to reduce the amount of instance/variables
  end

end
