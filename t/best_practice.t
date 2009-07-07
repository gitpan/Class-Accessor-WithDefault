#!perl
use Test::More tests => 8;                      # last test to print
require_ok('Class::Accessor::WithDefault') ;

@Foo::ISA = qw(Class::Accessor::WithDefault);
Foo->follow_best_practice;
Foo->mk_accessors(qw/a/,{b => 5});
Foo->mk_ro_accessors({c => 7});
$test = Foo->new();
ok $test->can("set_a"), "set_a exists";
ok $test->can("set_b"), "set_b exists";
ok $test->can("get_b"), "get_b exists";

is $test->get_b, 5;
ok $test->can("get_c"), "get_c exists";
ok !$test->can("set_c"), "set_c exists";
is $test->get_c, 7;



