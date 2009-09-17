package Engage::View::ClearSilver;

=head1 NAME

Engage::View::ClearSilver - Engage ClearSilver View Class

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Engage::View::ClearSilver;

    my $foo = Engage::View::ClearSilver->new();
    ...

=cut

use Moose;
use Moose::Util::TypeConstraints;
use ClearSilver;
use Data::ClearSilver::HDF;
use File::Temp;
use IPC::Cmd;
with 'Engage::Utils';
with 'Engage::Log';

our $VERSION = '0.001';

subtype 'PathFile'
    => as 'Str'
    => where { length && !m{/$} }
    => message { 'template must be a file' };

has 'cstest' => (
    is  => 'ro',
    isa => 'Str',
    default => sub {
        my $self = shift;
        if ( my $cstest = IPC::Cmd::can_run('cstest') ) {
            return $cstest;
        }
        Engage::Exception->throw(q/cstest is not installed/);
    }
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

    # Check loadpaths
    my ($loadpath) = grep { defined && -f "$_/$template" } @{ $self->loadpaths };
    Engage::Exception->throw(qq/Couldn't find template "$template" in loadpaths /
        . join ':', grep defined, @{ $self->loadpaths }) unless defined $loadpath;

    # Check file
    my $file = "$loadpath/$template";
    Engage::Exception->throw(qq/Couldn't read template $file/) unless -r $file;

    $self->log->debug( sprintf $self->no_wrapper
        ? 'Rendering template "%s"'
        : 'Rendering template "%s" with wrapper "%s"',
        $self->template, $self->wrapper
    );

    my $hdf = Data::ClearSilver::HDF->hdf({
        content => $self->template, %{ $self->data },
    });
    Engage::Exception->throw(qq/Couldn't create HDF Dataset/) unless $hdf;

    my $i = 0;
    for (@{ $self->loadpaths }) {
        $hdf->setValue("hdf.loadpaths.$i", $_);
        ++$i;
    }

    my $cs = ClearSilver::CS->new( $hdf );

    # Parse and get error message
    if (!$cs->parseFile( $template )) {
        $self->log->error(qq/Couldn't render template "$template"/);
        return if !$self->cstest;

        my $buffer = '';
        my $hdf_file = File::Temp->new->filename;
        my @run = (
            command => [ $self->cstest, '-v', $hdf_file, $file ],
            buffer  => \$buffer,
            timeout => 1,
        );

        $hdf->writeFile($hdf_file);
        IPC::Cmd::run( @run );
        Engage::Exception->throw( $buffer );
    }

    return $cs->render;
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
