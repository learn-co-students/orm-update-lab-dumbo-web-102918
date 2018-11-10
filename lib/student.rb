require_relative "../config/environment.rb"

require 'pry'
class Student


  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
    DROP TABLE students
    SQL
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO students (name, grade) VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
    #cant put the vales self.name and self.grade inside values because self.name is
    #string nd a string within a string will break it.
    @id = DB[:conn].execute("SELECT students.id FROM students ORDER BY students.id DESC LIMIT 1")[0][0]
    # need the [0][0] because the answer without it comes out to be [[1]].
  end
  end

  def self.create(name, grade)
   student = Student.new(name, grade)
   student.save
   student
  end
  def self.new_from_db(row)
  # create a new Student object given a row from the database
    id = row[0]
    name = row[1]
    grade = row[2]
    self.new(id, name, grade)

end
  def self.find_by_name(name)

  # find the student in the database given a name
  # return a new instance of the Student class
  sql = <<-SQL
  SELECT * FROM students WHERE name = ?
  SQL

  DB[:conn].execute(sql,name).map do |row|
        self.new_from_db(row)
      end.first
  end

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end



end
