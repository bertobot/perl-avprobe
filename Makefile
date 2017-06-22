
install:
	/usr/bin/rsync -avz lib/perl5/ /usr/local/lib/site_perl/

uninstall:
	/bin/rm -vf /usr/local/lib/site_perl/AVProbe.pm

# TODO: need to research optimal path for 3rd-party paths.  going off of memory/habit
