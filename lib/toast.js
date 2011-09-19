(function() {
  var ROOT, deq, dir, eq, equalSet, exit, fs, generateLayout, generateProject, join, log, logger, ls, mkdir, path, read, remove, required, rm_r, run, test, test_logger, throws, util, verifyLayout, write, _, _ref, _ref2;
  var __slice = Array.prototype.slice;
  fs = require('fs');
  path = require('path');
  util = require('util');
  require('exceptional');
  _ref = require('node_util').sync(), read = _ref.read, write = _ref.write, remove = _ref.remove, mkdir = _ref.mkdir, join = _ref.join, ls = _ref.ls, rm_r = _ref.rm_r;
  exit = require('termspeak').exit;
  _ref2 = require('derp'), test = _ref2.test, eq = _ref2.eq, throws = _ref2.throws, run = _ref2.run, deq = _ref2.deq, equalSet = _ref2.equalSet;
  _ = require('underscore');
  _.mixin(require('underscore.string'));
  log = console.log, dir = console.dir;
  logger = function(module, context, output) {
    if (output == null) {
      output = 'terminal';
    }
    return function(type, msg) {
      var outputFn;
      outputFn = console.log;
      if (output === 'terminal') {
        outputFn = console.log;
      }
      return outputFn("[" + module + "] [" + context + "] [" + type + "] " + msg);
    };
  };
  test_logger = function() {
    log = logger('logger', 'test');
    return log('control', 'Starting up...');
  };
  generateLayout = function(layout, config, root) {
    var contents, file, _results;
    if (root == null) {
      root = './';
    }
    log = logger('boilerplate', 'generate');
    _results = [];
    for (file in layout) {
      contents = layout[file];
      if (_(file).includes('$')) {
        file = file.replace(/(\$[^\$\.]*)/g, function() {
          var args;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          return config[args[0].split('$')[1]];
        });
        log('control', file);
      }
      _results.push((function() {
        if (typeof contents === 'object') {
          log('control', "Making dir " + file + " at " + root);
          fs.mkdir(path.join(root, file), '0777');
          return generateLayout(contents, config, join(root, file));
        } else if (typeof contents === 'function') {
          log('control', "Writing file " + file + " at " + root);
          return write(path.join(root, file), contents(config));
        } else if (typeof contents === 'string') {
          log('control', "Writing file " + file + " at " + root);
          return write(path.join(root, file), contents);
        } else if (typeof contents === 'undefined') {
          throw new Exception();
        }
      })());
    }
    return _results;
  };
  generateProject = function(layout, config, root) {
    log = logger('boilerplate', 'generate');
    if (!root) {
      log('message', "Please specify a root directory to start the project in");
      return;
    }
    root = path.resolve(root);
    if (!path.existsSync(root)) {
      fs.mkdir(root, '0777');
    } else {
      log('message', "Project root " + root + " already exists. Please remove it first.");
      return;
    }
    if (typeof layout === "function") {
      layout = layout(config);
    }
    return generateLayout(layout, config, root);
  };
  verifyLayout = function(layout) {};
  required = function() {};
  test('functionValue', 'Contents can be specified by a function that returns a string', function(setup) {}, function(teardown) {
    return rmdirr('./function_test');
  }, function() {});
  ROOT = 'toast_test';
  test('generateProject', 'Project generation', function(setup) {
    return rm_r(ROOT);
  }, function(teardown) {
    return rm_r(ROOT);
  }, function() {
    var README_MD, ROOT_GITIGNORE, config, layout, root_files;
    README_MD = function(config) {
      var desc, name;
      name = config.name, desc = config.desc;
      return "" + name + "\n===========\n\n" + (desc != null ? desc : '');
    };
    ROOT_GITIGNORE = "# Assembled from https://github.com/github/gitignore";
    layout = function(config) {
      return {
        'lib': {
          "$name.js": ""
        },
        'examples': {
          "example.coffee": ""
        },
        'src': {
          '.gitignore': ".js",
          "$name.coffee": ""
        },
        'support': {},
        'docs': {},
        'README.md': README_MD,
        '.gitignore': ROOT_GITIGNORE
      };
    };
    config = {
      name: ROOT,
      author: {
        name: 'Abi Raja',
        email: 'abii@stanford.edu',
        URL: 'http://abi.sh'
      },
      license: 'MIT',
      repoURL: 'git://github.com/abi/toast.git',
      indentation: '4 spaces',
      structure: {
        docs: true,
        support: true
      }
    };
    generateProject(layout, config, ROOT);
    root_files = ['src', 'examples', 'lib', 'support', 'docs', '.gitignore', 'README.md'];
    equalSet(ls(ROOT), root_files);
    equalSet(ls(join(ROOT, 'lib')), ["" + ROOT + ".js"]);
    equalSet(ls(join(ROOT, 'src')), ["" + ROOT + ".coffee", '.gitignore']);
    equalSet(ls(join(ROOT, 'examples')), ['example.coffee']);
    eq(read(join(ROOT, 'README.md')).toString(), README_MD(config));
    return eq(read(join(ROOT, '.gitignore')).toString(), ROOT_GITIGNORE);
  });
  exports.generateProject = generateProject;
}).call(this);
