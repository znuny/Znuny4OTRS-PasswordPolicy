![Znuny logo](http://znuny.com/assets/images/logo_small.png)

Password Policy
===============
This extension is useful if strong password policies are needed, e. g. in CERT or financial environments.

![Screenshot SysConfig](https://github.com/znuny/Znuny4OTRS-PasswordPolicy/blob/master/doc/en/screenshots/passwordpolicy.png)

**Feature List**

* Enforce a password renewal after x (configurable) days.
* Password history to prevent reusing a password after x (configurable) times.
* Disable account after x invalid login attempts.
* Minimum length of password.
* At least two lower- and two uppercase letters.
* At least two letters.
* At least one digit in a password.


**Installation**

Download the package and install it via admin interface -> package manager or use Znuny4OTRS-Repo.


**Prerequisites**

- Znuny4OTRS-Repo

- OTRS 6


**Configuration**

Via SysConfig options `PreferencesGroups###Password` and `CustomerPreferencesGroups###Password`:

* PasswordMaxValidTimeInDays (max. valid days of a password)
* PasswordNeedDigit (at least one digit is required)
* PasswordMaxLoginFailed (max. count of invalid login attempts)
* PasswordMin2Characters (at least two characters are required)
* PasswordMin2Lower2UpperCharacters (at least two upper- and two lowercase characters are required)
* PasswordMinSize (min. length of a password)
* PasswordRegExp (regular expression to enhance the password policy)
* PasswordHistory (already used passwords can not be used again)

**Download**

For download see [http://znuny.com/en/#!/addons](http://znuny.com/en/#!/addons)

**Commercial Support**

For this extension and for OTRS in general visit [http://znuny.com](http://znuny.com). Looking forward to hear from you!

Enjoy!

 Your Znuny Team!

 [http://znuny.com](http://znuny.com)
