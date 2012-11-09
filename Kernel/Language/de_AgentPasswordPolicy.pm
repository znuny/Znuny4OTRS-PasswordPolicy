# --
# Kernel/Language/de_AgentPasswordPolicy.pm - translation file
# Copyright (C) 2012 Znuny GmbH, http://znuny.com/
# --
# $Id: $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_AgentPasswordPolicy;

use strict;
use warnings;


sub Data {
    my $Self = shift;

    $Self->{Translation}->{'Password Policy'} = 'Passwort-Richtlinien';
    $Self->{Translation}->{'Your current password is older then %s days. You need to set a new one.'} = 'Ihr aktuelles Passwort ist älter als %s Tage. Sie müssen ein neues setzen.';
    $Self->{Translation}->{'Password need to be renewed every %s days.'} = 'Passwort muss alle %s Tage erneuert werden.';
    $Self->{Translation}->{'Password history is active, you can\'t use a password which was used the last %s times.'} = 'Passwort-Historie ist aktiv, Sie können die letzten %s Passwörter nicht benutzen.';
    $Self->{Translation}->{'Password size is min. %s character.'} = 'Passwort benötigt eine minimale Länge von %s Zeichen.';
    $Self->{Translation}->{'Password required min. 2 lower and 2 upper character.'} = 'Passwort benötigt min. 2 Klein- und 2 Großbuchstaben.';
    $Self->{Translation}->{'Password required min. 2 character.'} = 'Passwort benötigt min. 2 Buchstaben (keine Zahlen).';
    $Self->{Translation}->{'Password required min. 1 digit.'} = 'Passwort benötigt min. 1 Zahl.';
    $Self->{Translation}->{'Change Config Options'} = 'Ändern der Konfigurations-Einstellungen';
    $Self->{Translation}->{'Admin Permissions are required!'} = 'Admin-Berechtigung nötig!';
}

1;
