package Engage::WUI::View::ClearSilver;

=head1 NAME

Engage::WUI::View::ClearSilver - The great new Engage::WUI::View::ClearSilver!

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Engage::WUI::View::ClearSilver;

    my $foo = Engage::WUI::View::ClearSilver->new();
    ...

=cut

use Moose;
extends qw/Catalyst::View Engage::View::ClearSilver/;

our $VERSION = '0.01';

no Moose;

__PACKAGE__->meta->make_immutable;

=head1 METHODS

=head2 process

=cut

sub process {
    my ( $self, $c ) = @_;

    $self->no_wrapper(1) if $c->stash->{'no_wrapper'};
    $self->set_data( $c );
    $self->set_loadpaths( $c );
    $self->set_template( $c );
    my $body = $self->render;
    Catalyst::Exception->throw( message => qq/Coudn't render template/ )
        unless defined $body;
    $c->response->body( $body );
    return 1;
}

=head2 set_loadpaths

=cut

sub set_loadpaths {
    my ( $self, $c ) = @_;
    $self->loadpaths([ $c->path_to('template') ]);
}

=head2 set_template

=cut

sub set_template {
    my ( $self, $c ) = @_;
    $self->template( $c->stash->{'template'} );
}

=head2 set_data

=cut

sub set_data {
    my ( $self, $c ) = @_;

    my $stash = $c->stash;

    $stash->{'status'} = $c->res->status;

    my $req = $c->req;
    my $uri = $req->uri;
    my $headers = $req->headers;
    $stash->{'ENV'} = {
        %ENV,
        'HTTP_HOST'            => $uri->host_port,
        'HTTP_REFERER'         => $req->referer || undef,
        'HTTP_ACCEPT'          => $headers->header('Accept') || undef,
        'HTTP_ACCEPT_LANGUAGE' => $headers->header('Accept-Language') || undef,
        'HTTP_ACCEPT_ENCODING' => $headers->header('Accept-Encoding') || undef,
        'HTTP_USER_AGENT'      => $req->user_agent . '' || undef,
        'SERVER_PROTOCOL'      => $req->protocol,
        'PATH_INFO'            => $req->path_info,
        'QUERY_STRING'         => $uri->query,
        'REQUEST_METHOD'       => uc $req->method,
        'REQUEST_URI'          => substr($uri, length($req->base) - 1),
        'REQUEST_BASE'         => substr($req->base, 0, - 1),
        'REMOTE_ADDR'          => $req->address,
    };
    $stash->{'param'} = $req->params;

    my $action = $c->action;
    $stash->{'action'} = {
        'namespace' => $action->namespace,
        'reverse'   => $action->reverse,
        'reverse_'  => $action->reverse,
        'name'      => $action->name,
    };
    $stash->{'action'}{'reverse_'} =~ s{/}{_}go;

    my $offset = defined $stash->{'TZ_OFFSET'} ? $stash->{'TZ_OFFSET'} : 0;
    @{$stash->{'time'}}{qw/
        year month day hour min sec day_abbr day_name
        date iso8601 time epoch rfc822 offset tz
    /} = split /[;]/, POSIX::strftime(
        "%Y;%m;%d;%H;%M;%S;%a;%A;%Y/%m/%d;%F;%T;%s;%a, %d %b %Y %H:%M:%S %z;%z;%Z",
    gmtime( time + $offset ));

    if ( $c->can('user_exists') && $c->user_exists ) {
        $stash->{'user_exists'} = 1;
        $stash->{'user'} = $c->user->get_object;
        $stash->{'user'}{'id'} = $c->user->id;
    }

    $self->data( $stash );
}

=head1 AUTHOR

Craftworks, C<< <craftwork at cpan org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-engage-view-clearsilver at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Engage-View-ClearSilver>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Engage::WUI::View::ClearSilver

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

1; # End of Engage::WUI::View::ClearSilver
