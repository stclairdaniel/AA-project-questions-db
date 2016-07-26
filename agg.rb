require 'pry'
require 'sqlite3'

require_relative 'questionsdb_connection'
require_relative 'user'
require_relative 'reply'
require_relative 'question'
require_relative 'question_follow'
require_relative 'question_like'

a = User.find_by_id(1)
d = User.find_by_id(2)

q1 = Question.find_by_id(1)
q2 = Question.find_by_id(2)

r1 = Reply.find_by_id(1)
r2 = Reply.find_by_id(2)

binding.pry
