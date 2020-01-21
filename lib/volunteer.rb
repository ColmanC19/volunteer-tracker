class Volunteer
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def save
    result = DB.exec("INSERT INTO volunteers (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end


  def ==(volunteer_to_compare)
    self.name() == volunteer_to_compare.name()
  end

  def self.all
    returned_volunteers = DB.exec("SELECT * FROM volunteers;")
    volunteers = []
    returned_volunteers.each do |volunteer|
      name = volunteer.fetch "name"
      id = volunteer.fetch("id").to_i
      volunteers.push(Volunteer.new({:name => name, :id => id}))
    end
    volunteers
  end

  def self.clear
    DB.exec("DELETE FROM volunteers *;")
  end

  def self.sort
    self.get_volunteers("SELECT * FROM volunteers ORDER BY lower(name);")
    # @projects.values.sort {|a, b| a.name.downcase <=> b.name.downcase}
  end


  def update(attributes)
    @name = attributes.fetch(:name)
    @id = self.id
    DB.exec("UPDATE volunteers SET name = '#{@name}' WHERE id = #{@id};")

  def self.find(id)
    returned_volunteer = nil
    Volunteer.all.each do |volunteer|
      if volunteer.id == id
        returned_volunteer = volunteer
      end
    end
    returned_volunteer
  end

  def delete
    # DB.exec("DELETE FROM volunteers_projects WHERE volunteers_id = #{@id};")
    DB.exec("DELETE FROM volunteers WHERE id = #{@id};")
  end

  def projects
  projects = []
  results = DB.exec("SELECT projects_id FROM volunteers_projects WHERE volunteers_id = #{@id};")
    results.each() do |result|
      projects_id = result.fetch("projects_id").to_i()
      project = DB.exec("SELECT * FROM projects WHERE id = #{projects_id};")
      title = project.fetch("title")
      projects.push(Book.new({:title => title, :id => projects_id}))
    end
    projects
  end

def self.get_volunteers(query)
  returned_volunteers = DB.exec(query)
  volunteers = []
  returned_volunteers.each() do |volunteer|
    name = volunteer.fetch("name")
    id = volunteer.fetch("id").to_i
    volunteers.push(Volunteer.new({:name => name, :id => id}))
  end
  volunteers
end

def self.search(x)
  self.get_volunteers("SELECT * FROM volunteers WHERE name ILIKE '%#{x}%'")
  # @projects.values.select { |e| /#{x}/i.match? e.name}
end
end
end
