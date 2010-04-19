package Engage::View::ClearSilver;

=head1 NAME

Engage::View::ClearSilver - Engage ClearSilver View Class

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Engage::View::ClearSilver;

    my $foo = Engage::View::ClearSilver->new();
    ...

=cut

use Moose;
use Moose::Util::TypeConstraints;
use Text::ClearSilver;
use Engage::Exception;
with 'Engage::Utils';
with 'Engage::Log';

our $VERSION = '0.01';

subtype 'PathFile'
    => as 'Str'
    => where { length && !m{/$} }
    => message { 'template must be a file' };

has 'cs' => (
    is  => 'ro',
    isa => 'Text::ClearSilver',
    default => sub {
        Text::ClearSilver->new(
            'VarEscapeMode' => 'none',
            'functions' => [qw(string)],
        );
    },
);

has 'loadpaths' => (
    is  => 'rw',
    isa => 'ArrayRef[Maybe[Str]]',
    default => sub { [] },
);

has 'template' => (
    is  => 'rw',
    isa => 'PathFile',
    trigger => sub {
        my ( $self, $template ) = @_;
        $self->{'template'} .= '.cs' if $template !~ /\.cs$/o;
    },
);

has 'wrapper' => (
    is  => 'rw',
    isa => 'PathFile',
    trigger => sub {
        my ( $self, $template ) = @_;
        $self->{'wrapper'} .= '.cs' if $template !~ /\.cs$/o;
    },
);

has 'data' => (
    is  => 'rw',
    isa => 'HashRef',
    default => sub { +{} },
);

has 'no_wrapper' => (
    is  => 'rw',
    isa => 'Bool',
    default => sub { shift->wrapper ? 0 : 1 },
    lazy => 1,
);

no Moose;

__PACKAGE__->meta->make_immutable;

=head1 METHODS

=head2 render

=cut

sub render {
    my $self = shift;
    my $template = $self->no_wrapper ? $self->template : $self->wrapper;

    if (!length $template) {
        $self->log->debug('No template specified for rendering');
        return;
    }

    $self->log->debug( sprintf $self->no_wrapper
        ? 'Rendering template "%s"'
        : 'Rendering template "%s" with wrapper "%s"',
        $self->template, $self->wrapper
    );

    my ($vars, $out) = +{ content => $self->template, %{ $self->data } };
    eval {
        $self->cs->process( $template, $vars, \$out,
            'encoding'  => 'utf8',
            'load_path' => $self->loadpaths,
        );
    };
    if ( $@ ) {
        Engage::Exception->throw( message => $@ );
    }

    return $out;
}

=head1 AUTHOR

Craftworks, C<< <craftwork at cpan org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-engage-view-clearsilver at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Engage-View-ClearSilver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Engage::View::ClearSilver

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

1; # End of Engage::View::ClearSilver
