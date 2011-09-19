{generateProject}     = require './toast'
{pred}                = require 'termspeak'

# TODO: Actually write this interface

args = process.argv[2...]
console.log args
switch args[0]
    when 'generate'
        {layout} = require '../bread/node-coffee'
        {config} = require '../examples/example'
        generateProject layout, config, './' + config.name
    else
        pred "Invalid argument. Valid arguments are: generate {DIR}"