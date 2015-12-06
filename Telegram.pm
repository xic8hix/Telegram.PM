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
sub message_make {
    my $self = shift();
    my $add = shift();
    my $param = shift();
    my $rebase = shift();
    my @base = ("chat_id", "reply_to_message_id", "replay_markup");
    if ( defined $rebase ) {
        @base = @$rebase;
    }
    my %shorter = (
        to              => "chat_id",
        replay_to       => "reply_to_message_id",
        disable_preview => "disable_web_page_preview"
    );
    for (keys %shorter) {
        if ( defined $param->{$_} ) {
            $param->{$shorter{$_}} = $param->{$_};
            delete($param->{$_});
        }
    }
    my @list = (@base, @$add);
    my %message;
    for (@list) {
        if ( defined $param->{$_}) {
            if ( ref($param->{$_}) eq 'HASH' ) {
                $message{$_} = [$param->{$_}->{file}];
            } else {
                $message{$_} = $param->{$_};
            }
        }
    }
    return \%message;
}


#@method
sub message_send {
    my $self = shift();
    my $param = shift();
    my $list = ['text', 'parse_mode', 'disable_web_page_preview'];
    my $message = $self->message_make(
        $list,
        $param
    );
    return 1;
    my $response = $self->command_send('sendMessage', $message);
    return $response;
}

#@method
sub message_forward {
    my $self = shift();
    my $to = shift();
    my $from = shift();
    my $item = shift();
    my $message = {
        chat_id         => $to,
        from_chat_id    => $from,
        message_id      => $item
    };
    my $response = $self->command_send('forwardMessage', $message);
    return $response;
}

#@method
sub photo_send {
    my $self = shift();
    my $param = shift();
    my $list = ['photo', 'caption'];
    my $message = $self->message_make(
        $list,
        $param
    );
    my $response = $self->command_send('sendPhoto', $message);
    return $response;
}

#@method
sub audio_send {
    my $self = shift();
    my $param = shift();
    my $list = ['audio', 'duration', 'performer', 'title'];
    my $message = $self->message_make(
        $list,
        $param
    );
    my $response = $self->command_send('sendAudio', $message);
    return $response;
}

#@method
sub document_send {
    my $self = shift();
    my $param = shift();
    my $list = ['document'];
    my $message = $self->message_make(
        $list,
        $param
    );
    return 1;
    my $response = $self->command_send('sendDocument', $message);
    return $response;
}

#@method
sub sticker_send {
    my $self = shift();
    my $param = shift();
    my $list = ['sticker'];
    my $message = $self->message_make(
        $list,
        $param
    );
    my $response = $self->command_send('sendSticker', $message);
    return $response;
}

#@method
sub video_send {
    my $self = shift();
    my $param = shift();
    my $list = ['video', 'duration', 'caption'];
    my $message = $self->message_make(
        $list,
        $param
    );
    my $response = $self->command_send('sendVideo', $message);
    return $response;
}

#@method
sub voice_send {
    my $self = shift();
    my $param = shift();
    my $list = ['voice', 'duration'];
    my $message = $self->message_make(
        $list,
        $param
    );
    my $response = $self->command_send('sendVoice', $message);
    return $response;
}

#@method
sub location_send {
    my $self = shift();
    my $param = shift();
    my $list = ['latitude', 'longitude'];
    my $message = $self->message_make(
        $list,
        $param
    );
    my $response = $self->command_send('sendLocation', $message);
    return $response;
}

#@method
sub chat_action_send {
    my $self = shift();
    my $param = shift();
    my $base = ['chat_id'];
    my $list = ['action'];
    my $message = $self->message_make(
        $list,
        $param,
        $base
    );
    my $response = $self->command_send('sendChatAction', $message);
    return $response;
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
    return $resonse;
}

1;