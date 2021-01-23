# Hitch Docker image

[![pipeline status](https://git.shore.co.il/nimrod/hitch-docker/badges/master/pipeline.svg)](https://git.shore.co.il/nimrod/hitch-docker/-/commits/master)
[![Docker Hub downloads](https://img.shields.io/docker/pulls/adarnimrod/hitch?logo=docker)](https://hub.docker.com/r/adarnimrod/hitch)

## Usage example

```
docker run -p 80:80 adarnimrod/hitch --client --backend [google.com]:443 --frontend [*]:80 --log-level 1 --user=nobody /etc/ssl/cert.pem
```

Netcat and OpenSSL are included in the image, so you can also specify better
healthchecks for your use-case.

## License

This software is licensed under the MIT license (see `LICENSE.txt`).

## Author Information

Nimrod Adar, [contact me](mailto:nimrod@shore.co.il) or visit my
[website](https://www.shore.co.il/). Patches are welcome via
[`git send-email`](http://git-scm.com/book/en/v2/Git-Commands-Email). The repository
is located at: <https://git.shore.co.il/explore/>.
