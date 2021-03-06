#!/usr/bin/perl

#print exec('make telosb install,1 bsl,/dev/ttyUSB1');
#print exec('make telosb install,2 bsl,/dev/ttyUSB2');
print "Hello,world!\n";

    use threads;
    use Thread::Queue;

    my @workers;
    my $num_threads = shift;
    my $dbname = shift;
    my $queue = new Thread::Queue;

    for (0..$num_threads-1) {
            $workers[$_] = new threads(\&worker);
                    print "TEST!\n";
    }

    while ($_ = shift @ARGV) {
            $queue->enqueue($_);
    }

    sub worker() {
            while ($file = $queue->dequeue) {
                    system ('./parser.pl', $dbname, $file);
            }
    }

    for (0..$num_threads-1) { $queue->enqueue(undef); }
    for (0..$num_threads-1) { $workers[$_]->join; }
