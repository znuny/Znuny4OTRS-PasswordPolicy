# --
# Copyright (C) 2001-2021 OTRS AG, https://otrs.com/
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# $origin: znuny - 4999e43ef5ad8b6f434be8c67f66bc0ea5e41307 - Kernel/Output/HTML/Layout.pm
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

## nofilter(TidyAll::Plugin::Znuny::Perl::LayoutObject)

use Kernel::Output::HTML::Layout;

package Kernel::Output::HTML::Layout;    ## no critic

use strict;
use warnings;
use utf8;

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


        return if $Param{OP} =~ /AgentTimeAccountingEdit/ && $Self->{Action} =~ /^(AJAX|CustomerPassword|AgentPassword|AdminPackage|AdminSystemConfiguration|AgentPreferences)/;

        return &{$Redirect}( $Self, %Param );
    }
}

1;
