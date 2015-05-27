# lita-destiny

[![Build Status](https://travis-ci.org/PDaily/lita-destiny.svg?branch=master)](https://travis-ci.org/PDaily/lita-destiny)
[![Coverage Status](https://coveralls.io/repos/PDaily/lita-destiny/badge.svg?branch=master)](https://coveralls.io/r/PDaily/lita-destiny?branch=master)

Lita handler for interacting with the Destiny API

## Installation

Add lita-destiny to your Lita instance's Gemfile:

``` ruby
gem "lita-destiny"
```

## Configuration

Add the config to your lita config file with your Bungie API key:
``` ruby
config.handlers.destiny.api_key = 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
```

## Usage

This gem adds several methods for chat routes.


##### #advisors
> Returns a hash object containing the days advisor report
> For brevity, see http://www.bungie.net/Platform/Destiny/Advisors/

#### #activity(activity_hash, raw=false)
> Two options: *raw data* as returned by Bungies server or *parsed data* as manipulated by the method. 
>
> Defaults to *parsed data*, but can be overridden by passing ```true``` as the second argument.

##### #nightfall(options={})
> Returns a hash object from #activity
```
{ activityName: raw_data['activityName'],
  activityDescription: raw_data['activityDescription'],
  skulls: skulls }
```
##### #weekly_strike(options={})
> Returns a hash object
```
{ activityName: raw_data['activityName'],
  activityDescription: raw_data['activityDescription'],
  skulls: skulls }
```

##### #arena(options={})
> Not defined yet. No public endpoint.
> To be complete when there is one.

##### #xur
> Work in progress, will return items being sold as well as prices and location.

##### #place(place_hash)
> Returns a hash object
```
{ place_name: raw_data['placeName'],
  place_desc: raw_data['placeDescription'] }
```

##### #destination(dest_hash)
> Returns a hash object
```
{ dest_name: raw_data['destinationName'],
  dest_desc: raw_data['destinationDescription'] }

```