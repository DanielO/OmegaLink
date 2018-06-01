Omega Indexer File Selector
====

This Power Shell script can be registered as a protocol handler and will lookup a path prefix from the registry and then run Explorer and select the file.

This can be used with Xapian Omega to generate search result links that open documents on the desktop.

## Installation instructions

The registry example will prefix \\gateway to the paths (ie my server name) and expect the PS script to be installed into C:\Program Files\OmegaLink. Adjust if this doesn't match your configuration.

Modify your Xapian Omega template to emit links of the form
omegalink://host/path

`host` can be empty, but if not it will be used to lookup a prefix key.


### ToDo

Write a proper installer


### Bugs? Questions? Suggestions?

Please feel free to email me at darius@dons.net.au


### Thanks
Stack Overflow.
Igal Tabachnik, author of the ChromeRegJump extension (https://github.com/hmemcpy/ChromeRegJump) which gave me an idea.

