json.array! @questions do |question|
  json.id question.id
  json.title question.title
  # json.url question_url(question)
  json.url api_v1_question_url(question)

end
