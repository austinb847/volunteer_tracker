class Project

  attr_reader :id
  attr_accessor :title

  def initialize(attributes)
    @title = attributes.fetch(:title)
    @id = attributes.fetch(:id)
  end

  def save()
    result = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id;")
    @id = result.first().fetch("id").to_i
  end

  def ==(project_to_compare)
    @title == project_to_compare.title
  end

  def self.all()
    returned_projects = DB.exec("SELECT * FROM projects;")
    returned_projects.map() do |project|
      title = project.fetch("title")
      id = project.fetch("id").to_i
      Project.new({:title => title, :id => id})
    end
  end
  
  def self.find(prj_id)
    project = DB.exec("SELECT * FROM projects WHERE id = #{prj_id};").first
    title = project.fetch("title")
    id = project.fetch("id").to_i
    Project.new({:title => title, :id => id})
  end
  
end