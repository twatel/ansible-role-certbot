# ansible-role-certbot

This role has goal to create or renew let's encrypt certificate with certbot client  

This role support :  
  - certbot DNS-01 challenge with OVH as DNS provider  
  - certbot DNS-01 challenge with AWS route53 as DNS provider (not tested yet)  
  - certbot HTTP-01 challenge with Apache as HTTP web server  
  - certbot HTTP-01 challenge with Nginx as HTTP web server   

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

* ``certbot_challenge_method``: challenge method for certificate generation (can be http-01 or dns-01)  

### HTTP-01 challenge
* ``certbot_http_provider``: http provider to renew certificate (can be apache or nginx)  
* ``certbot_http_port``: certbot default http port to listen during http-01 challenge  

### DNS-01 challenge
#### OVH as DNS provider
* ``certbot_ovh_api_file_location``: ovh api file location where will be store the OVH credentials for DNS challenge  
* ``certbot_ovh_dns_endpoint``: ovh api dns_endpoint  
* ``certbot_ovh_dns_application_key``: ovh api application_key  
* ``certbot_ovh_dns_consumer_key``: ovh api consumer_key  
* ``certbot_ovh_dns_application_secret``: ovh api application_secret  

#### AWS as DNS provider
* ``certbot_route53_aws_region``: aws region  
* ``certbot_route53_aws_access_key_id``: aws user access key  
* ``certbot_route53_aws_secret_access_key_id``: aws user secret access key  

## Some example of variable file 

### DNS-01 OVH
```yaml
---
certbot_domain_name: "my-useless-domain.fr"
certbot_account_email: "user@my-domain.fr"
certbot_expiration_interval: "15"
certbot_service_to_restart: "apache2"
certbot_dry_run: true

certbot_challenge_method: "dns-01"

certbot_dns_provider: "ovh"
certbot_dns_propagation_seconds: "30"

certbot_ovh_api_file_location: "~/.ovhapi"
certbot_ovh_dns_endpoint: "ovh-eu"
certbot_ovh_dns_application_key: "my_ovh_application_key"
certbot_ovh_dns_consumer_key: "my_ovh_consumer_key"
certbot_ovh_dns_application_secret: "my_ovh_application_secret"
```

### DNS-01 ROUTE 53
```yaml
---
certbot_domain_name: "my-useless-domain.fr"
certbot_account_email: "user@my-domain.fr"
certbot_expiration_interval: "15"
certbot_service_to_restart: "apache2"
certbot_dry_run: true

certbot_challenge_method: "dns-01"

certbot_dns_provider: "ovh"
certbot_dns_propagation_seconds: "30"

certbot_route53_aws_region: ""
certbot_route53_aws_access_key_id: ""
certbot_route53_aws_secret_access_key_id: ""
```

### HTTP-01 APACHE
```yaml
---
certbot_domain_name: "my-useless-domain.fr"
certbot_account_email: "user@my-domain.fr"
certbot_expiration_interval: "15"
certbot_service_to_restart: "apache2"
certbot_dry_run: true

certbot_challenge_method: "http-01"

certbot_http_provider: "apache"
```

### HTTP-01 NGINX
```yaml
---
certbot_domain_name: "my-useless-domain.fr"
certbot_account_email: "user@my-domain.fr"
certbot_expiration_interval: "15"
certbot_service_to_restart: "nginx"
certbot_dry_run: true

certbot_challenge_method: "http-01"

certbot_http_provider: "nginx"
```

## Display makefile helper
```shell
make help
```

**! The AWS route 53 apply didn't be tested yet !**  

**Certbot HTTP challenge required an opened HTTP port to the target machine**  
**I used an AWS machine for the role testing**  
**For the moment, this part is not automated**  

Enjoy :) 
