# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Modules::CustomerPassword;

use strict;
use warnings;

our @ObjectDependencies = (
    'Kernel::System::CustomerUser',
);

use base qw(Kernel::Modules::BasePassword);

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{UserObject} = $Kernel::OM->Get('Kernel::System::CustomerUser');

    return $Self;
}

1;
