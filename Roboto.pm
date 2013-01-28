package Roboto;
use strict;
no strict 'refs';

use WWW::Mechanize;

our %RULES;

sub configure { %RULES = @_; }

sub capture_rule {
	my($page, $rule) = @_;
	# TODO: just return pages matching this regex
	return 1;
}

sub crawl {
	my($url, $callback) = @_;
	my %addrs = ($url => 0);
	
	while (1) {
		my $mech = WWW::Mechanize->new(autocheck => 1); $mech->get($url);
		# get all page links
		my @links = $mech->find_all_links;
		# stores all the links to visit
		my @to_visit = grep { $addrs{$_} == 0 } keys %addrs;
		
		# exits if theres no more links to visit
		last unless @to_visit;

		foreach my $addr (@to_visit) {
			# page representation that user will use
			my %page = (
				addr => $addr,
				content => $mech->content
			);

			# add new links of the current page
			foreach my $link (@links) {
				my $tmp = $link->[0];
				
				$tmp = $addr.$tmp if ($tmp =~ /^\//);
				
				unless (exists $addrs{$tmp}) {
					$addrs{$tmp} = 0;
				}
			}

			# execute the 'user block', filtering page if any filter was given
			if (keys %RULES) {
				my $satisfy = 1;

				while( my($config, $rule) = each %RULES) {
					unless (&$config(\%page, $rule)) {
						$satisfy = 0;
						last;
					}
				}

				&$callback(\%page) if $satisfy;
			}
			else {
				&$callback(\%page);
			}
		}
	}
}


42;
