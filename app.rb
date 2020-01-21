require('sinatra')
require('sinatra/reloader')
require('./lib/volunteer')
require('./lib/project')
require('pry')
require("pg")

also_reload('lib/**/*.rb')

DB = PG.connect({:dbname => "volunteer_tracker"})

get ('/') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:home)
end

get ('/home') do
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:home)
end

get('/project/new') do
  erb(:new_project)
end


post ('/home') do

if params[:title] && params[:name]
  name = params[:name]
  project_id = params[:title]
  volunteer = Volunteer.new({:name => name, :project_id => project_id ,:id => nil})
  volunteer.save
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:home)

elsif params[:title]
    title = params[:title]
    project = Project.new({:title => title, :id => nil})
    project.save
    @projects = Project.all
    @volunteers = Volunteer.all
    erb(:home)
else
  @projects = Project.all
  @volunteers = Volunteer.all
  erb(:home)


  end
end

get '/volunteer/new' do
  @projects = Project.all
  erb(:new_volunteer)
end



get ('/home/project/:id')do

  @project = Project.find(params[:id].to_i())
  @volunteers = @project.volunteers()

  erb(:project)

end


get('/home/projects/:id/edit') do
  @project = Project.find(params[:id].to_i())
  erb(:edit_project)
end


delete('/home/projects/:id')do
  @project = Project.find(params[:id].to_i())
  @project.delete()

  @projects = Project.all
  @volunteers = Volunteer.all

  erb(:home)
end



patch ('/home/projects/:id') do
  @project = Project.find(params[:id].to_i())
  @project.update({:title => params[:title], :id => nil})
  @volunteers = Volunteer.all
  @projects = Project.all

  erb(:home)
end



#Volunteers Routing¡! - -- - -- - - - - - - - >






get ('/home/volunteers/:id')do

  @volunteer = Volunteer.find(params[:id].to_i())

  erb(:volunteer)

end


delete('/home/volunteers/:id')do
  @volunteer = Volunteer.find(params[:id].to_i())
  @volunteer.delete()

  @projects = Project.all
  @volunteers = Volunteer.all

  erb(:home)
end


patch ('/home/volunteers/:id') do
  @volunteer = Volunteer.find(params[:id].to_i())
  @volunteer.update({:name => params[:name], :id => nil})
  @volunteers = Volunteer.all
  @projects = Project.all

  erb(:home)
end

get ('/home/volunteers/:id/edit')do

  @volunteer = Volunteer.find(params[:id].to_i())

  erb(:edit_volunteer)

end
