#!/bin/bash



# Define NGINX version
NGINX_VERSION=$1
EMAIL_ADDRESS=$2
export DEBFULLNAME="Mitesh Shah"


# Capture errors
function ppa_error()
{
	echo "[ `date` ] $(tput setaf 1)$@$(tput sgr0)"
	exit $2
}

# Echo function
function ppa_lib_echo()
{
	echo $(tput setaf 4)$@$(tput sgr0)
}

# Update/Install Packages
ppa_lib_echo "Execute: apt-get update, please wait"
sudo apt-get update || ppa_error "Unable to update packages, exit status = " $?
ppa_lib_echo "Installing required packages, please wait"
sudo apt-get -y install git dh-make devscripts debhelper dput gnupg-agent dh-systemd || ppa_error "Unable to install packages, exit status = " $?

# Lets Clone Launchpad repository
ppa_lib_echo "Copy Debian files, please wait"
rm -rf /tmp/NGINX && git clone -b master https://github.com/AnsiPress/NGINX.git /tmp/NGINX \
|| ppa_error "Unable to clone NGINX repository, exit status = " $?

# Configure NGINX PPA
mkdir -p ~/PPA/nginx && cd ~/PPA/nginx \
|| ppa_error "Unable to create ~/PPA/nginx, exit status = " $?

# Download NGINX
ppa_lib_echo "Download nginx, please wait"
wget -c http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz \
|| ppa_error "Unable to download nginx-${NGINX_VERSION}.tar.gz, exit status = " $?
tar -zxvf nginx-${NGINX_VERSION}.tar.gz \
|| ppa_error "Unable to extract nginx, exit status = " $?
cd nginx-${NGINX_VERSION} \
|| ppa_error "Unable to change directory, exit status = " $?

# Lets start building
ppa_lib_echo "Execute: dh_make --single --copyright gpl --email $EMAIL_ADDRESS --createorig, please wait"
dh_make --single --copyright gpl --email $EMAIL_ADDRESS --createorig \
|| ppa_error "Unable to run dh_make command, exit status = " $?
rm debian/*.ex debian/*.EX \
|| ppa_error "Unable to remove unwanted files, exit status = " $?

# Let's copy files
cp -av /tmp/NGINX/debian/* ~/PPA/nginx/nginx-${NGINX_VERSION}/debian/ \
|| ppa_error "Unable to copy launchpad debian files, exit status = " $?



# NGINX modules
ppa_lib_echo "Downloading NGINX modules, please wait"
mkdir ~/PPA/nginx/modules && cd ~/PPA/nginx/modules \
|| ppa_error "Unable to create ~/PPA/nginx/modules, exit status = " $?

ppa_lib_echo "1/3 echo-nginx-module"
git clone https://github.com/openresty/echo-nginx-module.git nginx-echo \
|| ppa_error "Unable to clone echo-nginx-module repo, exit status = " $?

ppa_lib_echo "2/3 lua-nginx-module"
git clone https://github.com/openresty/lua-nginx-module.git nginx-lua \
|| ppa_error "Unable to clone lua-nginx-module repo, exit status = " $?

ppa_lib_echo "3/3 ngx_pagespeed"
NPS_VERSION=1.11.33.4
wget https://github.com/pagespeed/ngx_pagespeed/archive/v${NPS_VERSION}-beta.tar.gz && \
tar -zxvf v${NPS_VERSION}-beta.tar.gz && \
mv ngx_pagespeed-${NPS_VERSION}-beta  ngx_pagespeed && \
rm v${NPS_VERSION}-beta.tar.gz \
|| ppa_error "Unable to clone ngx_pagespeed repo, exit status = " $?

cd ngx_pagespeed
wget -O psol.tar.gz https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz

cp -av ~/PPA/nginx/modules ~/PPA/nginx/nginx-${NGINX_VERSION}/debian/ \
|| ppa_error "Unable to copy launchpad modules files, exit status = " $?

# Edit changelog
vim ~/PPA/nginx/nginx-${NGINX_VERSION}/debian/changelog
