fs              = require 'fs'
path            = require 'path'
util            = require 'util'

require 'exceptional'

{read, write, remove, mkdir, join, ls, rm_r} = require('node_util').sync()
{exit}          = require 'termspeak'
{test, eq, throws, run, deq, equalSet}  = require 'derp'
_               = require 'underscore'
_.mixin require 'underscore.string'

{log, dir}      = console

# You have to write a bit of configuration so that the boilerplate generates a nice directory structure for you

# TODO: Abstract this out    
# '.'s in files are converted to '_'
# Filenames (including directory names) use "-" as seperators

logger = (module, context, output='terminal') ->
    # Output can be a file, socket, terminal or HTML or any combination of these different mechanisms
    # socket.io server
    # Other mechanisms we want to support: Scribe, Flume, syslog
    
    return (type, msg) ->
        
        outputFn = console.log
        
        if output is 'terminal'
            outputFn = console.log
        
        outputFn "[#{module}] [#{context}] [#{type}] #{msg}"
        
test_logger = () ->
    log = logger 'logger', 'test'
    log 'control', 'Starting up...'
    
# test_logger()
# exit()

# Layouts are describes with object literals
# Directories are objects
# Files are strings (or occasionally objects when you want to use templates)

# TODO: Catch errors from the POSIX FS functions (How about Windows?)
# TODO: Convert root to an absolute path
# TODO: What about permissions?
# TODO: Support '.' notation in the templating (Should just use eval)
# TODO: Convert all of this to exceptions
# TODO: Rename $name    
#    Possibly have index.js
#   if config.index? then index.js
#   ?.npmignore
#   /?docs
#   /?test

generateLayout = (layout, config, root='./') ->
    
    log = logger 'boilerplate', 'generate'
    
    for file, contents of layout
        # TODO: Test this specifically
        if _(file).includes '$'
            file = file.replace /(\$[^\$\.]*)/g, (args...) ->
                config[args[0].split('$')[1]]
            log 'control', file
            
        if typeof contents is 'object'
            log 'control', "Making dir #{file} at #{root}"
            fs.mkdir path.join(root, file), '0777'
            generateLayout contents, config, join(root, file)
        else if typeof contents is 'function'
            log 'control', "Writing file #{file} at #{root}"
            write path.join(root, file), contents(config)
        else if typeof contents is 'string'
            log 'control', "Writing file #{file} at #{root}"
            write path.join(root, file), contents
        else if typeof contents is 'undefined'
            throw new Exception()
            
generateProject = (layout, config, root) ->
    log = logger 'boilerplate', 'generate'
    
    if not root
        log 'message', "Please specify a root directory to start the project in"
        return
        
    root = path.resolve root
    
    if not path.existsSync root
        fs.mkdir root, '0777'
    else
        log 'message', "Project root #{root} already exists. Please remove it first."
        return
    
    # TODO: Catch exception in the layout function here
    if typeof layout is "function"
        layout = layout config
    
    generateLayout layout, config, root
    
    
# Verification step, this is like --dry-run
verifyLayout = (layout) ->
            
required = () ->
    # Error out if required statements are not present
     
test 'functionValue', 'Contents can be specified by a function that returns a string',
    (setup) ->
    (teardown) -> rmdirr './function_test'
    () ->
        
ROOT = 'toast_test'

test 'generateProject', 'Project generation',
    (setup) ->
        rm_r ROOT
    (teardown) ->
        rm_r ROOT
    () ->        
        README_MD = (config) ->
            # Name is required
            # Desc is optional
            {name, desc} = config
        
            """
            #{name}
            ===========
            
            #{desc ? ''}
            """
        
        ROOT_GITIGNORE = """
        # Assembled from https://github.com/github/gitignore
        """
        
        # Only string literals are allowed as keys in a JSON object
        layout = (config) ->
            'lib':
                "$name.js": ""
            'examples':
                "example.coffee": ""
            'src':
                '.gitignore': ".js"
                "$name.coffee": ""
            'support': {}
            'docs': {}
            'README.md': README_MD
            '.gitignore': ROOT_GITIGNORE
        
        config =
            name:    ROOT
            author:
                name: 'Abi Raja'
                email: 'abii@stanford.edu'
                URL: 'http://abi.sh'
            license:    'MIT'
            repoURL:    'git://github.com/abi/toast.git'
            indentation: '4 spaces' # TODO: Support this
            structure:
                docs: yes
                support: yes

        generateProject layout, config, ROOT
        
        # Test that the directory structure corresponds to what we want and that the files hold the right contents        
        root_files = ['src', 'examples', 'lib', 'support', 'docs', '.gitignore', 'README.md']    
        
        equalSet ls(ROOT), root_files
        equalSet ls(join(ROOT, 'lib')), ["#{ROOT}.js"]
        equalSet ls(join(ROOT, 'src')), ["#{ROOT}.coffee", '.gitignore']
        equalSet ls(join(ROOT, 'examples')), ['example.coffee']
        eq read(join(ROOT, 'README.md')).toString(), README_MD(config)
        eq read(join(ROOT, '.gitignore')).toString(), ROOT_GITIGNORE
 
# TODO: Use the derp CLI to run the tests  
# run 'generateProject'

exports.generateProject = generateProject