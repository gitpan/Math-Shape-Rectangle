use strict;
use warnings;
package Math::Shape::Rectangle;
$Math::Shape::Rectangle::VERSION = '0.02';
use Math::Shape::Point;
use Math::Trig ':pi';
use 5.008;
use Carp;

# ABSTRACT: a 2d rectangle in cartesian space

sub new {
    croak 'Incorrect number of arguments passed to new()' unless @_ == 6;
    my ($class, $x, $y, $r, $length, $width) = @_;
    my $self =
        bless  { centre => Math::Shape::Point->new($x, $y, $r),
                 length => $length,
                 width  => $width },
               $class;

    $self->_calculate_corners;
    return $self;
}


sub rotate {
    $_[0]->{centre}->rotate($_[1]);
    $_[0]->{tl}->rotate_about_point($_[0]->{centre}, $_[1]);
    $_[0]->{tr}->rotate_about_point($_[0]->{centre}, $_[1]);
    $_[0]->{bl}->rotate_about_point($_[0]->{centre}, $_[1]);
    $_[0]->{br}->rotate_about_point($_[0]->{centre}, $_[1]);
}


sub get_points {
    my $self = shift;
    {
        tl => $self->{tl},
        tr => $self->{tr},
        bl => $self->{bl},
        br => $self->{br},
    };
}


# FIXME - doesn't work when r != 0 or pi

sub _calculate_corners {
    my $self = shift;

    $self->{tl} = Math::Shape::Point->new(
        $self->{centre}{x} - int (sin($self->{centre}{r} - pip2)
                                  * (1 / sin($self->{centre}{r} - pip2))),
        $self->{centre}{y} + int( cos($self->{centre}{r} - pip2)
                                  * (1 / cos($self->{centre}{r} - pip2))),
        $self->{centre}{r});

    $self->{tr} = Math::Shape::Point->new(
        $self->{centre}{x} + int (sin($self->{centre}{r} - pip2)
                                  * (1 / sin($self->{centre}{r} - pip2))),
        $self->{centre}{y} + int( cos($self->{centre}{r} - pip2)
                                  * (1 / cos($self->{centre}{r} - pip2))),
        $self->{centre}{r});

    $self->{bl} = Math::Shape::Point->new(
        $self->{centre}{x} - int (sin($self->{centre}{r} - pip2)
                                  * (1 / sin($self->{centre}{r} - pip2))),
        $self->{centre}{y} - int( cos($self->{centre}{r} - pip2)
                                  * (1 / cos($self->{centre}{r} - pip2))),
        $self->{centre}{r});

    $self->{br} = Math::Shape::Point->new(
        $self->{centre}{x} + int (sin($self->{centre}{r} - pip2)
                                  * (1 / sin($self->{centre}{r} - pip2))),
        $self->{centre}{y} - int( cos($self->{centre}{r} - pip2)
                                  * (1 / cos($self->{centre}{r} - pip2))),
        $self->{centre}{r});
    1;
}


1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Math::Shape::Rectangle - a 2d rectangle in cartesian space

=head1 VERSION

version 0.02

=head2 rotate

Requires a numerical argument in radians and turns the rectangle. Negative numbers rotate left and positive numbers rotate right.

    use Math::Trig ':pi';
    $rectangle->rotate(pip2); # turn half pi radians (90 degrees) right;
    $rectangle->rotate(-pi); # turn pi radians (180 degrees) left;

=head2 get_points

Returns hashref of points.

=head1 INTERNAL METHODS

=head2 _calculate_corners

Creates the 4 point objects that represent the corners of the rectangle.

=head1 REPOSITORY

L<https://github.com/sillymoose/Math-Shape-Rectangle.git>

=head1 AUTHOR

David Farrell <sillymoos@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
