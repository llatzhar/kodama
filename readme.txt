[migration]
sequel sqlite://bookmarks.db -m migrate/ -M 002

[debug]
rackup config.ru

[urls]

* view all bookmarks
get /
get /all(login)

* add bookmark
** form
get /new

** recv
get /new

* view my bookmarks

[bookmarklet]
javascript:x=document;
a=encodeURIComponent(x.location.href);
t=encodeURIComponent(x.title);
d=encodeURIComponent(window.getSelection());
location.href='http://localhost:9292/new?url='+a+'&title='+t+'&note='+d;

