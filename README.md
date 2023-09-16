# jnethack-docker

## build

```
$ docker build -t jnethack .
```

## run

```
$ docker run -it --rm jnethack
```

## run wih `save`

```
$ docker run -it --rm -v$(pwd)/save:/usr/local/games/lib/jnethackdir/save jnethack
```

