package Telegram;
use strict;
use warnings FATAL => 'all';
use vars qw($VERSION);
use LWP::UserAgent;
use JSON;
use Data::Dumper;

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
        content_type => 'multipart/form-data',
        me => {},
    };
    bless($self,$class);
    $self->_init();
    return $self;
}

#@method
sub _init {
    my $self = shift();
    $self->me_get();
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
    my $output;
    my $converter = JSON->new->utf8->allow_nonref;
    my $lwp = LWP::UserAgent->new();
    $lwp->default_header("User-Agent" => $self->{user_agent} );
    $lwp->default_header("Content-Type" => $self->{content_type} );
    my $result = $lwp->post($self->api_get().$command, Content => $content);
    if ( $result->is_success ) {
        if ( $result->header('Content-Type') eq 'application/json' ) {
            $output = $converter->decode($result->content());
        } else {
            $output = $result->decoded_content();
        }
    }
    return $output;
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
sub me_get {
    my $self = shift();
    if  ( !defined $self->{me}->{id} ) {
        my $response = $self->command_send('getMe');
        if ( defined $response->{result} ) {
            $self->{me} = $response->{result};
        }
    }
    return $self->{me};
}

#@method
sub webhook_set {
    my $self = shift();
    my $request;
    if ( $self->{certificate} ne '' ) {
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