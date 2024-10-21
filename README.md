![Znuny logo](https://www.znuny.com/assets/images/logo_small.png)

![Build status](https://badge.proxy.znuny.com/Znuny4OTRS-PasswordPolicy/rel-7_1)

Znuny-PasswordPolicy
====================
This add-on is useful if strong password policies are needed, e.g. in CERT or financial environments.

![Screenshot SysConfig](https://github.com/znuny/Znuny4OTRS-PasswordPolicy/blob/rel-7_1/doc/en/screenshots/passwordpolicy.png)

**Feature List**

* Enforce a password renewal after x (configurable) days.
* Password history to prevent reusing a password after x (configurable) times.
* Disable account after x invalid login attempts.
* Minimum length of password.
* At least two lower- and two uppercase letters.
* At least two letters.
* At least one digit in a password.

**Prerequisites**

- Znuny 7.1

**Installation**

Use the online repository **Znuny Open Source Add-ons** from the package manager to install the add-on. From the command line use this command: `bin/znuny.Console.pl Admin::Package::Install  https://addons.znuny.com/public/:Znuny-PasswordPolicy`

**Configuration**

Via system configuration options `PreferencesGroups###Password` and `CustomerPreferencesGroups###Password`:

* PasswordMaxValidTimeInDays (max. valid days of a password)
* PasswordNeedDigit (at least one digit is required)
* PasswordMaxLoginFailed (max. count of invalid login attempts)
* PasswordMin2Characters (at least two characters are required)
* PasswordMin2Lower2UpperCharacters (at least two upper- and two lowercase characters are required)
* PasswordMinSize (min. length of a password)
* PasswordRegExp (regular expression to enhance the password policy)
* PasswordHistory (already used passwords can not be used again)

**Commercial Support**

For this add-on and for Znuny in general visit [www.znuny.com](https://www.znuny.com). Looking forward to hear from you.


Your Znuny Team!

[https://www.znuny.com](https://www.znuny.com)
