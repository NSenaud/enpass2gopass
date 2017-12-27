enpass2gopass
=============


As its name states, this script helps to migrate from Enpass password manager
to the amazing [gopass][gopass].


Usage
-----

`ruby enpass2gopass export.csv`

The script will call `gopass insert [website or Enpass entry title]/[username or email address]`
to insert exported entries in the gopass keyring.


Warnings
--------

* This is my first Ruby script! So proceed carefully.
* The script only support login entries, not notes or other types of input.
  In my case, I manually expurge the CSV file created by Enpass. I don't plan
  to improve the script since the very big majority of my entries was simple
  password and I can deal manually with the very few other things.
* The script does not import OTP/TOTP/HOTP


Credits
-------

Thanks to [Alex Sayers](mailto://alex.sayers@gmail.com), author of
[lastpass2pass][lastpass2pass], whom I took the basic file structure.


[gopass]: https://github.com/justwatchcom/gopass
[lastpass2pass]: https://git.zx2c4.com/password-store/tree/contrib/importers/lastpass2pass.rb
