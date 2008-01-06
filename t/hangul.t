# ----------------------------------------------------------------
    use strict;
    use Test::More tests => 8;
    BEGIN { use_ok('Lingua::KO::Romanize::Hangul'); };
# ----------------------------------------------------------------
{
    my $roman = Lingua::KO::Romanize::Hangul->new();
    ok( ref $roman, "new" );

    ok( (! defined $roman->char("a")), "char: ascii" );
    is( $roman->char("\xEA\xB0\x80"), "ga", "char: ga (AC00)" );
    is( $roman->char("\xED\x9E\xA3"), "hih", "char: hih (D7A3)" );

    my $c4 = $roman->chars("\xec\x97\xac\xeb\xb3\xb4\xec\x84\xb8\xec\x9a\x94");
    is( $c4, "yeo bo se yo", "chars: yeoboseyo [$c4]" );

    my @s1 = $roman->string("\xED\x95\x9C\xEA\xB8\x80");
    is( $s1[0][1], "han", "string: han [$s1[0][1]]" );
    is( $s1[1][1], "geur", "string: geur [$s1[1][1]]" );
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
