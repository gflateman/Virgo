# Virgo

Virgo is a comprehensive, WordPress-inspired publishing platform in Ruby on Rails. Virgo is not a replacement for minimalist static site generators like Jekyll or Middleman (we love those tools!). Rather, it is for enabling a professional editorial workflow involving dozens or hundreds of non-technical contributors. It can support anything from a personal blog to a large-scale media property.

### <a href="http://virgo-demo.casper.com/demo_autologin" target="_blank">View a Live Demo Here!</a>
(note: the demo link above will auto-log you in as an admin user. All site content is refreshed every 10 minutes)


Key features of Virgo CMS include the following:

* A comprehensive admin UI
* Comprehensive image management
* A WYSIWYG content editing experience modeled on WordPress
* Serious, battle-tested performance (including an "aggressive" configuration option which allows most requests to be serviced in under 3ms reading only from Redis)
* fine grained access controls for admins, editors, contributors, etc
* Postgres text-index-backed full text search
* RSS
* Social media integrations
* Slideshows

Virgo is distributed as a Rails Engine and structured to be easily extended and customized.

## Requirements

Virgo deeply integrates PostgreSQL (to support things such as article search) so Postgres is a requirement in both the development and production environments.

Redis is required for production deployments (you can configure the Redis cache store in your production.rb file):

    config.cache_store = :redis_store #, { optional additional configuration }

Finally, for simplicity and robustness **cron** is used to publish scheduled posts. We recommend you use the [whenever](https://github.com/javan/whenever) gem to write to your crontab and have included a schedule.rb file with this gem. The rake task that must run to publish scheduled posts is

    $ rake virgo:posts:publish_scheduled

If your deployment environment doesn't support cron but does support scheduled recurring jobs, you can simply wrap an invocation of

    Virgo::Post.publish_scheduled!

In a job definition and make sure it runs once every few minutes.

## Installation

Add Virgo to your Gemfile:

    gem 'virgo'

...and "bundle install" it:

    $ bundle install

Next run the Virgo install generator which will add a line to mount the Engine in your routes file and add some minimal views to your app's "views directory".

    $ bin/rails g virgo:install

Finally, run the db:migrate rake task to add the virgo_cms tables to your database schema:

    $ bin/rake db:migrate

(the migrations are pulled in from the Virgo gem itself so there is nothing you need to copy into your project tree)

When you now start your app server and open up your app in your web browser, you will be guided through a basic configuration process for your new Virgo app!

## Customizing and Extending

The installer copies several templates for user-facing portion of the site into subdirectories of your views directory. You can freely modify these templates to customize your site UI.

If you wish to modify controller or model-level functionality the recommended technique is to decorate the corresponding ruby class like so:

    # in a file app/models/virgo/user_decorator.rb

    Virgo::User.class_eval do
      def foo
        'bar'
      end
    end

You'll likely want to "bundle open virgo" for implementation details of the original classes.

## Development Notes

This project is very much in a "alpha" state. There are a few critical things as-yet not done that we would like to implement in the near future:

* True plugin architecture - there is not yet a true plugin architecture, though we do expose the ability to override all aspects of an install. We would like to introduce something resembling a plugin package system in the immediate future.
* Better test coverage - there is good Capybara coverage of the admin workflows but very little in the way of model/controller-level testing (only very critical Post-related functionality covered).
* Cleaner CSS - the present default frontend styles could probably stand to be cleaned up and simplified some. They were extracted from a live, high traffic site with a pretty complex UI and could perhaps benefit from clean rewrite.


## License

This code is released under the [GPL v2 License](http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt).
