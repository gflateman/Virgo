# Platform CMS

Platform CMS is a comprehensive, WordPress-inspired blogging platform in Ruby on Rails. Platform CMS is not a replacement for minimalist static site generators like Jekyll or Middleman (we love those tools!). Platform CMS is for enabling a professional editorial workflow involving dozens or hundreds of non-technical contributors. It's for creating large-scale media sites, not personal blogs.

Key features of Platform CMS include the following:

* A comprehensive admin UI
* Comprehensive image management
* A WYSIWYG content editing experience modeled on WordPress
* Serious, battle-tested performance (including an "aggressive" configuration option which allows most requests to be serviced in under 3ms reading only from Redis)
* fine grained access controls for admins, editors, contributors, etc
* PostgreSQL text-index-backed full text search
* RSS
* Social media integrations

Platform CMS is distributed as a Rails Engine structured to be easily extended and customized.

## Requirements

Platform CMS deeply integrates PostgreSQL (to support things such as article search) so Postgres is a requirement in both the development and production environments.

Redis is required for production deployments (you can configure the Redis cache store in your production.rb file):

    config.cache_store = :redis_store #, { optional additional configuration }

Finally, for simplicity and robustness **cron** is used to publish scheduled posts. We recommend you use the [whenever](https://github.com/javan/whenever) gem to write to your crontab and have included a schedule.rb file with this gem. The rake task that must run to publish scheduled posts is

    $ rake platform:posts:publish_scheduled

If your deployment environment doesn't support cron but does support scheduled recurring jobs, you can simply wrap an invocation of

    Post.publish_scheduled!

In a job definition and make sure it runs once every few minutes.

## Installation

Add Platform CMS to your Gemfile:

    gem 'platform'

...and "bundle install" it:

    $ bundle install

Next run the Platform CMS install generator which will add a line to mount the Engine in your routes file and add some minimal views to your app's "views directory".

    $ bin/rails g platform:install

Finally, run the db:migrate rake task to add the platform_cms tables to your database schema:

    $ bin/rake db:migrate

(the migrations are pulled in from the Platform gem itself so there is nothing you need to copy into your project tree)

When you now start your app server and open up your app in your web browser, you will be guided through a basic configuration process for your new Platform blog!

## Customizing and Extending

The Platform CMS installer copies several templates for user-facing portion of the site into subdirectories of your views directory. You can freely modify these templates to customize your site UI.

If you wish to modify controller or model-level functionality the recommended technique is to decorate the corresponding ruby class like so:

    # in a file app/models/platform/user_decorator.rb

    Platform::User.class_eval do
      def foo
        'bar'
      end
    end

You'll likely want to "bundle open platform" for implementation details of the original classes.