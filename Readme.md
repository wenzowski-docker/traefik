[Træfik](https://github.com/containous/traefik)
------
This repository provides a docker-deployable Træfik image with healthcheck
- [Træfik docs](https://docs.traefik.io/)
- [Træfik source](https://github.com/containous/traefik)
- [Træfik image](https://github.com/containous/traefik-library-image)

Build
=====
Build Dockerfile using `docker-machine active` docker daemon.

```
make build
```

Release
=======
Upload built image to a remote container registry.

```
git commit
git tag (cat VERSION)
make release
```

Deploy
======
Deploy uploaded image to `docker-machine active` swarm.

```
make deploy
```

See Also
========
- https://raw.githubusercontent.com/containous/traefik/master/traefik.sample.toml
- https://github.com/containous/traefik/wiki/Awesome-Traefik
