package Telegram;
use strict;
use warnings FATAL => 'all';
use vars qw($VERSION);
use LWP::UserAgent;
use JSON;

$VERSION = 0.01;

#@returns Telegram
sub new {
    my $class = shift();
    my $token = shift();
    my $callback = shift();
    my $certificate_file = shift();
    my $self = {
        _version => $VERSION,
        token => $token,
        callback => $callback,
        api_url_base => 'https://api.telegram.org/bot',
        api_url => '',
        certificate => '',
        certificate_file => $certificate_file,
        user_agent => 'ICHI/Telegram.pm '.$VERSION.'/ru',
    };
    bless($self,$class);
    $self->_init();
    return $self;
}

#@method
sub _init {
    my $self = shift();
    $self->certificate_get();
}

#@method
sub certificate_get {
    my $self = shift();
    my $file = $self->{certificate_file};
    my $certificate;
    my $row;
    open(my $fh, '<:encoding(UTF-8)', $file);
    while (<$fh>) {
        $row = $_;
        chomp($row);
        if ( !defined $certificate && $row ne '-----BEGIN CERTIFICATE-----') { last(); }
        $certificate .= $row;
    }
    close($fh);
    if ($row ne '-----END CERTIFICATE-----') { $certificate = ''; }
    if ( length($certificate) > 100 ) {
        $self->{certificate} = $certificate;
    }
}

#@method
sub api_make {
    my $self = shift();
    $self->{api_url} = $self->{api_url_base}.$self->{token}.'/';
}

#@method
sub api_get {
    my $self = shift();
    if ($self->{api_url} eq '') { $self->api_make(); }
    return $self->{api_url};
}

#@method
sub command_send {
    my $self = shift();
    my $command = shift();
    my $content = shift();
    my $json;
    my $converter = JSON->new->utf8->allow_nonref;
    my $lwp = LWP::UserAgent->new();
    $lwp->agent($self->{user_agent});
    my $result = $lwp->post($self->api_get().$command, $content);
    if ($result->is_success) {
        $json = $result->content();
    }
    return $converter->decode($json);
}

#@method
sub message_send {
    my $self = shift();
    my $to = shift();
    my $text = shift();
    my $message = {
        chat_id => $to,
        text    => $text
    };
    my $response = $self->command_send('sendMessage', $message);
}

#@method
sub webhook_set {
    my $self = shift();
    my $request;
    my $certificate = $self->certificate_get();
    if ($certificate ne '') {
        $request = {
            url         => $self->{callback},
            certificate => $certificate,
        };
    } else {
        $request = {
            url         => $self->{callback},
        };
    }
    my $resonse = $self->command_send('setWebhook', $request);
}

1;