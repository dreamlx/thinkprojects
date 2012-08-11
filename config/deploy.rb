set :application, "texel"
set :repository,  "git@github.com:dreamlx/thinkprojects.git"
set :user, "dreamlx"

set :scm, :git
set :deploy_via, :remote_cache
set :git_shallow_clone, 1
set :git_enable_submodules, 1
set :deploy_to, "/home/dreamlx/ThinkPanda"

server "dreamlx.net", :app, :web, :db, :primary => true
#role :app, domain
#role :web, domain
#role :db,  domain, :primary => true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, "your app-server here"
role :web, "your web-server here"
role :db,  "your db-server here", :primary => true
