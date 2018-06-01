How to setup Xapian Omega for file searching
====
## Introduction
This document is a rough tutorial for setting up Xapian Omega to
search a set of documents shared via Samba. This is typical of a small
business scenario.

It is based on several FreeBSD installations but could be applied to
Linux as well.

## Prerequisties
* Xapian Omega installation (eg pkg install xapian-omega)
* Samba
* CGI capable web server (Apache, Lighttpd, nginx, etc)

## Backend
Firstly you need to work out what you want to index and how they are
accessible to users.

In this example our server running Samba is called `gateway`, it also
hosts the web site Omega runs on for user searches but that can be
separate if you prefer.

We have two file shares we want users to be able to index,
* `/home/documents` - Accessible as `\\gateway\documents`
* `/home/templates` - Accessible as `\\gateway\templates`

We are storing the resulting indexes under `/home/omega`

These are indexed with the following commands
```
/usr/local/bin/omindex --db=/home/omega/documents --url=/documents /home/documents
/usr/local/bin/omindex --db=/home/omega/templates --url=/templates /home/templates
```

These can be run manually but typically they would be run in a cronjob
(daily or weekly).

## Test search
Xapian Omega expects a configuration file at
`/usr/local/etc/omega.conf` (on FreeBSD) which tells it where to find
templates and databases.

For example
```
database_dir /home/omega
template_dir /usr/local/etc/omega/templates
log_dir /var/log/omega
cdb_dir /var/lib/omega/cdb
```

Unfortunately the FreeBSD port does not install the sample templates
by default so you will need to download the tarball and extract them
or get them from
https://git.xapian.org/?p=xapian;a=tree;f=xapian-applications/omega/templates;h=86ac5f82bff09b5df98e0532c5fbf7420a31195f;hb=HEAD
and copy them to `/usr/local/etc/omega/templates`

Note that it will search a database called `default` unless you
specify otherwise. This can be an actual database, or a text file
pointing to one or more real databases. In this case
`/home/omega/default` contains the following
```
auto /home/omega/documents
auto /home/omega/templates
```

Once this is done you should be able to produce result page by running
```
echo P=abc | /usr/local/www/xapian-omega/cgi-bin/omega
```

Note that Xapian comes with several tools to query databases, eg
xapian-delve, xapian-list, etc

## Web serving
In this example we are using lighttpd but it can be any server capable
of running CGI scripts (note that nginx can do this with
https://github.com/ruudud/cgi).

Edit `/usr/local/etc/lighttpd/conf.d/cgi.conf` to enable cgi-bin
handling (uncomment the lines at the bottom). Make sure the alias
module is enabled in the `modules.conf`.

If you wish to serve documents via http (as well as SMB) then edit
`/usr/local/etc/lighttpd/lighttpd.conf` and point
`server.document-root` to the right spot, alternatively you can create
symlinks which give the correct mapping.

In this case we have
```
server.document-root = "/usr/local/www/data/"
```
and `/usr/local/www/data` has symlinks to the right places, ie
```
[gateway 16:36] ~ >ll /usr/local/www/data
total 1
lrwxr-xr-x  1 root  wheel  15 May 30 00:12 documents -> /home/documents
lrwxr-xr-x  1 root  wheel  15 May 30 00:12 templates -> /home/templates
```

With this setup you should now be able to visit
http://your.server.here/cgi-bin/omega and perform a search.

## Query template
Xapian omega generates web pages with a template using Omega Script
which is documented at https://xapian.org/docs/omega/omegascript.html

To find the per-result part of the template search for '$hitlist{'. In
this case we modify it to show the URL and provide 2 links, one for
download and one for local visit.
```
<td>
$html{$field{url}}<br>
<small>$snippet{$field{sample}}</small><br>
<a href="omegalink://$html{$field{url}}">Visit Locally</a>
<a href="$html{$field{url}}">Download</a><br>
```

The `omegalink` version will be directed to OmegaLink when the
registry key is installed.

Once this template is working you will have a Download link like
`/documents/mydoc.doc` and a Visit Locally link like
`omegalink:///documents/mydoc.doc`.

Note that Omega Link should support a non-empty host if you need to
have a different prefix for some hosts but it's not been tested yet.

The omegalink URL will cause the PowerShell script to lookup the
prefix - in this case `\\gateway` and then run Windows Explorer to
select the file `\\gateway\documents\mydoc.doc`

Clicking on the Visit Locally link should then open Windows Explorer
with the file selected.

The PowerShell script can be tested in cmd.exe if you are having
issues.
