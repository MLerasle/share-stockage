# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'sharestockage'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :ssh_options, {
  forward_agent: true,
  port: 22,
  user: "deploy"
}

set :rbenv_type, :deploy
set :rbenv_ruby, '2.2.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# Default deploy_to directory is /var/www/my_app_name

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :deploy_user, :deploy
set :pty, false
set :scm, :git
set :repo_url, 'git@bitbucket.org:mlerasle/sharing_space.git'
set :deploy_to, '/home/deploy/sharestockage'

set :rollbar_token, 'b0f28dfa0b5f457bb2fbc942918765d4'
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :figaro do
  desc "SCP transfer figaro configuration to the shared folder"
  task :setup do
    on roles(:app) do
      upload! "config/application.yml", "#{shared_path}/application.yml", via: :scp
      upload! "config/secrets.yml", "#{shared_path}/secrets.yml", via: :scp
    end
  end

  desc "Symlink application.yml to the release path"
  task :symlink do
    on roles(:app) do
      execute "ln -sf #{shared_path}/application.yml #{release_path}/config/application.yml"
      execute "ln -sf #{shared_path}/secrets.yml #{release_path}/config/secrets.yml"
    end
  end
end

namespace :deploy do
  before :updated, "figaro:setup"
  before :updated, "figaro:symlink"
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo /etc/init.d/nginx restart"
    end
  end

  after :publishing, 'deploy:restart'
end
