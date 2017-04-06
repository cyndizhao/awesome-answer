# this is our Question model it inhertis from `ApplicationRecord` which inherits
# from `ActiveRecord::Base` which is a class that comes from Rails.
# All the funcationalities we're going to be using in our Quesiton model come
# from `ActiveRecord::Base` which leverages Ruby's meta programming features.
class Question < ApplicationRecord
  # dependent: :destroy will delete all associated answers before deleting the
  #                     question when you call `question.destroy`
  # dependent: :nullify will update the `question_id` field to `null` in all the
  #                     associated answers before deleting the question when you
  #                     call `question.destroy`
  #!!!!!!!!REMEBER always add dependent!!!!!!
  has_many :answers, dependent: :destroy
  belongs_to :user, optional:true
  #belongs_to :subject will enforce validation that the association must be present by default
  #to make it optional, give belongs_to a second argument 'optional: true'
  belongs_to :subject, optional: true
  # has_many :answers adds the following instance methods
  # to this model, Question:
  # answers
  # answers<<(object, ...)
  # answers.delete(object, ...)
  # answers.destroy(object, ...)
  # answers=(objects)
  # answers
  # answers=(ids)
  # answers.clear
  # answers.empty?
  # answers.size
  # answers.find(...)
  # answers.where(...)
  # answers.exists?(...)
  # answers.build(attributes = {}, ...)
  # answers.create(attributes = {})
  # answers.create!(attributes = {})
  # http://guides.rubyonrails.org/association_basics.html#has-many-association-reference


  # validates :title, presence: true
  # validates(:title, { presence: true, uniqueness: true })
  validates(:title, { presence: { message: 'must be present!' }, uniqueness: true })


  # validates :body, presence: true
  validates(:body,{ presence: true, length: { minimum: 5 } })

  # validates :view_count, presence: true

  validates(:view_count, { presence: true, numericality: { greater_than_or_equal_to: 0 }})

  validate :no_monkey

  after_initialize :set_defaults
  #callback
  before_validation :titleize_title

  # scope :recent_five, lambda { order(created_at: :desc).limit(5) }

  def self.recent_five #This is a class method, Question.recent_five; not a private method,so we can call it outside of this file
    order(created_at: :desc).limit(5)
  end

  def self.recent(number)
    order(created_at: :desc).limit(number)
  end


  private

  def titleize_title #This is a instance method.
    self.title = title.titleize if title.present?
    #self???
  end

  def set_defaults
    self.view_count ||= 0

  end

  def no_monkey
    if title.present? && title.downcase.include?('monkey')
      # this will make the record invalid, even if there is one error on the
      # record by using `errors.add` then the record won't save because it won't
      # be valid
      errors.add(:title, 'can\'t include monkey!')
    end
  end


end
