# --
# Kernel/Modules/AgentPassword.pm - to restrict password policy
# Copyright (C) 2012-2015 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentPassword;

use strict;
use warnings;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    # check needed objects
    for (qw(ParamObject DBObject LayoutObject LogObject ConfigObject TimeObject)) {
        if ( !$Self->{$_} ) {
            $Self->{LayoutObject}->FatalError( Message => "Got no $_!" );
        }
    }

    return $Self;
}

sub PreRun {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{RequestedURL} ) {
        $Self->{RequestedURL} = 'Action=';
    }

    # cancel password action if an AgentInfo should be shown
    # to prevent enless redirect loop
    return if $Self->{Action} && $Self->{Action} eq 'AgentInfo';

    # return if password max time is not configured
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    return if !$Config;
    return if !$Config->{Password};
    return if !$Config->{Password}->{PasswordMaxValidTimeInDays};

    # check auth module
    my $Module      = $Self->{ConfigObject}->Get('AuthModule');
    my $AuthBackend = $Self->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $Self->{ConfigObject}->Get( 'AuthModule' . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    # redirect if password change time is in scope
    my $PasswordMaxValidTimeInDays = $Config->{Password}->{PasswordMaxValidTimeInDays} * 60 * 60 * 24;
    my $PasswordMaxValidTill       = $Self->{TimeObject}->SystemTime() - $PasswordMaxValidTimeInDays;

    # ignore pre application module if it is calling self
    return if $Self->{Action} =~ /^(AgentPassword|AdminPackage|AdminSysConfig)/;

    # if last change time is over x days
    if ( !$Self->{UserLastPwChangeTime} || $Self->{UserLastPwChangeTime} < $PasswordMaxValidTill ) {

        # remember requested url
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => $Self->{RequestedURL},
        );
        return $Self->{LayoutObject}->Redirect( OP => 'Action=AgentPassword' );
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{RequestedURL} ) {
        $Self->{RequestedURL} = 'Action=';
    }

    # check config
    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');
    $Self->{LayoutObject}->FatalError( Message => 'No Config Params available' ) if !$Config;
    $Self->{LayoutObject}->FatalError( Message => 'No Config Params available' )
        if !$Config->{Password};

    # check auth module
    my $Module      = $Self->{ConfigObject}->Get('AuthModule');
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $Self->{ConfigObject}->Get( 'AuthModule' . $AuthBackend );
    }

    # return on no pw reset backends
    if ( $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i ) {
        return $Self->_Screen(
            Error => "No Password reset backend is used ($Module)! Can't set Password!"
        );
    }

    # change password
    if ( $Self->{Subaction} eq 'Change' ) {

        # load backend
        if ( !$Self->{MainObject}->Require('Kernel::Output::HTML::PreferencesPassword') ) {
            $Self->{LayoutObject}->FatalError();
        }

        # generate obejct
        my $Object = Kernel::Output::HTML::PreferencesPassword->new(
            %{$Self},
            ConfigItem => $Config->{Password},
            UserID     => $Self->{UserID},
        );

        # run password change
        my $Success = $Object->Run(
            GetParam => {
                NewPw  => [ $Self->{ParamObject}->GetParam( Param => 'NewPw' ) ],
                NewPw1 => [ $Self->{ParamObject}->GetParam( Param => 'NewPw1' ) ],
            },
            UserData => $Self,
        );

        # show screen with error again
        if ( !$Success ) {
            my $Error = $Object->Error() || $Object->Message();
            return $Self->_Screen( Error => $Error );
        }

        # remove requested url
        $Self->{SessionObject}->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect to original requested url
        return $Self->{LayoutObject}->Redirect( OP => "$Self->{UserRequestedURL}" );
    }

    # show change screen
    return $Self->_Screen();
}

sub _Screen {
    my ( $Self, %Param ) = @_;

    my $Config = $Self->{ConfigObject}->Get('PreferencesGroups');

    # show info
    my $Output = $Self->{LayoutObject}->Header();
    $Output .= $Self->{LayoutObject}->NavigationBar();

    # show policy
    my @Policy
        = qw(PasswordHistory PasswordMinSize PasswordMin2Lower2UpperCharacters PasswordMin2Characters PasswordNeedDigit PasswordMaxValidTimeInDays);
    POLICY:
    for my $Block (@Policy) {
        next POLICY if !$Config->{Password}->{$Block};
        $Self->{LayoutObject}->Block(
            Name => $Block,
            Data => { %Param, %{ $Config->{Password} } },
        );
    }

    # show sysconfig settings link if admin
    if ( $Self->{'UserIsGroup[admin]'} ) {
        $Self->{LayoutObject}->Block(
            Name => 'AdminConfig',
            Data => { %Param, %{ $Config->{Password} } },
        );
    }

    $Output .= $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentPassword',
        Data         => { %Param, %{ $Config->{Password} } },
    );

    $Output .= $Self->{LayoutObject}->Footer();
    return $Output;
}

1;
