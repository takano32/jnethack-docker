# jnethack-docker

## build

```
$ docker build -t jnethack .
```

## run

```
$ docker run -it --rm jnethack
```

## run prebuilt image

```
$ docker run -it --rm ghcr.io/takano32/jnethack-docker
```

## run wih `save`

```
$ docker compose run --rm jnethack
```

The playground (save files, bones, scores) lives in the `playground` volume.
The files that belong to the image are refreshed on every start, so pulling a
newer image is enough to upgrade.

