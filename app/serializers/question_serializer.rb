class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :titleized_title, :body
  has_many :answers
  # this will send an array of associated answers with the question using
  # the answer serializer

  
  def titleized_title
    object.title.titleize
  end
end
