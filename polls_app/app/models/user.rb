class User < ActiveRecord::Base
  validates :user_name, uniqueness: true, presence: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: 'Response',
    foreign_key: :respondent_id,
    primary_key: :id
  )

  has_many(
    :answered_choices,
    through: :responses,
    source: :answer_choice
  )

  has_many(
    :answered_polls,
    -> { distinct },
    through: :answered_choices,
    source: :poll
  )

  def completed_polls
    #puts "HELLLOOOOO"
    #polls user has completed???
    # query = <<-SQL
    #   SELECT
    #     p.*, COUNT(q.id), COUNT(r.id)
    #   FROM
    #     polls AS p
    #   JOIN
    #     questions AS q ON q.poll_id = p.id
    #   LEFT OUTER JOIN
    #     answer_choices AS a ON a.question_id = q.id
    #   LEFT OUTER JOIN (SELECT
    #                     *
    #                    FROM
    #                     responses
    #                    WHERE
    #                     respondent_id = ? ) AS r ON r.answer_choice_id = a.id
    #
    #   GROUP BY
    #     p.id
    #   HAVING
    #     COUNT(q.id) = COUNT(r.id)
    # SQL
    #
    # Poll.find_by_sql([query, self.id])

    query = <<-SQL
    LEFT OUTER JOIN (SELECT
                          *
                        FROM
                          responses
                        WHERE
                          respondent_id = #{self.id} ) AS r ON r.answer_choice_id = a.id
    SQL

    something = Poll.select('polls.*')
      .joins(:questions)
      .joins('LEFT OUTER JOIN answer_choices AS a ON a.question_id = questions.id')
      .joins(query)
      .group('polls.id')
      .having('COUNT(questions.id) = COUNT(r.id)')
      #.pluck(polls.title)
      #

    # Poll.joins(:questions)
    #   .joins('LEFT OUTER JOIN answer_choices AS a ON a.question_id = questions.id')
    #   .joins(query, self.id)
    #   .select('polls.*, COUNT(questions.id) AS q_per_p, COUNT(responses.id) AS r_per_u')
    #   .group('polls.id')
    #   .having('q_per_p = r_per_u')

    # #polls user has answered any questions for
    # query = <<-SQL
    # SELECT DISTINCT
    #   p.id
    # FROM
    #   polls p
    # JOIN
    #   questions q ON q.poll_id = p.id
    # JOIN
    #   answer_choices a ON a.question_id = q.id
    # LEFT OUTER JOIN
    #   responses r ON r.answer_choice_id = a.id
    # JOIN
    #   users u ON u.id = r.respondent_id
    # WHERE
    #   u.id = ?
    # SQL
    #   Poll.find_by_sql([query, self.id])
    something
  end

  def uncompleted_polls
    query = <<-SQL
    LEFT OUTER JOIN (SELECT
    *
    FROM
    responses
    WHERE
    respondent_id = #{self.id} ) AS r ON r.answer_choice_id = a.id
    SQL

    Poll.select('polls.*')
    .joins(:questions)
    .joins('LEFT OUTER JOIN answer_choices AS a ON a.question_id = questions.id')
    .joins(query)
    .group('polls.id')
    .having('COUNT(r.id) > 0 AND COUNT(questions.id) > COUNT(r.id)')
  end

  # SELECT p.*, COUNT(q.id) as q_per_p, COUNT(r.id) as r_per_u
  # FROM polls p
  # JOIN questions q ON  q.poll_id = p.id
  # LEFT OUTER JOIN answer_choices a on a.question_id = q.id
  # LEFT OUTER JOIN responses r on r.answer_choice_id = a.id
  # WHERE r.user_id = #{self.id}
  # GROUP BY poll.id
  # HAVING q_per_p = r_per_u

end
