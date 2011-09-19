toast
===========

Toast helps you declaratively generate directory/file structures (useful for generating test fixtures and boilerplates for project).

**This module is not quite ready. Check back in a week or two.**

Usage
=====

See `/bread` for the bread.

Ideas
=====

* Occasional disk flushing errors that occur (important)
* Make this a more useful CLI tool, interactively or otherwise in a $EDITOR, create a directory structure and generate
  it immediately. Possibly leave a trace in the directory as '.bread' file which you can later check for divergence
  from the original file and directory structure in order to better make boilerplates next time.
* Have a global bread directory where all of your bread is stored and it's easy to include file templates you want, etc.
* Keep a global log of everything done with toast in /var/log
* Support for
    git init
    git remote add origin git@github.com:abi/derp.git
    git push -u origin master
* Check all names before exporting boilerplate
* Boilerplate should include a Cakefile that helps you do common things including NPM-related things
* Sharing of bread

TODO
====

* Split tests into more finer-grained unit tests rather than one large functional test
* Think of a good way to have required and optional arguments to functions
