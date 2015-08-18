class Student
  attr_accessor :id, :name, :tagline, :github, :twitter, :blog_url, :image_url, :biography
  @@instances = []

  def initialize
    @@instances << self
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        tagline TEXT,
        github TEXT,
        twitter TEXT,
        blog_url TEXT,
        image_url TEXT,
        biography TEXT
        )
     SQL
     DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE students"
    DB[:conn].execute(sql)
  end

  def insert
    sql = <<-SQL
      INSERT INTO students (id, name, tagline, github, twitter, blog_url, image_url, biography)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    SQL
    DB[:conn].execute(sql, id, name, tagline, github, twitter, blog_url, image_url, biography)
    # update student id to mirror object to table primary key
    sql = "SELECT last_insert_rowid() FROM students"
    self.id = DB[:conn].execute(sql).flatten.first
  end

  def self.new_from_db(row)
    s = Student.new
    s.id = row[0]
    s.name = row[1]
    s.tagline = row[2]
    s.github = row[3]
    s.twitter = row[4]
    s.blog_url = row[5]
    s.image_url = row[6]
    s.biography = row[7]
    s
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM students WHERE name = ?"
    row = DB[:conn].execute(sql, name).first
    self.new_from_db(row) unless row.nil?
  end

  def update
    sql = "UPDATE students SET name = ? WHERE id = ?"
    DB[:conn].execute(sql, name, id)
  end

  def persisted?
    # is the id set? double bang returns a true/false value for the variable
    !!id
  end

  def save
    persisted? ? update : insert
  end
end
