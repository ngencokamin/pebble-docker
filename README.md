# Pebble Development with Docker
Docker image for Pebble  development using Rebble SDK.

## Legal Note
You must accept the [Pebble Terms of Use](https://developer.getpebble.com/legal/terms-of-use/) and the [SDK License Agreement](https://developer.getpebble.com/legal/sdk-license/) to use the Pebble SDK.

## Usage

### Open a shell

To run the container, use the example command below. Replace `<Your Path>` with the path to the directory you want the container to use (eg `~/pebble-dev` for a folder named "pebble-dev" in your home directory).

```shell
docker run --rm -it -v <Your Path>/:/pebble/ ngencokamin/pebble-dev
```

This will open a shell with the Pebble SDK configured, allowing you to use the `pebble` command.

The directory in the container will be `/pebble/`, with the actual path being the one specified above.

The container will remove itself once the session is closed. To reuse it, omit `--rm` when running your command.

### Use directly

You can run a pebble command directly by specifying the command to run at the end of the line above. For example, to build your application, run:

```shell
docker run --rm -it -v <Your Path>/:/pebble/ ngencokamin/pebble-dev pebble build
```

Note that if extra dependencies are required, you will need to specify them prior to running pebble build. In the case of [my app ](https://github.com/ngencokamin/PebbleNotes), that would look like:

```shell
docker run --user root --rm -it -v <Your Path>/:/pebble/ ngencokamin/pebble-dev sh -c "npm i -g jshint uglify-js && pebble build"
```

This command includes `--user root` because `npm i -g` failed without it in my builds, but you may not need to do this.

### Emulator

I'm on a Wayland compositor and can't seem to get this working, but the following steps *should* work for people on X11 WMs/DEs.

For many distros, you should just need to add `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix` to the docker run command. For some distros, such as Arch, you may also need to add `-v ~/.Xauthority:/home/pebble/.Xauthority --net=host`.

### GitHub Actions

See [this file](https://github.com/ngencokamin/PebbleNotes/blob/master/.github/workflows/main.yaml) in another one of my projects for an example of building a Pebble app using GitHub Actions. See [Use Directly](##Use Directly) for an explanation of why `--user root` is specified.

## Credits

This project was heavily inspired by [bboehmke's docker-pebble-dev](https://github.com/bboehmke/docker-pebble-dev/tree/master) and [pebble-dev's rebble-docker](https://github.com/pebble-dev/rebble-docker). I decided to write my own because I couldn't get either of those working for the purposes I needed, but I definitely based a chunk of my work around those projects.
