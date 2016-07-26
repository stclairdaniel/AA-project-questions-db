require_relative 'questionsdb_connection'

class ModelBase

  def self.all
    QuestionsDBConnection.instance.execute(<<-SQL, self.table)
      SELECT *
      FROM ?
    SQL
  end

  def self.find_by_id(id)
    QuestionsDBConnection.instance.execute(<<-SQL, self.table, id)
    SELECT * FROM ? WHERE id = ?
  SQL
  end

  def save

  end


end
