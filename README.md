# go-docker-alpine-remote-debug

A simple example on how to enable remote debugging using [Delve](https://github.com/go-delve/delve) 
for a Go application running in an Alpine Linux Docker container.

## Background

This example contains a simple Go web application which returns `Hello world!`
on all HTTP requests to the endpoint `/hello`. The application is packaged into
a Docker image which includes the Delve debugger and can accept remote debugging
sessions on a user specified port.

Explore the code to see how this is accomplished :).

## Build and Run

Build the application and Docker image. This example utilizes a multi-stage 
Docker build to download and install Delve, and compile the application:
```sh
$ docker build ./ -t debug-example:latest -f Dockerfile

[+] Building 9.5s (18/18) FINISHED 
...
````

Run a container:
```sh
$ docker run \
    --rm \
    -p 8080:8080 \
    -p 40000:40000 \
    -e REMOTE_DEBUG_PORT=40000 \
    -e REMOTE_DEBUG_PAUSE_ON_START=true \
    debug-example:latest

Starting application with remote debugging on port 40000
Process execution will be paused until a debug session is attached
Executing command: /bin/dlv --listen=:40000 --headless=true --log --api-version=2 --accept-multiclient exec /bin/app  --  
API server listening at: [::]:40000
...
```

Once the container is running, you can establish a remote debugging session for 
the application on port `40000` (feel free to change the port - there's nothing
special about `40000`, I just like that number). While you can always use the 
[Delve command line client](https://github.com/go-delve/delve/blob/master/Documentation/cli/README.md)
to debug, I recommend using your IDE for this:

* [GoLand / IDEA](https://www.jetbrains.com/help/go/attach-to-running-go-processes-with-debugger.html)
* [Visual Studio Code](https://github.com/golang/vscode-go/blob/master/docs/debugging.md)

Note that because we set `REMOTE_DEBUG_PAUSE_ON_START`, the `main` function will
not be executed until a debug session is connected. This is particularly useful
if you want to debug an application from its first line of execution, however if
you don't need that, feel free to omit that environment variable and the 
application will start normally.

Finally, set some breakpoints and make a request:
```sh
$ curl http://localhost:8080/hello

Hello world!
```

## GoLand/IDEA Run/Debug Configuration

The [`.run`](.run) directory contains a
[run/debug configuration](https://www.jetbrains.com/help/go/run-debug-configuration.html)
which you use for this example.

## References

* https://github.com/go-delve/delve/blob/master/Documentation/faq.md#how-do-i-use-delve-with-docker
* https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_exec.md
* https://www.jetbrains.com/help/go/attach-to-running-go-processes-with-debugger.html#attach-to-a-process-on-a-remote-machine
