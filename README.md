# NGINX Debian/Ubuntu Package Building:

## NGINX MODULES:

https://docs.google.com/spreadsheets/d/1Vor4TxODlBbBfKE_jJz6Hl7y1HIRsUV_p1FYdeiD1vU/

## Build Services:

1. [Launchpad](https://github.com/AnsiPress/NGINX#launchpad)
2. [OpenSUSE Build Services](https://github.com/AnsiPress/NGINX#opensuse-build-services)


### Launchpad:

#### Create Account:

https://launchpad.net/+login

> The site Launchpad requires that you verify your email address before accessing its contents.

Check your INBOX and click on link to verify.

#### Generate GPG/PGP Keys:

```bash
^_^[Mitesh@Shah:~]$ gpg --gen-key

Please select what kind of key you want:
   (1) RSA and RSA (default)
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
Your selection? 1

RSA keys may be between 1024 and 4096 bits long.
What keysize do you want? (2048) 4096

Please specify how long the key should be valid.
         0 = key does not expire
        = key expires in n days
      w = key expires in n weeks
      m = key expires in n months
      y = key expires in n years
Key is valid for? (0) 0

Key does not expire at all
Is this correct? (y/N) y

Real name: Mitesh Shah
Email address: Mr.Miteshah@gmail.com
Comment: Mitesh Shah GPG Key

You selected this USER-ID:
    "Mitesh Shah (Mitesh Shah GPG Key) <Mr.Miteshah@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O

generator a better chance to gain enough entropy.

Not enough random bytes available.  Please do some other work to give
the OS a chance to collect more entropy! (Need 281 more bytes)
```

Just open another terminal window and run some commands which generates plenty of activity.

My favorite is running a disk write performance benchmark using:

```bash
dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync
```

#### List Keys:

```bash
^_^[Mitesh@Shah:~]$ gpg --list-keys
/home/mitesh/.gnupg/pubring.gpg
------------------------
pub   4096R/BE143B73 2016-12-01
uid       [ultimate] Mitesh Shah (Mitesh Shah GPG Key) <Mr.Miteshah@gmail.com>
sub   4096R/A828B326 2016-12-01
```

#### Making An ASCII Armored Version Your Public Key:

```bash
^_^[Mitesh@Shah:~]$ gpg --output MiteshShah.asc --export -a $GPGKEY
```

NOTE: In This Example $GPGKEY = BE143B73


#### Upload Keys To Ubuntu Key Server:

```bash
^_^[Mitesh@Shah:~]$ gpg --send-keys --keyserver keyserver.ubuntu.com $GPGKEY
```

#### GPG Key FingerPrint:

```bash
^_^[Mitesh@Shah:~]$ gpg --fingerprint
/home/mitesh/.gnupg/pubring.gpg
------------------------
pub   4096R/BE143B73 2016-12-01
      Key fingerprint = D7F0 39D8 E114 29B0 EBF7  D434 CA18 5362 BE14 3B73
uid       [ultimate] Mitesh Shah (Mitesh Shah GPG Key) <Mr.Miteshah@gmail.com>
sub   4096R/A828B326 2016-12-01
```

#### Add GPG/PGP Keys To LaunchPad:

1. https://launchpad.net/people/+me/+editpgpkeys
1. Sign The Code Of Conduct
1. Create A LaunchPad PPA: NGINX


### OpenSUSE Build Services:

#### Create Account:

https://build.opensuse.org/

After that check you INBOX and click of verification link

#### Create Project:

1. Click on your profile name
2. Click on Home Project (Upper Right Corner)
3. Click on Create project

#### Create Packages:

1. Click on package
2. Fill the package description
3. Save changes

#### Define Build targets

1. Click on build targets
2. Define your build targets
3. Click on "Add selected repositories"


## Build NGINX Package:

### Download NGINX Build Script
```
^_^[Mitesh@Shah:~]$ wget -c https://raw.githubusercontent.com/AnsiPress/NGINX/master/build.sh
^_^[Mitesh@Shah:~]$ bash build.sh 1.10.3 Mr.Miteshah@gmail.com
```

### Make A Debian Source For Upload To PPA:

```
^_^[Mitesh@Shah:~]$ cd ~/PPA/nginx/nginx-1.10.3
# For new nginx version 1.10.3
^_^[Mitesh@Shah:~]$ debuild -S -sa --source-option=--include-binaries -k'BE143B73'
# For minor changes on existing nginx 1.10.3
# Download nginx_1.10.3.orig.tar.xz from launchpad
^_^[Mitesh@Shah:~]$ debuild -S -k'BE143B73'
```

## Upload NGINX Package:

### Launchpad

```
^_^[Mitesh@Shah:~]$ dput ppa:ansipress/nginx ~/PPA/nginx/nginx_1.10.3-1+xenial_source.changes
```

### OpenSUSE Builder

* Go to package page
* Click on add file
* Now upload following files

```
nginx_1.10.3-1+xenial.dsc
nginx_1.10.3-1+xenial_source.build
nginx_1.10.3-1+xenial_source.changes
nginx_1.10.3-1+xenial.debian.tar.xz
```
