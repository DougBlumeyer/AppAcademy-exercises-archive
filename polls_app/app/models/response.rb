class Response < ActiveRecord::Base
  validate :respondent_has_not_already_answered_question
  validates :respondent_id, presence: true
  validates :answer_choice_id, presence: true
  validate :author_cant_respond_to_own_poll

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :respondent_id,
    primary_key: :id
  )

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  has_one(:question, through: :answer_choice, source: :question)

  def sibling_responses
    question.responses.where('responses.id <> ? OR ? IS NULL', id, id)
  end

  # private
  def respondent_has_not_already_answered_question
    if sibling_responses.map(&:respondent_id).include?(self.respondent_id)
      errors[:already_answered] << "you can't answer the same question twice"
    end
  end

  def author_cant_respond_to_own_poll
    if respondent.authored_polls.map(&:id).include?(answer_choice.question.poll.id) #LoD!!
      errors[:self_response] << "you can't respond to your own poll"
    end
  end

  # SELECT
  #   q.poll_id
  # FROM
  #   questions q
  # JOIN
  #   answer_choices a ON a.question_id = q.id
  # JOIN
  #   responses r ON r.answer_choice_id = a.id
  # JOIN
  #   users u ON u.id = r.respondent_id = u.id
def improved_author_cant_respond_to_own_poll
  query = <<-SQL
    SELECT
      p.*
    FROM
      responses r
    FULL JOIN
      answer_choices a ON a.id = r.answer_choice_id
    FULL JOIN
      questions q ON q.id = a.question_id
    FULL JOIN
      polls p ON p.id = q.poll_id
    WHERE
      #{self.answer_choice_id} = a.id

  SQL

  poll = Poll.find_by_sql(query).first
  # byebug

  if poll.author_id == self.respondent_id
    errors[:whatever] << "whatever"
  end
end

# "#{self.respondent_id}"


end
