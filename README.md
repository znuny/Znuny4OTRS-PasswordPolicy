![Znuny logo](http://znuny.com/assets/images/logo_small.png)

Password Policy
===============
"Password Policy" is a generic extension which works well together with all extensions provided by OTRS AG. A SysConfig setting allows you to configure "Password Policy" (see more in the configuration options).

This extension is useful if strong password policies are needed, e. g. in CERT or financial environments.

![Screenshot SysConfig](https://github.com/znuny/Znuny4OTRS-PasswordPolicy/blob/master/doc/en/screenshots/passwordpolicy.png)

**Feature List**

* Enforce a password renewal after X (configurable) days.
* Password-History to use the password X (configurable) times not to use again.
* Disable account after x invalid login attempts.
* Minimum size of the password.
* At least 2 small and 2 big letters in a password.
* At least 2 letters in a password.
* At least one number in a password.


**Installation**

Download the package and install it via admin interface -> package manager or use Znuny4OTRS-Repo.


**Prerequisites**

- Znuny4OTRS-Repo

- OTRS 4


**Configuration**

Via SysConfig-Settings (Admin -> SysConfig -> Group "Framework::Password::Policy", Sub-Group "Frontend::Agent::Password").

* PasswordMaxValidTimeInDays (max. valid days of a password)
* PasswordNeedDigit (at least 1 digit is required)
* PasswordMaxLoginFailed (count of invalid login attempts)
* PasswordMin2Characters (at least 2 characters are required)
* PasswordMin2Lower2UpperCharacters (at least 2 upper and 2 lower characters are required)
* PasswordMinSize (min. length of a password)
* PasswordRegExp (Regular Expression to enhance the password policy)
* PasswordHistory (already used passwords can not be used again)

**Download**

For download see [http://znuny.com/en/#!/addons](http://znuny.com/en/#!/addons)

**Commercial Support**

For this extension and for OTRS in general visit [http://znuny.com](http://znuny.com). Looking forward to hear from you!

Enjoy!

 Your Znuny Team!

 [http://znuny.com](http://znuny.com)
