# Rails Lite
Welcome to Rails Lite. In this project I built Rails from scratch. It shows some of the behind the scenes magic of Rails.

## Highlights
- Parses deeply nested hashes to handle query strings
- Uses meta-programming to build custom Controller and Router classes

## Technologies
- ERB
- JSON
- WEBrick
- RSpec
- URI
- Active Support

## How to use
Rails Lite can be used as a replacement for Rails when building small projects. Examples of how to use Rails Lite can be found in the files in the bin folder:
- ruby bin/basic_server.rb
- ruby bin/controller_server.rb
- ruby bin/params_server.rb
- ruby bin/router_server.rb
- ruby bin/session_server.rb
- ruby bin/template_server.rb

## Some cool code snippets

Parsing deeply nested hashes to handle query strings
![Snippet1]
[Snippet1]: code_snippet1.png


Creating, starting and stopping a basic WEBrick server
![Snippet2]
[Snippet2]: code_snippet2.png
