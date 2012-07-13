App Store Emigrant [![Build Status](https://secure.travis-ci.org/timkurvers/app-store-emigrant.png?branch=master)](http://travis-ci.org/timkurvers/app-store-emigrant)
==================

App Store Emigrant is a Ruby gem that will manually attempt to verify whether any of your local mobile applications are out of date, which iTunes will refuse to do automatically once you have moved countries.

**Suported Ruby versions: 1.8.7 or higher**

Licensed under the **MIT** license, see LICENSE for more information.

Background
----------

For more information on the issues faced when moving countries with regards to Apple's ecosystem please see [these](https://discussions.apple.com/thread/2443094) [discussions](https://discussions.apple.com/message/16273593).

**TL;DR**: For reasons unknown to mankind, Apple has made it rather complicated to update applications bought in different stores, particularly after emigrating. iTunes mentions updates are available, but refuses to actually update these apps when asked to. These applications are also missing from the Purchases-tab.

App Store Emigrant tries to soothe these pains - albeit only partially - by scanning your iTunes library folder for mobile applications and querying iTunes for the latest versions available. One can then manually go into the store and update each application, one by one. *sigh*

![App Store Emigrant](http://office.moonsphere.net/app-store-emigrant.png)

Installation
------------

App Store Emigrant is available from RubyGems and can be installed through the command-line. Fire up your favourite terminal and run:

    gem install app-store-emigrant

Installing on **OSX** and using the **default system Ruby**? Run:

    sudo gem install app-store-emigrant


Usage
-----

Once installed, a new not-so-fantastically named binary called ```ase``` will be added to your path. Invoke the binary to start the verification process:

    ase

If App Store Emigrant complains that it cannot find your default library, help it along and specify where your mobile applications lurk:

    ase ~/m00sic
