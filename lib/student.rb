require 'pry'
class Student
  attr_accessor :id, :name, :grade


  def self.new_from_db(row)
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    all = DB[:conn].execute(sql)
    all.map do |row|
      self.new_from_db(row)
    end
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students WHERE name = ?
    SQL
    row = DB[:conn].execute(sql, name)
    self.new_from_db(row.first)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL
    DB[:conn].execute(sql, self.name, self.grade)
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
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    all_in_9 = self.all.select{|student| student.grade == "9"}
  end

  def self.students_below_12th_grade
    self.all.select{|student| student.grade.to_i < 12}
  end

  def self.first_x_students_in_grade_10(amount)
    students = self.all.select{|student| student.grade == "10"}
    students[1..amount]
  end

  def self.first_student_in_grade_10
    self.all.find{|student| student.grade == "10"}
  end

  def self.all_students_in_grade_x(grade)
    self.all.select{|student| student.grade == grade.to_s}
  end
end
