**Share Stockage** is a website I created to simply create a full website from scratch :)
It allows people to rent available storage space they don't use to other people who could need it.

The purpose was not to launch it in production, even if I did, but just to practice my **Ruby On Rails** skills and to learn new stuff in the process.

I kept the code as I originally wrote it a few years ago, so you won't find any Docker container or stuff like that to help you out if you want to launch the app, but you should be able to do so by following the next few steps.

Just a side note before that: it is very likely that all the features won't work as expected, regarding the fact that I stopped working on this project a long time ago and didn't touch it since then (I'm thinking about the emails for example which I only partially deactivated) but feel free to play around with the code if you want to.

So, to install the project, you have to:

1. Clone the repo: `git clone git@gitlab.com:maxlerasle/share-stockage.git`

2. Install the dependencies from the root folder: `bundle install --full-index`

3. Create a local MySql database on your device (this will be share_stockage in my case)

4. Create a config/database.yml file with the following content:

```yml
development:
  adapter: mysql2
  encoding: utf8
  database: share_stockage
  username: root
  host: localhost
```
5. Launch the migration: `bundle exec rake db:migrate`

6. Create a `config/secrets.yml` file,

7. Open your terminal and use `bundle exec rake secret` to generate a new secret key. Copy the generated key and add the following to your `secrets.yml` file:

```yml
development:
  secret_key_base: your_key_here
```
8. Launch the server and you should be good to go: `bundle exec unicorn`
