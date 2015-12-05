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
    my $certificate = shift();
    my $self = {
        _version => $VERSION,
        token => $token,
        callback => $callback,
        api_url_base => 'https://api.telegram.org/bot',
        api_url => '',
        certificate => $certificate,
        user_agent => 'ICHI/Telegram.pm '.$VERSION.'/ru',
    };
    bless($self,$class);
    $self->_init();
    return $self;
}

#@method
sub _init {
    my $self = shift();
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
    if ($self->{certificate} ne '') {
        $request = {
            url         => $self->{callback},
            certificate => [$self->{certificate}],
        };
    } else {
        $request = {
            url         => $self->{callback},
        };
    }
    my $resonse = $self->command_send('setWebhook', $request);
}

1;