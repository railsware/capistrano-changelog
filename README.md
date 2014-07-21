
# capistrano-changelog

Uses git commits to recognize tracker stories and generates ChangeLog.

Integration with Capostrano.


## Installation

Add this line to your application's Gemfile:

    gem 'capistrano-changelog', require: false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capistrano-changelog


## Usage

Use following settings at deploy.rb

    set :changelog_tracker, :pivotal                # ticket tracking service, default: pivotal
    set :changelog_pivotal_token, 'xxxx'
    set :changelog_output, File.join(release_path, 'public', 'changelog.html')
    set :changelog_cache, '/tmp/pivotal'            # does tickets caching if caching path specified, default: false

Hooks

    # Generates ChangeLog file
    #
    after 'deploy:finished', 'deploy:changelog'

    # Generates version.json with last commit hash
    #
    after 'deploy:update_code', 'deploy:version'


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
