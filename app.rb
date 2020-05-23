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
  @project = Project.find(params[:id])
  erb(:edit_project)
end

patch('/projects/:id') do
  title = params[:project_title]
  project = Project.find(params[:id])
  project.update({:title => title})
  redirect to('/projects')
end

delete('/projects/:id') do
  project = Project.find(params[:id])
  project.delete()
  redirect to('/projects')
end