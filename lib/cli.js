(function() {
  var args, config, generateProject, layout, pred;
  generateProject = require('./toast').generateProject;
  pred = require('termspeak').pred;
  args = process.argv.slice(2);
  console.log(args);
  switch (args[0]) {
    case 'generate':
      layout = require('../bread/node-coffee').layout;
      config = require('../examples/example').config;
      generateProject(layout, config, './' + config.name);
      break;
    default:
      pred("Invalid argument. Valid arguments are: generate {DIR}");
  }
}).call(this);
