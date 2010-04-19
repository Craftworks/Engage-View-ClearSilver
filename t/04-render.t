use strict;
use warnings;
use utf8;
use FindBin;
use Test::More tests => 5;
use Test::Exception;

use_ok 'Engage::View::ClearSilver';

$ENV{'CONFIG_PATH'} = "$FindBin::Bin/conf";

my $view = new_ok( 'Engage::View::ClearSilver' );

dies_ok { $view->template('/') } qr/template must be a file/;
is( $view->template('test'), 'test.cs', 'template' );

$view->loadpaths([ "$FindBin::Bin/template" ]);

$view->data({
    scalar   => 'string',
    arrayref => [ qw(abc xyz) ],
    hashref  => { a => 1, b => 2, c => 3 },
    html     => '<b>&</b>',
});

is( $view->render, <<EOS, 'render' );
scalar:
string
arrayref:
[abc][xyz]
hashref:
1
2
3
escape:
&lt;B&gt;&amp;&lt;/B&gt;
ＵＴＦ８
EOS

