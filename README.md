Password Policy
===============
"Password Policy" is a generic extension which works well together with all extensions provided by OTRS AG. A SysConfig setting allows you to configure "Password Policy" (see more in the configuration options).

This extension is useful if strong password policies are needed, e. g. in CERT or financial environments.

<img src="Znuny4OTRS-PasswordPolicy/raw/master/screenshots/passwordpolicy.png" />

Feature List
============
* Enforce a password renewal after X (configurable) days.
* Password-History to use the password X (configurable) times not to use again.
* Disable account after x invalid login attempts.
* Minimum size of the password.
* At least 2 small and 2 big letters in a password.
* At least 2 letters in a password.
* At least one number in a password.

Configuration
=============
Via SysConfig-Settings (Admin -> SysConfig -> Group "Framework::Password::Policy", Sub-Group "Frontend::Agent::Password").

* PasswordMaxValidTimeInDays (max. valid days of a password)
* PasswordNeedDigit (at least 1 digit is required)
* PasswordMaxLoginFailed (count of invalid login attempts)
* PasswordMin2Characters (at least 2 characters are required)
* PasswordMin2Lower2UpperCharacters (at least 2 upper and 2 lower characters are required)
* PasswordMinSize (min. length of a password)
* PasswordRegExp (Regular Expression to enhance the password policy)
* PasswordHistory (already used passwords can not be used again)

Installation
============
Download the package and install it via admin interface -> package manager.

Prerequisites
* OTRS 3.0
* OTRS 3.1
* OTRS 3.2

Download
========
For download see http://znuny.com/d/

Commercial Support
==================
For this extention and for OTRS in gerneral visit http://znuny.com. Looking forward to hear from you!

Enjoy!

 Your Znuny Team!
 http://znuny.com

