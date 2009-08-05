package Engage::Helper::View::ClearSilver;

use strict;
use warnings;

=head1 NAME

Engage::Helper::View::ClearSilver - The great new Engage::Helper::View::ClearSilver!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Engage::Helper::View::ClearSilver;

    my $foo = Engage::Helper::View::ClearSilver->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 FUNCTIONS

=head2 mk_compclass

=cut

sub mk_compclass {
    my ( $self, $helper ) = @_;
    my $file = $helper->{file};
    $helper->render_file( 'compclass', $file );
}

=head1 AUTHOR

Craftworks, C<< <craftwork at cpan org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-engage-view-clearsilver at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Engage-View-ClearSilver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Engage::Helper::View::ClearSilver


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Engage-View-ClearSilver>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Engage-View-ClearSilver>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Engage-View-ClearSilver>

=item * Search CPAN

L<http://search.cpan.org/dist/Engage-View-ClearSilver/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Craftworks.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Engage::Helper::View::ClearSilver

__DATA__

__compclass__
package [% class %];

use strict;
use base 'Engage::View::ClearSilver';

=head1 NAME

[% class %] - ClearSilver View for [% app %]

=head1 DESCRIPTION

ClearSilver View for [% app %].

=head1 SEE ALSO

L<[% app %]>

=head1 AUTHOR

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
