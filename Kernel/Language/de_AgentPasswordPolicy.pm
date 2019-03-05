# --
# Copyright (C) 2012-2019 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::de_AgentPasswordPolicy;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'This module is used to extend password policy.'} = 'Mit Hilfe dieses Moduls kann die Passwort-Policy verbessert werden.';

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
    $Self->{Translation}->{'New password again'} = 'Neues Passwort wiederholen';
    $Self->{Translation}->{'Defines the config parameters of this item, to be shown in the preferences view.'} = 'Diese Konfiguration definiert die Konfigurationsparameter, die in der Einstellungsansicht angezeigt werden sollen.';
    $Self->{Translation}->{"Can't update password, your new passwords do not match! Please try again!"} = "Passwort konnte nicht aktualisiert werden, die eingegebenen Passwörter stimmen nicht überein!";
    $Self->{Translation}->{"Please supply your new password!"} = "Bitte neues Passwort eingeben!";
    $Self->{Translation}->{"Can't update password, invalid characters!"} = "Passwort konnte nicht aktualisiert werden, es enthält ungültige Zeichen!";
    $Self->{Translation}->{"Can't update password, must be at least %s characters!"} = "Passwort konnte nicht aktualisiert werden, eine minimale Länge von %s Zeichen wird benötigt!";
    $Self->{Translation}->{"Can't update password, must contain 2 lower and 2 upper characters!"} = "Passwort konnte nicht aktualisiert werden, min. 2 Klein- und 2 Großbuchstaben werden benötigt!";
    $Self->{Translation}->{"Can't update password, needs at least 1 digit!"} = "Passwort konnte nicht aktualisiert werden, min. eine Zahl wird benötigt!";
    $Self->{Translation}->{"Can't update password, needs at least 2 characters!"} = "Passwort konnte nicht aktualisiert werden, min. 2 Buchstaben (keine Zahlen) benötigt!";
    $Self->{Translation}->{"Can't update password, this password has already been used. Please choose a new one!"} = "Passwort konnte nicht aktualisiert werden, da es bereits benutzt wurde. Bitte wählen sie ein anderes.";
    $Self->{Translation}->{"Preferences updated successfully!"} = "Einstellungen erfolgreich aktualisiert!";
}

1;
