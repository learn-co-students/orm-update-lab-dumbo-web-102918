require_relative "../config/environment.rb"
require 'pry'
class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  attr_accessor :id, :name, :grade
  def initialize(id = nil, name, grade)
    @id, @name, @grade = id, name, grade
  end
  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
    SQL

    DB[:conn].execute sql
  end

  def self.drop_table
    DB[:conn].execute "DROP TABLE students"
  end

  def save
    if self.id
      self.update
    else
      # binding.pry
      sql = <<-SQL
        INSERT INTO students (name, grade)
        VALUES (?, ?)
      SQL

      DB[:conn].execute(sql, @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
    # binding.pry
  end

  def update
    sql = <<-SQL
      UPDATE students SET name = ?, grade = ?
      WHERE id = ?
    SQL

    DB[:conn].execute(sql, self.name, @grade, @id)
  end

  def self.create(name, grade)
    stu_obj = Student.new(name, grade)
    stu_obj.save
  end

  def self.new_from_db(row)
    stu_obj = Student.new(row[0], row[1], row[2])
  end

  def self.find_by_name(name)
    row = DB[:conn].execute("SELECT * FROM students WHERE name = ?", name)[0]
    Student.new(row[0], row[1], row[2])
  end
end
