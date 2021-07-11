# vim-nyambung-db.vim
vim-nyambung-db is a plugin that helps you to connect with mysql cli without exiting vim, and stick to the jargon of working without using a mouse

## Installation
### Prerequisites
Make sure you have installed these this plugin in your vim:
```vim
Plug 'vimwiki/vimwiki'
```
### Installation with [Vim-Plug](https://github.com/junegunn/vim-plug)
Add the following to the plugin-configuration in your vimrc:
```vim
Plug 'sheenazien8/vim-nyambung-db', { 'do': 'pip3 install mysql-connector' }
```

## Configuration
set the credentials global variable
```vim
let g:credentials = "host=localhost;user=homestead;password=secret"
```

## Usage
```vim
:call ConnectTheDB()
:Database: <yourname database>
:Query: <your statement sql>

select the query
:'<,'>DBExecuteSelection
:Databasee: <yourname database>
```

## Mapping
* `ctrl-x`: Close window query result
* `F11`: Run call ConnectTheDB()

## Support Us
I invest a lot of resources into creating this thing. You can support me by pressing the star button in the top right corner, or buy me a cup of coffee to brew together.

## License
Copyright ©sheenazien8. Distributed under the same terms as Vim itself.
See [LICENSE](LICENSE)
