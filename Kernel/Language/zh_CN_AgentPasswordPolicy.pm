# --
# Copyright (C) 2012-2017 Znuny GmbH, http://znuny.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Language::zh_CN_AgentPasswordPolicy;

use strict;
use warnings;

use utf8;

sub Data {
    my $Self = shift;

    # SysConfig
    $Self->{Translation}->{'This module is used to extend password policy.'} = '该附加组件将扩展系统的密码策略.';

    $Self->{Translation}->{'Password Policy'} = '密码策略';
    $Self->{Translation}->{'Your current password is older then %s days. You need to set a new one.'} = '你当前的密码已使用超过 %s 天, 你需要设置一个新密码.';
    $Self->{Translation}->{'Password need to be renewed every %s days.'} = '密码必须每 %s 天更新一次.';
    $Self->{Translation}->{'Password history is active, you can\'t use a password which was used the last %s times.'} = '激活密码历史功能, 你不能使用最后 %s 次使用过的密码.';
    $Self->{Translation}->{'Password size is min. %s character.'} = '密码至少有 %s 个字符.';
    $Self->{Translation}->{'Password required min. 2 lower and 2 upper character.'} = '密码至少包括 2 个小写字母和 2 个大写字母.';
    $Self->{Translation}->{'Password required min. 2 character.'} = '密码至少包括 2 个字母.';
    $Self->{Translation}->{'Password required min. 1 digit.'} = '密码至少包括一个数字.';
    $Self->{Translation}->{'Change Config Options'} = '更改配置';
    $Self->{Translation}->{'Admin Permissions are required!'} = '需要管理员权限!';
    $Self->{Translation}->{'New password again'} = '再输入一次新密码';
    $Self->{Translation}->{'Defines the config parameters of this item, to be shown in the preferences view.'} = '在这里定义的配置参数将显示在个人偏好设置里.';
    $Self->{Translation}->{'Can\'t update password, your new passwords do not match! Please try again!'} = '由于两次输入的密码不匹配, 无法更改密码! 请重试!';
    $Self->{Translation}->{'Please supply your new password!'} = '请提供一组新密码!';
    $Self->{Translation}->{'Can\'t update password, invalid characters!'} = '非法字符, 无法更改密码!';
    $Self->{Translation}->{'Can\'t update password, must be at least %s characters!'} = '至少包括 %s 个字符, 无法更改密码!';
    $Self->{Translation}->{'Can\'t update password, must contain 2 lower and 2 upper characters!'} = '密码至少包括 2 个小写字母和 2 个大写字母, 无法更改密码!';
    $Self->{Translation}->{'Can\'t update password, needs at least 1 digit!'} = '密码至少括一个数字, 无法更改密码!';
    $Self->{Translation}->{'Can\'t update password, needs at least 2 characters!'} = '密码至少包括 2 个字母, 无法更改密码!';
    $Self->{Translation}->{'Can\'t update password, this password has already been used. Please choose a new one!'} = '无法更改密码, 该密码之前已经使用过, 请设置一个全新的密码!';
    $Self->{Translation}->{'Preferences updated successfully!'} = '偏好设置更新成功!';
}

1;
