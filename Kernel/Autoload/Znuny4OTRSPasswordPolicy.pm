# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2012-2021 Znuny GmbH, http://znuny.com/
# --
# $origin: otrs - 1eead118fb1685d170c3e4f8826c8300e09611ca - Kernel/Output/HTML/Layout.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

use Kernel::Output::HTML::Layout;

package Kernel::Output::HTML::Layout;    ## no critic

use strict;
use warnings;

use Kernel::System::VariableCheck qw(:all);

our @ObjectDependencies = (
);

# disable redefine warnings in this scope
{
    no warnings 'redefine'; ## no critic

    # backup original Redirect()
    my $Redirect = \&Kernel::Output::HTML::Layout::Redirect;

    # redefine Redirect() of Kernel::Output::HTML::Layout::Redirect
    *Kernel::Output::HTML::Layout::Redirect = sub {
        my ( $Self, %Param ) = @_;

        return if $Param{OP} =~ /AgentTimeAccountingEdit/ && $Self->{Action} =~ /^(CustomerPassword|AgentPassword|AdminPackage|AdminSystemConfiguration)/;
        return &{$Redirect}( $Self, %Param );
    }
}

1;
