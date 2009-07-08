use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Class::Accessor::WithDefault',
    VERSION_FROM      => 'lib/Class/Accessor/WithDefault.pm', # finds $VERSION
    PREREQ_PM         => {Class::Accessor => 0}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/Class/Accessor/WithDefault.pm', # retrieve abstract from module
       AUTHOR         => 'Woosley.Xu') : ()),
);
