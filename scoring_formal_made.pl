use strict;
use warnings;
use Test::More tests => 840;
use Games::Cards::Bridge::Scoring;

# port from Games-Cards-Bridge-Contract-0.02/t/scoring-duplicate.t, 
# originally written by David Westbrook

$|=1;

sub check_scores {
  my ($bid_val, $trump_chr, $made, $scores) = @_;

  foreach my $i ( 0..$#$scores ){
    my $expected = $scores->[$i];
    my $vul_val = $i >= 3;
    my $dbl_val = $i % 3;
    my $my_contract = Contract->new(
            declarer => "N", 
            trump=>$trump_chr, 
            bid_finalized=>$bid_val, 
            vul=>$vul_val, 
            dbl=>$dbl_val,
        );
    my $my_outcome = Outcome->new(
            contract=>$my_contract, 
            tricks_winned => $made + 6,
        );
    my $score = Scoring->new(outcome=>$my_outcome)->duplicate_score;
    is($score, $expected, sprintf("%d%s/%d vul=%d dbl=%d ==> %d", $bid_val, $trump_chr, $made, $vul_val, $dbl_val, $expected) );
  }
}

while(<DATA>){
  s/^\s+//g;
  s/\s+$//sg;
  s/^#.+//;
  next unless length;
  my ($contract, $made, @scores) = split ' ', $_;
  $contract =~ /(\d)([mMN])/ or next;
  my ($bid, $trump) = ($1, $2);

  if( $trump eq 'm' ){
    check_scores( $bid, 'C', $made, \@scores );
    check_scores( $bid, 'D', $made, \@scores );
  }elsif( $trump eq 'M' ){
    check_scores( $bid, 'H', $made, \@scores );
    check_scores( $bid, 'S', $made, \@scores );
  }else{
    check_scores( $bid, $trump, $made, \@scores );
  }
}

__DATA__
#		Non-Vulnerable		Vulnerable
#Bid	Made	Undbl	Dbl	Redbl	Undbl	Dbl	Redbl
1m	1	70	140	230	70	140	230
1m	2	90	240	430	90	340	630
1m	3	110	340	630	110	540	1030
1m	4	130	440	830	130	740	1430
1m	5	150	540	1030	150	940	1830
1m	6	170	640	1230	170	1140	2230
1m	7	190	740	1430	190	1340	2630
1M	1	80	160	520	80	160	720
1M	2	110	260	720	110	360	1120
1M	3	140	360	920	140	560	1520
1M	4	170	460	1120	170	760	1920
1M	5	200	560	1320	200	960	2320
1M	6	230	660	1520	230	1160	2720
1M	7	260	760	1720	260	1360	3120
1N	1	90	180	560	90	180	760
1N	2	120	280	760	120	380	1160
1N	3	150	380	960	150	580	1560
1N	4	180	480	1160	180	780	1960
1N	5	210	580	1360	210	980	2360
1N	6	240	680	1560	240	1180	2760
1N	7	270	780	1760	270	1380	3160
2m	2	90	180	560	90	180	760
2m	3	110	280	760	110	380	1160
2m	4	130	380	960	130	580	1560
2m	5	150	480	1160	150	780	1960
2m	6	170	580	1360	170	980	2360
2m	7	190	680	1560	190	1180	2760
2M	2	110	470	640	110	670	840
2M	3	140	570	840	140	870	1240
2M	4	170	670	1040	170	1070	1640
2M	5	200	770	1240	200	1270	2040
2M	6	230	870	1440	230	1470	2440
2M	7	260	970	1640	260	1670	2840
2N	2	120	490	680	120	690	880
2N	3	150	590	880	150	890	1280
2N	4	180	690	1080	180	1090	1680
2N	5	210	790	1280	210	1290	2080
2N	6	240	890	1480	240	1490	2480
2N	7	270	990	1680	270	1690	2880
3m	3	110	470	640	110	670	840
3m	4	130	570	840	130	870	1240
3m	5	150	670	1040	150	1070	1640
3m	6	170	770	1240	170	1270	2040
3m	7	190	870	1440	190	1470	2440
3M	3	140	530	760	140	730	960
3M	4	170	630	960	170	930	1360
3M	5	200	730	1160	200	1130	1760
3M	6	230	830	1360	230	1330	2160
3M	7	260	930	1560	260	1530	2560
3N	3	400	550	800	600	750	1000
3N	4	430	650	1000	630	950	1400
3N	5	460	750	1200	660	1150	1800
3N	6	490	850	1400	690	1350	2200
3N	7	520	950	1600	720	1550	2600
4m	4	130	510	720	130	710	920
4m	5	150	610	920	150	910	1320
4m	6	170	710	1120	170	1110	1720
4m	7	190	810	1320	190	1310	2120
4M	4	420	590	880	620	790	1080
4M	5	450	690	1080	650	990	1480
4M	6	480	790	1280	680	1190	1880
4M	7	510	890	1480	710	1390	2280
4N	4	430	610	920	630	810	1120
4N	5	460	710	1120	660	1010	1520
4N	6	490	810	1320	690	1210	1920
4N	7	520	910	1520	720	1410	2320
5m	5	400	550	800	600	750	1000
5m	6	420	650	1000	620	950	1400
5m	7	440	750	1200	640	1150	1800
5M	5	450	650	1000	650	850	1200
5M	6	480	750	1200	680	1050	1600
5M	7	510	850	1400	710	1250	2000
5N	5	460	670	1040	660	870	1240
5N	6	490	770	1240	690	1070	1640
5N	7	520	870	1440	720	1270	2040
6m	6	920	1090	1380	1370	1540	1830
6m	7	940	1190	1580	1390	1740	2230
6M	6	980	1210	1620	1430	1660	2070
6M	7	1010	1310	1820	1460	1860	2470
6N	6	990	1230	1660	1440	1680	2110
6N	7	1020	1330	1860	1470	1880	2510
7m	7	1440	1630	1960	2140	2330	2660
7M	7	1510	1770	2240	2210	2470	2940
7N	7	1520	1790	2280	2220	2490	2980
