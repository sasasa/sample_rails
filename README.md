```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

echo 'eval "$(rbenv init -)"' >> ~/.bashrc

rbenv -v

git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build

sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline-dev ➡
zlib1g-dev libncurses5-dev libffi-dev libgdbm-dev

rbenv install 2.6.6
rbenv global 2.6.6
ruby -v
which ruby

gem update --system -N

gem -v

gem list

gem install bundler -N

gem install rails -N

rails -v

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt install nodejs

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo apt update

sudo apt install postgresql

psql -V
alter role postgres with password 'postgres';

sudo service postgresql start

sudo su postgres -c 'createuser -s saeki'

psql postgres

sudo apt install libpq-dev

```

# README

```
bundle exec erb2slim app/views --delete



config/webpacker.yml
    watch_options:
      ignored: '**/node_modules/**'
      poll: 500
    watch_poll: true

wget https://raw.githubusercontent.com/svenfuchs/rails-i18n/master/rails/locale/ja.yml --output- document=config/locales/ja.yml


config/initializers/locale.rb
Rails.application.config.i18n.default_locale = :ja


config/application.rb


    config.time_zone = 'Asia/Tokyo'
    config.generators do |g|
      g.assets false
      g.helper false
      g.jbuilder false

      g.test_framework :rspec, 
            view_specs: false, 
            helper_specs: false, 
            controller_specs: false, 
            routing_specs: false
            # fixtures: false,
    end


config/environments/development.rb
 
  config.cache_classes = false
  config.reload_classes_only_on_change = false
  config.file_watcher = ActiveSupport::FileUpdateChecker


ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
```


```
rails g model Task name:string description:text

rails g controller tasks index show new edit

config/routes.rb
  root to: 'tasks#index'
  # get 'tasks/index'
  # get 'tasks/show'
  # get 'tasks/new'
  # get 'tasks/edit'
  resources :tasks

rails g migration ChangeTasksNameNotNull
rails g migration ChangeTasksNameLimit30
rails g migration AddNameIndexToTasks

rails g model user name:string email:string password_digest:string

rails g migration add_admin_to_users

rails g controller Admin::Users new edit show index

rails g controller Sessions new

rails g migration AddUserIdToTasks

rails g rspec:install

rails g rspec:system tasks

rails c -s

rails g migration add_locale_to_users
rails g migration add_premium_to_users
rails g migration add_special_to_tasks

rails g mailer TaskMailer
rails g rspec:mailer TaskMailer

rails active_storage:install
rails g kaminari:views bootstrap4

yarn add jquery

rails g migration AddDeletedAtToUsers deleted_at:datetime:index

rails g scaffold skill name:string:unique type:integer
rails g model SkillsUser skill:references user:references proficiency:integer

rails g migration AddSkillNamesAtToUsers skill_names:string:index

bundle exec rails g annotate:install

bundle exec spring binstub rspec



rails g rspec:system admin::user
rails g rspec:system skill

rails g migration AddPlanToUsers plan:integer
rails g migration AddSubscriptionToUsers subscription:string
rails g migration AddCustomerToUsers customer:string
```