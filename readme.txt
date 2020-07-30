upgrade to heroku-18
upgrade to cedar-14

[migration]
sequel sqlite://bookmarks.db -m migrate/ -M 002

[debug]
rackup config.ru

[urls]

* view all bookmarks
get /
get /all(login)
get /page/1
get /page/2

* add bookmark
** form
get /new

** recv
get /new

* view my bookmarks

