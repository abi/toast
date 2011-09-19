{README_MD, LICENSE, ROOT_GITIGNORE} = require './common'

CAKEFILE = (config) ->
    {name} = config

    """

    {spawn} = require 'child_process'
    {log} = console

    run = (cmd) ->
        log "\#\{cmd\}"
        [cmd, args...] = cmd.split ' '
        proc = spawn cmd, args
        proc.stdin.end()
        proc.stdout.on 'data', (data) -> log data.toString()
        proc.stderr.on 'data', (data) -> log data.toString()
    
    task 'build', ->
        run 'coffee -o lib -c src/#{name}.coffee'

    task 'test', ->
        run 'npm test'

    task 'docs', ->
      run 'docco src/#{name}.coffee'
    """

# TODO: This JSON should be generated as a JSON object and then, stringified
# Maybe, even hook up to NPM's module
PACKAGE_JSON = (config) ->
    {name, repoURL, desc, author, keywords, license} = config
        
    # Make author proper when not all required is presented
    
    """
    {
      "name": "#{name}",
      "version": "0.0.1",
      "description": "#{desc ? ''}",
      "keywords": [
          #{(keywords?.join(',\n')) ? ''}
      ],
      "author": "#{author.name ? ''} <#{author.email ? ''}> (#{author.URL ? ''})",
      "licenses": [
        {
          "type": "#{license}"
        }
      ],
      "scripts": {
        "prepublish": "coffee -o lib/ -c ./src/#{name}.coffee",
        "test": "coffee examples/example.coffee"
      },
      "dependencies": {},
      "main": "./lib/#{name}.js",
      "engines": {
        "node": ">=0.4.x"
      },
      "directories": {
        "example": "./examples",
        "lib": "./src"
      },
      "devDependencies": {
        "coffee-script": ""
      },
      "repository": {
        "type": "git",
        "url": "#{repoURL}"
      }
    }
    """
    
layout = (config) ->            
    # Only string literals are allowed as keys in a JSON object

    'lib':
        "$name.js": ""
    'examples':
        "example.coffee": ""
    'src':
        '.gitignore': ".js"
        "$name.coffee": ""
    'support': {}
    'docs': {}
    'package.json': PACKAGE_JSON
    'README.md': README_MD
    'LICENSE': LICENSE
    'Cakefile': CAKEFILE
    '.gitignore': ROOT_GITIGNORE
    '.npmignore': ""
        
exports.layout = layout