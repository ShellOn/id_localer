# IdLocaler

IdLocaler is rack middleware which one set your app i18n.locale by checking:    

* Cookies
* URL ( www.domain.com/en )
* 'HTTP_ACCEPT_LANGUAGE' header


## Installation

Get the source and install it using gem manager.     
I do not have pushed to gem server yet. :p     


## Usage

1. Add it to your Gemfile,
2. bundle install 
3. Insert it to the middleware stack. 

_Be aware to the routes and middlewares sequences._

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
