class Api::V1::QuestionsController < Api::BaseController
  def index
    @questions = Question.order(created_at: :DESC)
    # render json: @questions
  end

  def show
    @question = Question.find params[:id]
    # render json: question.to_json

    # if the format is JSON and we're using jbuilder as our templating system
    # what file will be rendered?
    # /views/api/v1/questions/show.json.jbuilder

    #using "render json: @question" will use Serializer for the quesiton model
    #using "render :show " or no render will use the corresponding view for the specific format
  end

  def create
    question_params = params.require(:question).permit(:title, :body)
    question = Question.new question_params
    question.user = @user

    if  question.save
      head :ok
    else
      render json: {error: question.errors.full_messages.join(', ')}
    end
  end

end
