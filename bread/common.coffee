README_MD = (config) ->
    # Name is required
    # Desc is optional
    {name, desc} = config

    """
    #{name}
    ===========
    
    #{desc ? ''}
    
    Goals
    =====
    
    Usage
    =====
    
    
    TODO
    ====
    
    * Write code
    
    """
        
# TODO: ROOT_GITIGNORE is actually coffee specific, it should not be
ROOT_GITIGNORE = """
# Assembled from https://github.com/github/gitignore

#Linux

.* # LOOK HERE (BE VERY CAREFUL ABOUT THIS. IT IGNORES ALL DOTFILES OTHER THAN .gitignore and .npmignore)
!.gitignore
!.npmignore
*~

# KDE
.directory

#OS X

.DS_Store
Icon?

# Thumbnails
._*

# Files that might appear on external disk
.Spotlight-V100
.Trashes

#Textmate

*.tmproj
*.tmproject
tmtags

#Vim

.*.sw[a-z]
*.un~
Session.vim

#Emacs

*~
\#*\#
/.emacs.desktop
/.emacs.desktop.lock
.elc
auto-save-list
tramp

# Remnants when using npm
npm-debug.log

# Remnants when using `npm link` while using this module
node_modules

# Module-specific
# Add stuff here ....

"""
        
LICENSE = (config) ->
    {name, email} = config.author
    
    if config.license is 'MIT'
        return """
        Copyright (c) 2011 #{name} <#{email}>

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
        documentation files (the 'Software'), to deal in the Software without restriction, including without limitation
        the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
        to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of
        the Software.

        THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
        THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
        TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
        """
        
exports.LICENSE = LICENSE
exports.README_MD = README_MD
exports.ROOT_GITIGNORE = ROOT_GITIGNORE