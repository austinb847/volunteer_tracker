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