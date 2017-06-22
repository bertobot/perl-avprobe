# AVProbe
A Perl-wrapper for ffmpeg / avprobe.  

This library is useful for querying metadata for content about various media.

## Synopsis

```perl
use strict;
use AVProbe;

my $metadata = new AVProbe({
	file 	=> '/path/to/media',	# required
  	avprobe	=> '/path/to/avprobe',	# optional, if non-standard installation of ffmpeg/avprobe
});

if ($metadata->valid) {
    # get a list of top-level keys
    my $listref		= $metadata->keys;
    
    # the following two keys are guaranteed to be present
    my $bitrate 	= $metadata->get('bitrate');
    my $duration 	= $metadata->get('duration');
    
    # get the duration in seconds.
    my $runtime		= $metadata->runtime;
    
    # convenience methods
    my $hash		= $metadata->data;
    my $json		= $metadata->json;  
}

else {
	warn sprintf("error: %s\n", $metadata->error);
}
```

## Dependencies
* libjson-perl (ubuntu) | perl-libjson (redhat / centos / fedora)
* ffmpeg / avconv

## TODO
* convert hasVideo / hasAudio to boolean, rather than the string 'true' or 'false'
* interpolate high-level metadata like fps, tbr, resolution.
