# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::AgentPassword;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::Config',
    'Kernel::Output::HTML::Layout',
    'Kernel::System::AuthSession',
    'Kernel::System::Main',
    'Kernel::System::Time',
    'Kernel::System::User',
    'Kernel::System::Web::Request',
);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{UserObject} = $Kernel::OM->Get('Kernel::System::User');

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
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');
    return if !$Config;
    return if !$Config->{Password};
    return if !$Config->{Password}->{PasswordMaxValidTimeInDays};

    # check auth module
    my $Module      = $Kernel::OM->Get('Kernel::Config')->Get('AuthModule');
    my $AuthBackend = $Self->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $Kernel::OM->Get('Kernel::Config')->Get( 'AuthModule' . $AuthBackend );
    }

    # return on no pw reset backends
    return if $Module =~ /(LDAP|HTTPBasicAuth|Radius)/i;

    # redirect if password change time is in scope
    my $PasswordMaxValidTimeInDays = $Config->{Password}->{PasswordMaxValidTimeInDays} * 60 * 60 * 24;
    my $PasswordMaxValidTill = $Kernel::OM->Get('Kernel::System::Time')->SystemTime() - $PasswordMaxValidTimeInDays;

    # ignore pre application module if it is calling self
    return if $Self->{Action} =~ /^(AgentPassword|AdminPackage|AdminSysConfig)/;

    # if last change time is over x days
    if ( !$Self->{UserLastPwChangeTime} || $Self->{UserLastPwChangeTime} < $PasswordMaxValidTill ) {

        # remember requested url
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => $Self->{RequestedURL},
        );
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect( OP => 'Action=AgentPassword' );
    }
    return;
}

sub Run {
    my ( $Self, %Param ) = @_;

    if ( !$Self->{RequestedURL} ) {
        $Self->{RequestedURL} = 'Action=';
    }

    # check config
    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');
    $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError( Message => 'No Config Params available' ) if !$Config;
    $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError( Message => 'No Config Params available' )
        if !$Config->{Password};

    # check auth module
    my $Module      = $Kernel::OM->Get('Kernel::Config')->Get('AuthModule');
    my $AuthBackend = $Param{UserData}->{UserAuthBackend};
    if ($AuthBackend) {
        $Module = $Kernel::OM->Get('Kernel::Config')->Get( 'AuthModule' . $AuthBackend );
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
        if ( !$Kernel::OM->Get('Kernel::System::Main')->Require('Kernel::Output::HTML::Preferences::Password') ) {
            $Kernel::OM->Get('Kernel::Output::HTML::Layout')->FatalError();
        }

        # generate object
        my $Object = Kernel::Output::HTML::Preferences::Password->new(
            %{$Self},
            ConfigItem => $Config->{Password},
            UserID     => $Self->{UserID},
        );

        # run password change
        my $Success = $Object->Run(
            GetParam => {
                CurPw  => [ $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'CurPw' ) ],
                NewPw  => [ $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'NewPw' ) ],
                NewPw1 => [ $Kernel::OM->Get('Kernel::System::Web::Request')->GetParam( Param => 'NewPw1' ) ],
            },
            UserData => $Self,
        );

        # show screen with error again
        if ( !$Success ) {
            my $Error = $Object->Error() || $Object->Message();
            return $Self->_Screen( Error => $Error );
        }

        # remove requested url
        $Kernel::OM->Get('Kernel::System::AuthSession')->UpdateSessionID(
            SessionID => $Self->{SessionID},
            Key       => 'UserRequestedURL',
            Value     => '',
        );

        # redirect to original requested url
        return $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Redirect( OP => "$Self->{UserRequestedURL}" );
    }

    # show change screen
    return $Self->_Screen();
}

sub _Screen {
    my ( $Self, %Param ) = @_;

    my $Config = $Kernel::OM->Get('Kernel::Config')->Get('PreferencesGroups');

    # show info
    my $Output = $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Header();
    $Output .= $Kernel::OM->Get('Kernel::Output::HTML::Layout')->NavigationBar();

    # show policy
    my @Policy
        = qw(PasswordHistory PasswordMinSize PasswordMin2Lower2UpperCharacters PasswordMin2Characters PasswordNeedDigit PasswordMaxValidTimeInDays);
    POLICY:
    for my $Block (@Policy) {
        next POLICY if !$Config->{Password}->{$Block};
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => $Block,
            Data => { %Param, %{ $Config->{Password} } },
        );
    }

    # show sysconfig settings link if admin
    if ( $Self->{'UserIsGroup[admin]'} ) {
        $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Block(
            Name => 'AdminConfig',
            Data => { %Param, %{ $Config->{Password} } },
        );
    }

    $Output .= $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Output(
        TemplateFile => 'AgentPassword',
        Data         => { %Param, %{ $Config->{Password} } },
    );

    $Output .= $Kernel::OM->Get('Kernel::Output::HTML::Layout')->Footer();
    return $Output;
}

1;
