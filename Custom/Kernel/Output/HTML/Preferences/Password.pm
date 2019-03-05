# --
# Copyright (C) 2001-2019 OTRS AG, https://otrs.com/
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
# --
# $origin: otrs - a4d17072f6bcf137aee494fde90613af7ec40c01 - Kernel/Output/HTML/Preferences/Password.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --
## nofilter(TidyAll::Plugin::OTRS::Perl::ObjectDependencies)

package Kernel::Output::HTML::Preferences::Password;

use strict;
use warnings;

use Kernel::Language qw(Translatable);

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::Auth',
    'Kernel::System::CustomerAuth',
# ---
# Znuny4OTRS-PasswordPolicy
# ---
#
    'Kernel::System::AuthSession',
    'Kernel::System::Main',
    'Kernel::System::Time',
# ---
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    for my $Needed (qw(UserID UserObject ConfigItem)) {
        die "Got no $Needed!" if !$Self->{$Needed};
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

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # get auth module
    my $Module      = $ConfigObject->Get($AuthModule);
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $ConfigObject->Get( $AuthModule . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    my @Params;
    push(
        @Params,
        {
            %Param,
            Key   => Translatable('Current password'),
            Name  => 'CurPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => Translatable('New password'),
            Name  => 'NewPw',
            Raw   => 1,
            Block => 'Password'
        },
        {
            %Param,
            Key   => Translatable('Verify password'),
            Name  => 'NewPw1',
            Raw   => 1,
            Block => 'Password'
        },
    );

    # set the TwoFactorModue setting name depending on the interface
    my $AuthTwoFactorModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'AuthTwoFactorModule'
        : 'Customer::AuthTwoFactorModule';

    # show 2 factor password input if we have at least one backend enabled
    COUNT:
    for my $Count ( '', 1 .. 10 ) {
        next COUNT if !$ConfigObject->Get( $AuthTwoFactorModule . $Count );

        push @Params, {
            %Param,
            Key   => '2 Factor Token',
            Name  => 'TwoFactorToken',
            Raw   => 1,
            Block => 'Password',
        };

        last COUNT;
    }

    return @Params;
}

sub Run {
    my ( $Self, %Param ) = @_;

    # get config object
    my $ConfigObject = $Kernel::OM->Get('Kernel::Config');

    # pref update db
    return 1 if $ConfigObject->Get('DemoSystem');

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

    # get the two factor token from form
    my $TwoFactorToken;
    if ( $Param{GetParam}->{TwoFactorToken} && $Param{GetParam}->{TwoFactorToken}->[0] ) {
        $TwoFactorToken = $Param{GetParam}->{TwoFactorToken}->[0];
    }

    # define AuthModule for frontend
    my $AuthModule = $Self->{ConfigItem}->{Area} eq 'Agent'
        ? 'Auth'
        : 'CustomerAuth';

    my $AuthObject = $Kernel::OM->Get( 'Kernel::System::' . $AuthModule );
    return 1 if !$AuthObject;

    # get layout object
    my $LayoutObject = $Kernel::OM->Get('Kernel::Output::HTML::Layout');

    # validate current password
    if (
        !$AuthObject->Auth(
            User           => $Param{UserData}->{UserLogin},
            Pw             => $CurPw,
            TwoFactorToken => $TwoFactorToken || '',
        )
        )
    {
        $Self->{Error} = Translatable('The current password is not correct. Please try again!');
        return;
    }

    # check if pw is true
    if ( !$Pw || !$Pw1 ) {
        $Self->{Error} = Translatable('Please supply your new password!');
        return;
    }

    # compare pws
    if ( $Pw ne $Pw1 ) {
        $Self->{Error} = Translatable('Can\'t update password, your new passwords do not match. Please try again!');
        return;
    }

    # check pw
    my $Config = $Self->{ConfigItem};

    # check if password is not matching PasswordRegExp
    if ( $Config->{PasswordRegExp} && $Pw !~ /$Config->{PasswordRegExp}/ ) {
        $Self->{Error} = Translatable('Can\'t update password, it contains invalid characters!');
        return;
    }

    # check min size of password
    if ( $Config->{PasswordMinSize} && length $Pw < $Config->{PasswordMinSize} ) {
# ---
# Znuny4OTRS-PasswordPolicy
# ---
#       $Self->{Error} = Translatable(
#             'Can\'t update password, it must be at least %s characters long!',
#             $Config->{PasswordMinSize}
#         );
        $Self->{Error} = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->{LanguageObject}->Translate(
            'Can\'t update password, it must be at least %s characters long!',
            $Config->{PasswordMinSize}
        );

# ---
        return;
    }

    # check min 2 lower and 2 upper char
    if (
        $Config->{PasswordMin2Lower2UpperCharacters}
        && ( $Pw !~ /[A-Z].*[A-Z]/ || $Pw !~ /[a-z].*[a-z]/ )
        )
    {
        $Self->{Error}
            = Translatable('Can\'t update password, it must contain at least 2 lowercase and 2 uppercase characters!');
        return;
    }

    # check min 1 digit password
    if ( $Config->{PasswordNeedDigit} && $Pw !~ /\d/ ) {
        $Self->{Error} = Translatable('Can\'t update password, it must contain at least 1 digit!');
        return;
    }

    # check min 2 char password
    if ( $Config->{PasswordMin2Characters} && $Pw !~ /[A-z][A-z]/ ) {
        $Self->{Error} = Translatable('Can\'t update password, it must contain at least 2 characters!');
        return;
    }

# ---
# Znuny4OTRS-PasswordPolicy
# ---
    # md5 sum for new pw, needed for password history
    my $MD5Pw = $Kernel::OM->Get('Kernel::System::Main')->MD5sum(
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
        Value  => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
    );
    $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
        SessionID => $Self->{SessionID},
        Key    => 'UserLastPwChangeTime',
        Value  => $Kernel::OM->Get('Kernel::System::Time')->SystemTime(),
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

    $Self->{Message} = Translatable('Preferences updated successfully!');
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
