# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::fr_FR_AgentPasswordPolicy;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'This module is being used to extend the password policy.'} = 'Ce module permet la gestion avancée des mots de passe.';

    $Self->{Translation}->{'Password Policy'} = 'Mots de passe';
    $Self->{Translation}->{'Your current password is older than %s days. You need to set a new one.'} = 'Votre mot de passe actuel est plus ancien que %s jours. Vous devez le modifier.';
    $Self->{Translation}->{'Password needs to be renewed every %s days.'} = 'Le mot de passe doit être changé tous les %s jours.';
    $Self->{Translation}->{'Password history is active, you can\'t use a password which was used the last %s times.'} = 'L\'historique des mots de passe est activé, vous ne pouvez pas utiliser les %s derniers mots de passe.';
    $Self->{Translation}->{'Password length must be at least %s characters.'} = 'La taille minimale du mot de passe est de %s caractères.';
    $Self->{Translation}->{'Password requires at least two lower- and two uppercase characters.'} = 'Le mot de passe doit avoir au minimum 2 minuscules et 2 majuscules.';
    $Self->{Translation}->{'Password requires at least two characters.'} = 'Le mot de passe doit avoir au moins 2 lettres.';
    $Self->{Translation}->{'Password requires at least one digit.'} = 'Le mot de passe doit avoir au moins 1 chiffre.';
    $Self->{Translation}->{'Change config options'} = 'Modifier les options de configuration';
    $Self->{Translation}->{'Admin permissions are required!'} = 'Les droits administrateurs sont nécessaires !';
    $Self->{Translation}->{'Repeat new password'} = 'Confirmez le mot de passe';
    $Self->{Translation}->{'Defines the config parameters of this item, to be shown in the preferences view.'} = 'Déterminez les paramètres de configuration pour cet objet à afficher dans la vue des préférences.';
    $Self->{Translation}->{"Can't update password, the new password and the repeated password do not match."} = "Impossible de mettre à jour votre mot de passe, les mots de passe saisis ne correspondent pas ! Veuillez réessayer !";
    $Self->{Translation}->{"Please supply your new password!"} = "Veuillez mettre à jour votre mot de passe !";
    $Self->{Translation}->{"Can't update password, invalid characters!"} = "Votre mot de passe ne peut pas être modifié, des caractères non autorisés ont été utilisés !";
    $Self->{Translation}->{"Can't update password, must be at least %s characters!"} = "Votre mot de passe ne peut pas être modifié, il doit contenir au minimum %s caractères !";
    $Self->{Translation}->{"Can't update password, must contain at least two lower- and two uppercase characters!"} = "Votre mot de passe ne peut pas être modifié, il doit contenir au minimum 2 minuscules et 2 majuscules !";
    $Self->{Translation}->{"Can't update password, needs at least one digit!"} = "Votre mot de passe ne peut pas être modifié, il doit contenir au minimum 1 chiffre !";
    $Self->{Translation}->{"Can't update password, needs at least two characters!"} = "Votre mot de passe ne peut pas être modifié, il doit contenir au minimum 2 lettres !";
    $Self->{Translation}->{"Can't update password, this password has already been used. Please choose a new one!"} = "Votre mot de passe ne peut pas être modifié, il a déjà été utilisé. Veuillez en choisir un autre !";
    $Self->{Translation}->{"Preferences updated successfully!"} = "Paramètres correctement mis à jour.";
}

1;
