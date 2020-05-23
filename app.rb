require('sinatra')
require('sinatra/reloader')
require('./lib/volunteer')
require('./lib/project')
require('pry')
also_reload('lib/**/*.rb')
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get('/') do
  @projects = Project.all()
  erb(:projects)
end

get('/projects') do
  redirect to('/')
end

post('/projects') do
  project = Project.new({:title => params[:project_title], :id => nil})
  project.save()
  redirect to('/')
end

get('/projects/:id/edit') do
  @project = Project.find(params[:id].to_i)
  erb(:edit_project)
end

patch('/projects/:id') do
  title = params[:project_title]
  project = Project.find(params[:id].to_i)
  project.update({:title => title})
  redirect to('/projects')
end

delete('/projects/:id') do
  project = Project.find(params[:id].to_i)
  project.delete()
  redirect to('/projects')
end

get('/projects/:id/volunteers') do
  @project = Project.find(params[:id].to_i)
  erb(:volunteers)
end

post('/projects/:id/volunteers') do
  name = params[:volunteer_name]
  prj_id = params[:id].to_i
  volunteer = Volunteer.new({:name => name, :project_id => prj_id, :id => nil})
  volunteer.save()
  @project = Project.find(params[:id].to_i)
  erb(:volunteers) 
end

get('/projects/:id/volunteers/:v_id/edit') do
  @project = Project.find(params[:id].to_i)
  @volunteer = Volunteer.find(params[:v_id].to_i)
  erb(:edit_volunteer)
end

patch('/projects/:id/volunteers/:v_id') do
  name = params[:volunteer_name]
  prj_id = params[:id].to_i
  volunteer = Volunteer.find(params[:v_id].to_i)
  volunteer.update(name, prj_id)
  @project = Project.find(prj_id)
  erb(:volunteers)
end

delete('/projects/:id/volunteers/:v_id') do
  volunteer = Volunteer.find(params[:v_id].to_i)
  volunteer.delete()
  @project = Project.find(params[:id].to_i)
  erb(:volunteers)
end