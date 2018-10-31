# System Administration HW3 Writeups

## FTP part

### Step 1. Install the pure-ftpd if nothing is found in your /usr/ports
* First install the snap if is cries 

cd /usr/ports/ftp/pureftpd
/usr/ports/ftp/pureftpd: No such file or directory.
```sh
portsnap fetch
```
* Make it with the component that TA wants
```sh
cd /usr/ports/ftp/pureftpd
sudo make #(compile with the upload script after the GUI pops out, must be installed with sudo!)
```
### Step 2. Start the pureftp daemon "pure-ftpd".
* Now start the ftp daemon service but cries with the following error
```sh
sudo pure-ftpd onestart

/usr/local/etc/rc.d/pure-ftpd: WARNING: /usr/local/etc/pure-ftpd.conf is not readable.
/usr/local/etc/rc.d/pure-ftpd: WARNING: failed precmd routine for pureftpd
```

found that pure-ftpd in /usr/local/etc is not named as pure-ftpd.conf but pure-ftpd.conf.sample
so just
```sh

/usr/local/etc/rc.d
> cd ..
> ls
avahi				gnome.subr			periodic			pureftpd-pgsql.conf.sample	tcsd.conf
bash_completion.d		gtk-2.0				pkg.conf			rc.d				tcsd.conf.sample
cups				man.d				pkg.conf.sample			ssl				vim
dbus-1				pam.d				pure-ftpd.conf.sample		sudoers
devd				papersize.a4			pureftpd-ldap.conf.sample	sudoers.d
fonts				papersize.letter		pureftpd-mysql.conf.sample	sudoers.dist
> sudo mv pure-ftpd.conf.sample pure-ftpd.conf
```

and then
```sh
sudo service pure-ftpd onestart
sudo service pure-ftpd status
pureftpd is running as pid 83241. #this shows pure-ftpd is running well
```

### Trouble shooting after building pure-ftpd but still unable to connect from FileZilla

* Problem: Unable to connect from localhost to ftp within same PC(one in main OS and the other in the Virtual Box, the user is the one that created after installed FreeBSD)

![](https://imgur.com/NRc2Dza.png)

![](https://imgur.com/r91d07b.png)

* Reason
Due to the lack of users to be added in the pure-pw system, the pure=pw system is the stand alone user database hold by pure-ftpd

* Solution
Try to first add the account and do the configs