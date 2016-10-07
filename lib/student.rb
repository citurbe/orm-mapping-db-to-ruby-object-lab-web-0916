require 'pry'
class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all
    student_array = DB[:conn].execute("SELECT * FROM students")
    student_array.map {|row| Student.new_from_db(row)}
  end

  def self.find_by_name(name)
    student_row = DB[:conn].execute("SELECT * FROM students WHERE students.name = '#{name}';")
    student = Student.new_from_db(student_row[0])

    return student
  end

  def self.count_all_students_in_grade_9
    ninth_array = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 9;")
    ninth_array.map {|row| Student.new_from_db(row)}
  end

  def self.students_below_12th_grade
    below_12th = DB[:conn].execute("SELECT * FROM students WHERE students.grade < 12;")
    below_12th.map {|row| Student.new_from_db(row)}
  end

  def self.first_x_students_in_grade_10(x)
    grade_10 = DB[:conn].execute("SELECT * FROM students WHERE students.grade = 10 LIMIT #{x};")
    grade_10.map {|row| Student.new_from_db(row)}
  end

  def self.first_student_in_grade_10
    Student.first_x_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_x(x)
    students = DB[:conn].execute("SELECT * FROM students WHERE students.grade = #{x};")
    students.map { |row| Student.new_from_db(row)  }
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
end
