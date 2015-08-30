# lita-destiny

[![Gem Version](https://badge.fury.io/rb/lita-destiny.svg)](http://badge.fury.io/rb/lita-destiny)
[![Build Status](https://travis-ci.org/PDaily/lita-destiny.svg?branch=master)](https://travis-ci.org/PDaily/lita-destiny)
[![Code Climate](https://codeclimate.com/github/PDaily/lita-destiny/badges/gpa.svg)](https://codeclimate.com/github/PDaily/lita-destiny)
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
