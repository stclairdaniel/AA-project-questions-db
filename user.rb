require_relative 'questionsdb_connection'

class User
  attr_accessor :fname, :lname
  attr_reader :id

  def self.table
    'users'
  end

  def self.find_by_id(id)
    user = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        users.id = ?
      SQL

    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        users.fname = ? AND users.lname = ?
      SQL

    User.new(user.first)
  end


  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def save
    unless @id
      QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname)
        INSERT INTO
          users (fname, lname)
        VALUES
          (?, ?)
      SQL
      @id = QuestionsDBConnection.instance.last_insert_row_id
    else
      QuestionsDBConnection.instance.execute(<<-SQL, @fname, @lname, @id)
        UPDATE
          users
        SET
          fname = ? , lname = ?
        WHERE
          id = ?
      SQL
    end
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_author_id(@id)
  end

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    number_of_questions = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        (CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id))) AS karma
      FROM
        questions
      LEFT OUTER JOIN
        question_likes ON question_likes.question_id = questions.id
      WHERE
        questions.author_id = ?
    SQL
  end
end
