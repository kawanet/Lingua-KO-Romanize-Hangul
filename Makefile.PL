use strict;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Lingua::KO::Romanize::Hangul',
    VERSION_FROM        => 'lib/Lingua/KO/Romanize/Hangul.pm',
    PREREQ_PM           => {
        'Test::More'    => '0',
    },
);
