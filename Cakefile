{spawn} = require 'child_process'
{log} = console

run = (cmd) ->
    log "#{cmd}"
    [cmd, args...] = cmd.split ' '
    proc = spawn cmd, args
    proc.stdin.end()
    proc.stdout.on 'data', (data) -> log data.toString()
    proc.stderr.on 'data', (data) -> log data.toString()
    
task 'build', ->
    run 'coffee -o lib -c src'
    run 'coffee -c bread'
    run 'coffee -c examples'

task 'test', ->
    run 'npm test'

task 'docs', ->
  run 'docco src/toast.coffee'