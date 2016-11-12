#!/usr/bin/perl
use threads;

my @threads;
my $Tcount=0;

$ihex = "main.ihex";
$tosboot = "tosboot.ihex";
$info = `motelist -usb > motelist.txt`;
$path = "build/telosb/";

$baseid = 0;
$basedir = "./Disseminator/$path";
$nodedir = "./Node/$path";
$dir = "";

system("$info");
@usbmaps =();
open fd, "<usbzju_30" or die "cannot open map file\n";
while (<fd>) {
	chomp;
	@ret = split;
	
	if ($ret[4] =~ /ttyUSB/) {
		$id = $ret[0];
		#$usbport = $ret[2];
		$usbport = $ret[3];
		$usbmaps[$id] = $usbport;
	}
}
close fd;

sub findid() {
	my ($usbport) = @_;
	for (my $i=0; $i<90; $i++) {
		if ($usbmaps[$i] eq $usbport) {
			return $i;
		}
	}	
	return 0xffff;
}

sub ext(){
my ($cmd)=@_;
system("$cmd");
}

$id = 100;
open list, "<motelist.txt" or die "cannot open file";


for ( $ii=0; $ii<30; $ii++) {
 seek(list, 0, SEEK_SET);
 while (<list>) {

  chomp;
  @ret = split;
  if ($ret[4] =~ /ttyUSB/) {
    $port = $ret[4];
    #$usbport = $ret[2];
    $usbport = $ret[3];

    ##$id = &findid($usbport);
    #print "$_\n";                                                           
    
    $id=$ii;
    #print "$usbport\n";
    #print "$usbmaps[$id]\n";
    #print "\n";
    if ($usbport eq $usbmaps[$id]) {
        if ($id == $baseid) {
            $dir = $basedir;
        } else {
            $dir = $nodedir;
        }
    
        $cmd = "tos-set-symbols --objcopy msp430-objcopy --objdump msp430-objdump --target ihex $dir$ihex $dir$ihex-$id.out TOS_NODE_ID=$id ActiveMessageAddressC__addr=$id";
        print "$cmd\n";
        system("$cmd");

        $cmd = "tos-bsl --telosb -c $port -r -e -I -p $dir$ihex-$id.out";
        print "$cmd\n";
        #system("$cmd &");
        $threads[$Tcount++]=threads->new(\&ext,$cmd);
        print "complete $ii\n";
        last;
    }
  }
 }
}

foreach my $thread (@threads){
 $thread->join();
}

close list;
