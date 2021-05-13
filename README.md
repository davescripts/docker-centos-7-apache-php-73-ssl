# Docker Container: Centos 7, Apache, PHP 7.3, and SSL

Dockerfile for a Container with Centos 7, Apache, PHP 7.3, and SSL for Web Development.

More details can be found [here](https://davescripts.com/docker-container-with-centos-7-apache-php-73-ssl).

<br>

## Build

Create Docker Image.

```sh
docker build -t <image_name> .
```

_Replace **&lt;image_name&gt;** with the name you want for the image._

<br>

Example.

```sh
docker build -t image_apache_ssl .
```

<br>

## Run

Create Docker Container.

```sh
docker run -tid -p 4000:80 -p 4001:443 --name=<container_name> -v /path_to/folder:/var/www/html <image_name>
```

_Replace **&lt;container_name&gt;** with the name you want for the container, and **&lt;image_name&gt;** with the name of the image you specified on the Build command above._

<br>

Example.

```sh
docker run -tid -p 4000:80 -p 4001:443 --name=container_apache_ssl -v /path_to/folder:/var/www/html image_apache_ssl
```

_Also change **"/path_to/folder"** with the actual location of your website's root folder on your local machine._

<br>

## Test

Open the https://localhost:4001 url on your browser.
