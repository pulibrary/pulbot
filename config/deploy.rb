# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'pulbot'
set :repo_url, 'https://github.com/pulibrary/pulbot.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/pulbot'

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids', 'node_modules')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :default_env, fetch(:default_env, {}).merge('PATH' => "/opt/pulbot/current/node_modules/.bin:/opt/pulbot/current/node_modules/hubot/node_modules/.bin:$PATH")

namespace :deploy do
  desc "Sets up the log file, then sources EnvVars & starts Hubot"
  task :start do
    log_file = "#{shared_path}/log/hubot.log"
    # If we've got a log file already, mark that a deployment occurred
    on roles(:app) do
      execute "if [ -e #{log_file} ]; then echo \"\n\nDeployment #{release_timestamp}\n\" >> #{log_file}; fi"
      # Start Hubot!
      execute "source /home/deploy/.bashrc && \
        cd #{release_path} && \
        forever start -p #{shared_path} --pidFile #{shared_path}/pids/hubot.pid -a -l #{shared_path}/log/hubot.log -c coffee node_modules/.bin/hubot -a slack -d"
    end
  end

  desc "Stop Hubot"
  task :stop do
    on roles(:app) do
      test "cd #{release_path} && \
        forever stop node_modules/.bin/hubot"
      test "kill $(#{shared_path}/pids/hubot.pid)"
    end
  end

  desc "Install necessary Node modules, then move them to the correct path"
  task :npm_install do
    on roles(:app) do
      execute "cd #{release_path} && npm install"
    end
  end

  # desc "Create symlink to shared Node modules"
  # task :npm_modules_make_symlink do
  #   run "ln -s #{shared_path}/node_modules #{release_path}/node_modules"
  # end

  desc "Base task to restart Hubot after a deployment if he's already running"
  task :restart do
    invoke "deploy:stop"
    invoke "deploy:start"
  end
end
after "deploy:published", "deploy:restart"
before "deploy:updated", "deploy:npm_install"
