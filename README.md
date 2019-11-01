# How to use

Thanks: <https://github.com/kajyuuen/lab-dockerfile>

## build

```
$ export HOST_PORT = `expr 10000 + $UID`
$ make build
```

## run

```
$ HOST_DIR=<your code directory absolute path> make run
```

## exec

```
$ make exec
```

**Show jupyter notebook url**

```
$ make notebook-url
```
