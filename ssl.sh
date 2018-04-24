#!/bin/bash

if [ $# -lt 2 ];
    then
        echo "You must use the format $ ssl.sh domain username"; exit
fi

echo "Creating certificate for $1"

if [ $# -lt 3 ];
    then
        wget https://raw.githubusercontent.com/srvrco/getssl/master/getssl;
        sed -i 's/curl -k/curl -Aagent -k/' ./getssl;
        chmod 700 getssl;
fi

domain=$1; ./getssl -c $domain
configFile=.getssl/$domain/getssl.cfg
sed -i '$ a USE_SINGLE_ACL="true"' $configFile
echo "ACL=('/home/$2/www/.well-known/acme-challenge')" >> $configFile
sed -i 's|CA="https://acme-staging.api.letsencrypt.org"|#CA="https://acme-staging.api.letsencrypt.org"|' .getssl/getssl.cfg
sed -i 's|#CA="https://acme-v01.api.letsencrypt.org"|CA="https://acme-v01.api.letsencrypt.org"|' .getssl/getssl.cfg
./getssl $domain

echo "
Completed"
