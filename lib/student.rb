require_relative "../config/environment.rb"
require "pry"

class Student

attr_reader :id
attr_accessor :name, :grade

@@all = []

def self.all
  @@all
end

def initialize(name, grade, id=nil)
  @name = name
  @grade = grade
  @id = id
  @@all << self
end

def self.create_table
sql = <<-SQL
CREATE TABLE students (
id INTEGER PRIMARY KEY,
name TEXT,
grade TEXT
)
SQL
DB[:conn].execute(sql)
end

def self.drop_table
  sql = <<-SQL
  DROP TABLE IF EXISTS students
  SQL
  DB[:conn].execute(sql)
end

def save
  self.update
  sql = <<-SQL
  INSERT INTO students (name, grade) VALUES (?,?)
  SQL
  DB[:conn].execute(sql,name,grade)
  @id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1").flatten[0]

end


def self.create(name,grade)
  self.new(name,grade).save
end

def self.new_from_db(row)
  stud = Student.new(row[1],row[2],row[0])
end

def self.find_by_name(name)
  sql = <<-SQL
  SELECT * FROM students WHERE name = ?
  GROUP BY name
  SQL
  row = DB[:conn].execute(sql,name).flatten
  stud = self.new_from_db(row)


end

  def update
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? WHERE id = ?
    SQL
    DB[:conn].execute(sql,name,grade,id)
    #@id = DB[:conn].execute("SELECT id FROM students ORDER BY id DESC LIMIT 1").flatten[0]

  end





end
