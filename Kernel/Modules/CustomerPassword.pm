# --
# Copyright (C) 2012 Znuny GmbH, https://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerPassword;

use strict;
use warnings;
use utf8;

our @ObjectDependencies = (
    'Kernel::System::CustomerUser',
);

use parent qw(Kernel::Modules::BasePassword);

sub new {
    my ( $Type, %Param ) = @_;

    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{UserObject} = $Kernel::OM->Get('Kernel::System::CustomerUser');

    return $Self;
}

1;
