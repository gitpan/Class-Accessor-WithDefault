#!perl
use Test::More tests => 5;

require_ok('Class::Accessor::WithDefault') ;

@Foo::ISA = qw(Class::Accessor::WithDefault);
Foo->mk_accessors(qw/a/,{b => 5});

my $test = Foo->new({c => 6});
ok $test->can('b'),"b exists";
is $test->b,5;
$test->a(6);
is $test->a,6;
$test->b(7);
is $test->b,7;
