# --
# Copyright (C) 2001-2017 OTRS AG, http://otrs.com/
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# $origin: https://github.com/OTRS/otrs/blob/084ba344639f1a3d1aebd41cf81ae35c681e36c2/Kernel/Output/HTML/PreferencesPassword.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::PreferencesPassword;

use strict;
use warnings;

use Kernel::System::Auth;
use Kernel::System::CustomerAuth;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # get needed objects
# ---
# Znuny4OTRS-PasswordPolicy
# ---
#    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem MainObject))
    for (qw(ConfigObject LogObject DBObject LayoutObject UserID ParamObject ConfigItem MainObject TimeObject))
# ---
    {
        die "Got no $_!" if !$Self->{$_};
    }

    return $Self;
}

sub Param {
    my ( $Self, %Param ) = @_;

    # check if we need to show password change option

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'AuthModule'
        : 'Customer::AuthModule';

    # get auth module
    my $Module      = $Self->{ConfigObject}->Get($AuthModule);
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $Self->{ConfigObject}->Get( $AuthModule . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    my @Params;
    push(
        @Params,
        {
            %Param,
            Key   => 'Current password',
            Name  => 'CurPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => 'New password',
            Name  => 'NewPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => 'Verify password',
            Name  => 'NewPw1',
            Raw   => 1,
            Block => 'Password'
        },
    );
    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # pref update db
    return 1 if $Self->{ConfigObject}->Get('DemoSystem');

    # get password from form
    my $CurPw;
    if ( $Param{GetParam}->{CurPw} && $Param{GetParam}->{CurPw}->[0] ) {
        $CurPw = $Param{GetParam}->{CurPw}->[0];
    }
    my $Pw;
    if ( $Param{GetParam}->{NewPw} && $Param{GetParam}->{NewPw}->[0] ) {
        $Pw = $Param{GetParam}->{NewPw}->[0];
    }
    my $Pw1;
    if ( $Param{GetParam}->{NewPw1} && $Param{GetParam}->{NewPw1}->[0] ) {
        $Pw1 = $Param{GetParam}->{NewPw1}->[0];
    }

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'Kernel::System::Auth'
        : 'Kernel::System::CustomerAuth';

    # create authentication object
    my $AuthObject = $AuthModule->new(
        ConfigObject => $Self->{ConfigObject},
        EncodeObject => $Self->{EncodeObject},
        LogObject    => $Self->{LogObject},
        UserObject   => $Self->{UserObject},
        GroupObject  => $Self->{GroupObject},
        DBObject     => $Self->{DBObject},
        MainObject   => $Self->{MainObject},
        TimeObject   => $Self->{TimeObject},
    );
    return 1 if !$AuthObject;

    # validate current password
    if (
        !$AuthObject->Auth(
            User => $Param{UserData}->{UserLogin},
            Pw   => $CurPw
        )
        )
    {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}
            ->Translate('The current password is not correct. Please try again!');
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}->Translate('Please supply your new password!');
        return;
    }

    # compare pws
    if ( $Pw ne $Pw1 ) {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}
            ->Translate('Can\'t update password, your new passwords do not match. Please try again!');
        return;
    }

    # check pw
    my $Config = $Self->{ConfigItem};

    # check if password is not matching PasswordRegExp
    if ( $Config->{PasswordRegExp} && $Pw !~ /$Config->{PasswordRegExp}/ ) {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}
            ->Translate('Can\'t update password, it contains invalid characters!');
        return;
    }

    # check min size of password
    if ( $Config->{PasswordMinSize} && length $Pw < $Config->{PasswordMinSize} ) {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}->Translate(
            'Can\'t update password, it must be at least %s characters long!',
            $Config->{PasswordMinSize}
        );
        return;
    }

    # check min 2 lower and 2 upper char
    if (
        $Config->{PasswordMin2Lower2UpperCharacters}
        && ( $Pw !~ /[A-Z].*[A-Z]/ || $Pw !~ /[a-z].*[a-z]/ )
        )
    {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}
            ->Translate('Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!');
        return;
    }

    # check min 1 digit password
    if ( $Config->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}
            ->Translate('Can\'t update password, it must contain at least 1 digit!');
        return;
    }

    # check min 2 char password
    if ( $Config->{PasswordMin2Characters} && $Pw !~ /[A-z][A-z]/ ) {
        $Self->{Error} = $Self->{LayoutObject}->{LanguageObject}
            ->Translate('Can\'t update password, it must contain at least 2 characters!');
        return;
    }

# ---
# Znuny4OTRS-PasswordPolicy
# ---
    # md5 sum for new pw, needed for password history
    my $MD5Pw = $Self->{MainObject}->MD5sum(
        String => $Pw,
    );
    my %HistoryHash;
    my $HistoryCount = $Self->{ConfigItem}->{PasswordHistory};
    if ($HistoryCount) {

        HISTORY:
        for my $Count ( '', 1 .. $HistoryCount ) {

            my $HistoryKey = 'UserLastPw' . $Count;

            next HISTORY if !$Param{UserData}->{$HistoryKey};

            # remember history
            $HistoryHash{$HistoryKey} = $Param{UserData}->{$HistoryKey};

            # if already used, complain about
            if ( $MD5Pw eq $Param{UserData}->{$HistoryKey} ) {
                $Self->{Error}
                    = "Can\'t update password, this password has already been used. Please choose a new one!";
                return;
            }
        }
    }
# ---

    # set new password
    my $Success = $Self->{UserObject}->SetPassword(
        UserLogin => $Param{UserData}->{UserLogin},
        PW        => $Pw,
    );
    return if !$Success;

# ---
# Znuny4OTRS-PasswordPolicy
# ---
    # set password change time
    $Self->{UserObject}->SetPreferences(
        UserID => $Param{UserData}->{UserID},
        Key    => 'UserLastPwChangeTime',
        Value  => $Self->{TimeObject}->SystemTime(),
    );
    $Self->{SessionObject}->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key    => 'UserLastPwChangeTime',
        Value  => $Self->{TimeObject}->SystemTime(),
    );

    # set password history
    $Self->{UserObject}->SetPreferences(
        UserID => $Param{UserData}->{UserID},
        Key    => 'UserLastPw',
        Value  => $MD5Pw,
    );
    my $Count = 0;
    HISTORY:
    for my $CountReal ( '', 1 .. $HistoryCount ) {

        my $KeyReal = 'UserLastPw' . $CountReal;

        next HISTORY if !$HistoryHash{$KeyReal};

        $Count++;
        my $KeyCount = 'UserLastPw' . $Count;

        $Self->{UserObject}->SetPreferences(
            UserID => $Param{UserData}->{UserID},
            Key    => $KeyCount,
            Value  => $HistoryHash{$KeyReal},
        );
    }
# ---

    $Self->{Message} = 'Preferences updated successfully!';
    return 1;
}

sub Error {
    my ( $Self, %Param ) = @_;

    return $Self->{Error} || '';
}

sub Message {
    my ( $Self, %Param ) = @_;

    return $Self->{Message} || '';
}

1;
