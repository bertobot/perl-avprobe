package AVProbe;

use strict;
use JSON;

use Class::MethodMaker [
    scalar  => [ qw( avprobe data error ) ],
    new     => [ qw( -init new ) ],
];

sub init {
    my ($self, $args) = @_;

    $self->avprobe($args->{avprobe} || '/usr/bin/avprobe');

    if ($args->{file}) {
        my $pipe;
    
        if (open $pipe, sprintf("%s %s 2>&1 |", $self->avprobe, $args->{file}) ) {
            $self->data($self->_parse($pipe));
            close $pipe;
        }
        else {
            $self->error($!);
        }
    }
}

sub _parse {
    my ($self, $handle) = @_;

    my @list = ();
    my $ref = {};

    while (my $line = <$handle>) {
        chomp $line;

        if ($line =~ /^Input \#(.+?),\s+(.+?),/) {
            push @list, $ref if $1;

            $ref = {
                number      => $1,
                type        => $2,
                streams     => [],
            };
        }
        else {

            # grab duration info
            if ($line =~ /^\s+Duration: (.+?), start: (.+?), bitrate: (.+)$/) {
                $ref->{duration}    = $1;
                $ref->{start}       = $2;
                $ref->{bitrate}     = $3;
            }

            # grab stream info
            elsif ($line =~ /^\s+Stream\s+#(\d+:\d+):\s+(.+?):\s+/) {
                my $stream = { 
                    type    => $2,
                    details => [ split /,\s+/, $' ],
                };

                push @{ $ref->{streams} }, $stream;
            }

            # grab metadata based on pattern
            elsif ($line =~ /^\s+(.+?)\s*:\s+(.+)$/) {
                $ref->{$1} = $2;
            }

        }
    }

    return $ref;
}

sub valid {
    return defined $_[0]->data && exists $_[0]->data->{number};
}

sub json {
    return encode_json($_[0]->data);
}

sub keys {
    return [ keys %{ $_[0]->data } ];
}

sub get {
    my ($self, $key) = @_;

    return $self->data->{$key};
} 

sub runtime {
    my ($self) = @_;

    my ($hours, $mins, $seconds) = split /:/, $self->data->{duration};

    return $seconds + ($mins * 60) + ($hours * 3600);
}

1;

