# ansible-role-certbot

This role has goal to create or renew let's encrypt certificate with certbot client  

This role support :  
  - certbot DNS-01 challenge with OVH as DNS provider  

## Setup development environment

### Setup environment 
```shell
sudo make install-python
sudo apt-get install direnv -y
if [ ! "$(grep -ir "direnv hook bash" ~/.bashrc)" ];then echo 'eval "$(direnv hook bash)"' >> ~/.bashrc; fi && direnv allow . && source ~/.bashrc
make env prepare
```

## Testing ansible-role-certbot execution in vagrant-docker environment

```shell
make test-docker
```

## Variables
* ``certbot_domain_name``: domain name of the SSL certificate  
* ``certbot_account_email``: the account email to use  
* ``certbot_expiration_interval``: the expiration interval before certificate expiration (in days)  
* ``certbot_service_to_restart``: the service to restart to apply the new certificate (can be empty)  
* ``certbot_dry_run``: test "renew" or "certonly" without saving any certificates to disk (usefull for testing this role application before deploy in production)  

### OVH as DNS provider
* ``certbot_ovh_api_file_location``: ovh api file location where will be store the OVH credentials for DNS challenge  
* ``certbot_ovh_dns_endpoint``: ovh api dns_endpoint  
* ``certbot_ovh_dns_application_key``: ovh api application_key  
* ``certbot_ovh_dns_consumer_key``: ovh api consumer_key  
* ``certbot_ovh_dns_application_secret``: ovh api application_secret  

## An example of variable file 
```yaml
---
certbot_domain_name: "my-useless-domain.fr"
certbot_account_email: "user@my-domain.fr"

certbot_expiration_interval: "15"

certbot_service_to_restart: "apache2"

certbot_dry_run: true

certbot_dns_provider: "ovh"
certbot_ovh_dns_endpoint: "ovh-eu"
certbot_ovh_dns_application_key: "my_ovh_application_key"
certbot_ovh_dns_consumer_key: "my_ovh_consumer_key"
certbot_ovh_dns_application_secret: "my_ovh_application_secret"
```

## Display makefile helper
```shell
make help
```

Enjoy :) 
