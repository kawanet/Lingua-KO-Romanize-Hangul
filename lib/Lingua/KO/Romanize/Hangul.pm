=head1 NAME

Lingua::KO::Romanize::Hangul - Romanization of Korean language

=head1 SYNOPSIS

    use Lingua::KO::Romanize::Hangul;

    my $conv = Lingua::KO::Romanize::Hangul->new();
    my $roman = $conv->char( $hangul );
    printf( "<ruby><rb>%s</rb><rt>%s</rt></ruby>", $hangul, $roman );

    my @array = $conv->string( $string );
    foreach my $pair ( @array ) {
        my( $raw, $ruby ) = @$pair;
        if ( defined $ruby ) {
            printf( "<ruby><rb>%s</rb><rt>%s</rt></ruby>", $raw, $ruby );
        } else {
            print $raw;
        }
    }

=head1 DESCRIPTION

Hangul is phonemic characters of the Korean language.

=head2 $conv = Lingua::KO::Romanize::Hangul->new();

This constructer methods returns a new object.

=head2 $roman = $conv->char( $hangul );

This method returns romanized letters of a Hangul character.
It returns undef when $hanji is not a valid Hangul character.
The argument's encoding must be UTF-8.

=head2 $roman = $conv->chars( $string );

This method returns romanized letters of Hangul characters.

=head2 @array = $conv->string( $string );

This method returns a array of referenced arrays
which are pairs of a Hangul chacater and its romanized letters.

    $array[0]           # first Korean character's pair (array)
    $array[1][0]        # secound Korean character itself
    $array[1][1]        # its romanized letters

=head1 SEE ALSO

L<Lingua::JA::Romanize::Japanese>
L<Lingua::ZH::Romanize::Pinyin>

http://www.kawa.net/works/perl/romanize/romanize-e.html

=head1 AUTHOR

Yusuke Kawasaki http://www.kawa.net/

=head1 COPYRIGHT AND LICENSE

Copyright (c) 1998-2006 Yusuke Kawasaki. All rights reserved.

This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

=cut
# ----------------------------------------------------------------
    package Lingua::KO::Romanize::Hangul;
    use strict;
    use vars qw( $VERSION );
    $VERSION = "0.12";
# ----------------------------------------------------------------
    my $INITIAL_LETTER = [map {$_ eq "-" ? "" : $_} qw(
        g   kk  n   d   tt  r   m   b   bb  s   ss  -   j   jj
        c   k   t   p   h
    )];
    my $PEAK_LETTER = [map {$_ eq "-" ? "" : $_} qw(
        a   ae  ya  yae eo  e   yeo ye  o   wa  wae oe  yo  u
        weo we  wi  yu  eu  yi  i
    )];
    my $FINAL_LETTER = [map {$_ eq "-" ? "" : $_} qw(
        -   g   kk  ks  n   nj  nh  d   r   rg  rm  rb  rs  rt
        rp  rh  m   b   bs  s   ss  ng  j   c   k   t   p   h
    )];
# ----------------------------------------------------------------
sub new {
    my $package = shift;
    my $self = {@_};
    bless $self, $package;
    $self;
}
# ----------------------------------------------------------------
sub char {
    my $self = shift;
    my $char = shift;
    my( $c1, $c2, $c3, $c4 ) = unpack("C*",$char);
    return if ( ! defined $c3 || defined $c4 );
    my $ucs2 = (($c1 & 0x0F)<<12) | (($c2 & 0x3F)<<6) | ($c3 & 0x3F);
    return if ( $ucs2 < 0xAC00 );
    return if ( $ucs2 > 0xD7A3 );
    my $han = $ucs2 - 0xAC00;
    my $init = int( $han / 21 / 28 );
    my $peak = int( $han / 28 ) % 21;
    my $fin  = $han % 28;
    join( "", $INITIAL_LETTER->[$init], $PEAK_LETTER->[$peak], $FINAL_LETTER->[$fin] );
}
# ----------------------------------------------------------------
sub chars {
    my $self = shift;
    my @array = $self->string( shift );
    join( " ", map {$#$_>0 ? $_->[1] : $_->[0]} @array );
}
# ----------------------------------------------------------------
#   [UCS-2] AC00-D7A3
#   [UTF-8] EAB080-ED9EA3
#   EA-ED are appeared only as Hangul's first character.
# ----------------------------------------------------------------
sub string {
    my $self = shift;
    my $src = shift;
    my $array = [];
    while ( $src =~ /([\xEA-\xED][\x80-\xBF]{2})|([^\xEA-\xED]+)/sg ) {
        if ( defined $1 ) {
            my $pair = [ $1 ];
            my $roman = $self->char( $1 );
            $pair->[1] = $roman if defined $roman;
            push( @$array, $pair );
        } else {
            push( @$array, [ $2 ] );
        }
    }
    @$array;
}
# ----------------------------------------------------------------
;1;
# ----------------------------------------------------------------
