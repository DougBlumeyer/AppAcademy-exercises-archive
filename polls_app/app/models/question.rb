class Question < ActiveRecord::Base
  validates :question_text, presence: true
  validates :poll_id, presence: true

  belongs_to(
    :poll,
    class_name: 'Poll',
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: 'AnswerChoice',
    foreign_key: :question_id,
    primary_key: :id
  )

  has_many(:responses, through: :answer_choices, source: :responses)

  def results
    # results_hash = {}
    # answer_choices.each do |answer_choice|
    #   results_hash[answer_choice.answer_text] = answer_choice.responses.count
    # end
    #
    # results_hash

    # results_hash = {}
    # answer_choices = self.answer_choices.includes(:responses)
    # answer_choices.each do |answer_choice|
    #   results_hash[answer_choice.answer_text] = answer_choice.responses.length
    # end
    #
    # results_hash

    # SELECT
    #   answer_choices.*, COUNT(responses.id)
    # FROM
    #   answer_choices
    # LEFT OUTER JOIN
    #   responses ON answer_choices.id = responses.answer_choice_id
    # WHERE
    #   answer_choices.question_id = ?
    # GROUP BY
    #   answer_choices.id

    results_hash = {}
    answer_choices = self.answer_choices
      .joins('LEFT OUTER JOIN responses r ON r.answer_choice_id = answer_choices.id')
      .where('answer_choices.question_id = ?', self.id) #ah, didn't need this because it's already only our own answer choices
      .select('answer_choices.*, COUNT(r.id) as response_count')
      .group('answer_choices.id')

    answer_choices.each do |answer_choice|
      results_hash[answer_choice.answer_text] = answer_choice.response_count
    end

    results_hash
  end
end
