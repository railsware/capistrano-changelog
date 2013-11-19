# PTLog

Chagelog based on Git commits with a PivotalTracker story IDs.

Integration with Capostrano.

## Installation

Add this line to your application's Gemfile:

    gem 'ptlog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ptlog

## Usage

Capistrano tasks

    set :ptlog_project_id, PROJECT_ID
    set :ptlog_token, TOKEN
    set :ptlog_output, "{release_path}/changelog.html"

Hook

    after :deploy, 'ptlog:generate'

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
