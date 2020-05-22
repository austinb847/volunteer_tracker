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

  def update(attributes)
    @title = attributes.fetch(:title)
    DB.exec("UPDATE projects SET title = '#{@title}' WHERE id = #{@id};")
  end

  def delete()
    DB.exec("DELETE FROM projects WHERE id = #{@id};")
    DB.exec("DELETE FROM volunteers WHERE project_id = #{@id};")
  end
  
end