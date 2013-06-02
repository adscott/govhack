govhack
===========================

Hosted [http://deathmatch.me/](http://deathmatch.me/).

Data from [here](http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/3303.02011?OpenDocument) shoved into a database and queriable through a thin sinatra wrapper.

##Getting started

Get dependencies:

  `bundle install`

Prepare database:

  `bundle exec rake db:migrate`

Load data:

  `bundle exec rake insert_data`

Load the deathcards (combine with above step?):

  `bundle exec rake load_deathcards`

Run the web interface:

  `bundle exec shotgun`
