require_relative 'questionsdb_connection'

class Reply
  attr_accessor :body, :parent_reply_id, :question_id, :author_id

  def self.all
  end

  def self.find_by_id(id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.id = ?
      SQL

    Reply.new(reply.first) unless reply.length < 1
  end

  def self.find_by_author_id(author_id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.author_id = ?
      SQL

    Reply.new(reply.first) unless reply.length < 1
  end

  def self.find_by_question_id(question_id)
    reply = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.question_id = ?
      SQL

    reply.map { |reply| Reply.new(reply) } unless reply.length < 1
  end

  def self.find_by_parent_id(parent_reply_id)
    replies = QuestionsDBConnection.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        replies.parent_reply_id = ?
      SQL

    replies.map { |reply| Reply.new(reply) } unless reply.length < 1
  end


  def initialize(options)
    @id = options['id']
    @body = options['body']
    @parent_reply_id = options['parent_reply_id']
    @question_id = options['question_id']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(@author_id)
  end

  def question
    Question.find_by_id(@question_id)
  end

  def parent_reply
    Reply.find_by_id(@parent_reply_id) if @parent_reply_id
  end

  def child_replies
    Reply.find_by_parent_id(@id)
  end


end
