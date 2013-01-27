roboto
======

Perl Framework to create Web Spiders

Example:

```perl
#!/usr/bin/env perl
use Roboto;

Roboto::configure(
	capture_rule => /Perl Hacker/i, #will only get pages matching this content
);

Roboto::crawl "http://www.google.com", sub {
	my $page = shift;

	print "Now I'm on " . $page->{addr} . "\n";
};
```
