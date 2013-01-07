Password Policy
===============
"Password Policy" is a generic extension which works well together with all OTRS AG provided extensions. A SysConfig setting allows you to configure "Password Policy" (see more in the configuration options).

This extension is useful where strong password policies are used, e. g. in CERT or financial environments.

<img src="Znuny4OTRS-PasswordPolicy/raw/master/screenshots/passwordpolicy.png" />

Feature List
============
* Enforce a password renewal after X (configurable) days.
* Password-History to use the password X (configurable) times not to use again.
* Disable account after x invalid login attempts.
* Min size of the password.
* Need min. 2 small and 2 big letters in a password.
* Need min. 2 letters in a password.
* Need min. a number in a password.

Configuration
=============
Via SysConfig-Settings (Admin -> SysConfig -> Group "Framework::Password::Policy", Sub-Group "Frontend::Agent::Password").

* PasswordMaxValidTimeInDays (max. valid days of a password)
* PasswordNeedDigit (min. 1 digit is required)
* PasswordMaxLoginFailed (count of invalid login attempts)
* PasswordMin2Characters (min. 2 characters are required)
* PasswordMin2Lower2UpperCharacters (min. 2 upper and 2 lower characters are required)
* PasswordMinSize (min. size of a password)
* PasswordRegExp (Regular Expression to enhance the password policy)
* PasswordHistory (used password can not be used configured time)

Installation
============
Download the package and install it via admin interface -> package manager.

Prerequisites
* OTRS 3.0
* OTRS 3.1

Download
========
For download see http://znuny.com/d/

Commercial Support
==================
For this extention and for OTRS in gerneral visit http://znuny.com. Looking forward to hear from you!

Enjoy!

 Your Znuny Team!
 http://znuny.com

