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
$ docker run -it --rm -v$(pwd)/save:/usr/local/games/lib/jnethackdir/save jnethack
```

