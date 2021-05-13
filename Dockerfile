FROM centos:7

# Install Apache
RUN yum -y update
RUN yum -y install httpd httpd-tools mod_ssl openssl expect

# Install EPEL Repo
RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Install PHP
RUN yum --enablerepo=remi-php73 -y install php php-bcmath php-cli php-common php-gd php-intl php-ldap php-mbstring \
    php-mysqlnd php-pear php-soap php-xml php-xmlrpc php-zip

# Copy script that generates SSL certificate
COPY generate_certificate.exp /generate_certificate.exp

# Generate SSL certificate
RUN chmod +x /generate_certificate.exp \
 && ./generate_certificate.exp \
 && cp ca.crt /etc/pki/tls/certs \
 && cp ca.key /etc/pki/tls/private/ca.key \
 && cp ca.csr /etc/pki/tls/private/ca.csr

# Update Apache Configuration
RUN sed -E -i -e '/<Directory "\/var\/www\/html">/,/<\/Directory>/s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
RUN sed -E -i -e 's/DirectoryIndex (.*)$/DirectoryIndex index.php \1/g' /etc/httpd/conf/httpd.conf

# Update Apache SSL Configuration
RUN sed -E -i -e 's/\/etc\/pki\/tls\/certs\/localhost\.crt/\/etc\/pki\/tls\/certs\/ca.crt/g' /etc/httpd/conf.d/ssl.conf
RUN sed -E -i -e 's/\/etc\/pki\/tls\/private\/localhost\.key/\/etc\/pki\/tls\/private\/ca.key/g' /etc/httpd/conf.d/ssl.conf
RUN sed -E -i -e 's/#ServerName www\.example\.com\:443/ServerName www.example.com:443/g' /etc/httpd/conf.d/ssl.conf

EXPOSE 80 443

# Start Apache
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
