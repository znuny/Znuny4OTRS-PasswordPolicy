# --
# Copyright (C) 2012-2021 Znuny GmbH, http://znuny.com/
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
    $Self->{Translation}->{'This module is being used to extend the password policy.'}
        = 'Dieses Modul stellt erweiterte Funktionen für Passwort-Richtlinien bereit.';
    $Self->{Translation}->{'Password Policy'} = 'Passwort-Richtlinien';
    $Self->{Translation}->{'Your current password is older than %s days. You need to set a new one.'} = 'Ihr aktuelles Passwort ist älter als %s Tage. Sie müssen ein neues setzen.';
    $Self->{Translation}->{'Password needs to be renewed every %s days.'} = 'Passwort muss alle %s Tage erneuert werden.';
    $Self->{Translation}->{'Password history is active, you can\'t use a password which was used the last %s times.'} = 'Passwort-Historie ist aktiv, Sie können die letzten %s Passwörter nicht benutzen.';
    $Self->{Translation}->{'Password length must be at least %s characters.'} = 'Passwort benötigt eine minimale Länge von %s Zeichen.';
    $Self->{Translation}->{'Password requires at least two lower- and two uppercase characters.'} = 'Passwort benötigt mindestens je zwei Klein- und Großbuchstaben.';
    $Self->{Translation}->{'Password requires at least two characters.'} = 'Passwort benötigt mindestens zwei Buchstaben (keine Ziffern).';
    $Self->{Translation}->{'Password requires at least one digit.'} = 'Passwort benötigt mindestens eine Ziffer.';
    $Self->{Translation}->{'Change config options'} = 'Ändern der Konfigurationseinstellungen';
    $Self->{Translation}->{'Admin permissions are required!'} = 'Admin-Berechtigungen nötig!';
    $Self->{Translation}->{'Repeat new password'} = 'Neues Passwort wiederholen';
    $Self->{Translation}->{"Can't update password, the new password and the repeated password do not match."} = "Passwort konnte nicht aktualisiert werden, das neue Passwort stimmt nicht mit dem wiederholten Passwort überein.";
    $Self->{Translation}->{"Please supply your new password!"} = "Bitte neues Passwort eingeben!";
    $Self->{Translation}->{"Can't update password, invalid characters!"} = "Passwort konnte nicht aktualisiert werden, es enthält ungültige Zeichen!";
    $Self->{Translation}->{"Can't update password, must be at least %s characters!"} = "Passwort konnte nicht aktualisiert werden, eine minimale Länge von %s Zeichen wird benötigt!";
    $Self->{Translation}->{"Can't update password, must contain at least two lower- and two uppercase characters!"} = "Passwort konnte nicht aktualisiert werden, mindestens je zwei Klein- und Großbuchstaben werden benötigt!";
    $Self->{Translation}->{"Can't update password, needs at least one digit!"} = "Passwort konnte nicht aktualisiert werden, mindestens eine Ziffer wird benötigt!";
    $Self->{Translation}->{"Can't update password, needs at least two characters!"} = "Passwort konnte nicht aktualisiert werden, mindestens zwei Buchstaben (keine Ziffern) benötigt!";
    $Self->{Translation}->{"Can't update password, this password has already been used. Please choose a new one!"} = "Passwort konnte nicht aktualisiert werden, da es bereits benutzt wurde. Bitte wählen sie ein anderes.";
}

1;
