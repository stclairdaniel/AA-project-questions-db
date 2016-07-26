require_relative 'questionsdb_connection'

class QuestionLike
  attr_accessor :user_id, :question_id

  def self.all
  end

  def self.find_by_id(id)
    question_like = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        question_likes.id = ?
      SQL

    QuestionLike.new(question_like.first)
  end

  def self.likers_for_question_id(question_id)
    question_likers = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        question_likes
      JOIN
        users on users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    question_likers.map { |liker| User.new(liker) } unless question_likers.length < 1
  end

  def self.num_likes_for_question_id(question_id)
    num_question_likers = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        COUNT(*) AS value
      FROM
        question_likes
      JOIN
        users on users.id = question_likes.user_id
      WHERE
        question_likes.question_id = ?
    SQL
    num_question_likers.first["value"]
  end

  def self.liked_questions_for_user_id(user_id)
    liked_questions = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_likes
      JOIN
        users on users.id = question_likes.user_id
      JOIN
        questions on question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL
    liked_questions.map { |question| Question.new(question) } unless liked_questions.length < 1
  end

  def self.most_liked_questions(n)
    questions = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT
        questions.id, questions.title, questions.body, questions.author_id
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(*) DESC
      LIMIT
        ?
    SQL
    questions.map { |question| Question.new(question) } unless questions.length < 1
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
