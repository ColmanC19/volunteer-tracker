class Project
  attr_reader :title, :id

  def initialize(attributes)
    @title = attributes.fetch :title
    @id = attributes.fetch :id
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each do |project|
      title = project.fetch "title"
      id = project.fetch("id").to_i
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

  def save
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def ==(another_project)
    (self.title == another_project.title) & (self.id == another_project.id)
  end


  def self.find(id)
    found_project = nil
    Project.all.each do |project|
      if project.id == id
        found_project = project
      end
    end
    found_project
  end

  def delete
    DB.exec("DELETE FROM projects WHERE id = #{self.id};")
    DB.exec("DELETE FROM volunteers WHERE project_id = #{self.id};")
  end

  def update(attributes)
    @title = attributes.fetch :title
    @id = self.id
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
  end

  def volunteers
    project_volunteers = []
    volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{self.id};")
    volunteers.each do |volunteer|
      title = volunteer.fetch "title"
      id = volunteer.fetch("id").to_i
      project_volunteers.push(Volunteer.new({:title => title, :id => id}))
    end
    project_volunteers
  end

  def hours
    DB.exec("SELECT SUM(hours) FROM volunteers WHERE project_id = #{self.id};")
  end

  def self.project_search(query)
    found_projects = DB.exec("SELECT * FROM projects WHERE title LIKE '%#{query}%';")
    projects = []
    found_projects.each() do |project|
      title = project.fetch('title')
      id = project.fetch('id').to_i
      projects.push(Project.new({:title => title, :id => id}))
    end
    projects
  end

  def self.order
    DB.exec("SELECT * FROM projects ORDER BY title").to_a
  end

  def self.order_hours
    projects = Project.all
    projects.each do |project|
      project.hours[0]["sum"]
    end
    projects.sort!
  end

end
