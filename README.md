just testing some things out...


## init submodule
```sh
# don't do it this way.. github doesn't do HTTPS auth - we have to use SSH.  So if we add the submodule this way, we can't push any changes we may make.  This isn't important for other people building my service... but it's important for me
# git submodule add https://github.com/PlebeiusGaragicus/plebtools plebtools
git submodule add git@github.com:PlebeiusGaragicus/plebtools.git plebtools
git submodule update --init --recursive
```

---





# Wrapper for hello-world

Hello World is a simple, minimal project that serves as a template for creating a service that runs on embassyOS. This repository creates the `s9pk` package that is installed to run `hello-world` on [embassyOS](https://github.com/Start9Labs/embassy-os/). Learn more about service packaging in the [Developer Docs](https://start9.com/latest/developer-docs/).

## Dependencies

Install the system dependencies below to build this project by following the instructions in the provided links. You can also find detailed steps to setup your environment in the service packaging [documentation](https://github.com/Start9Labs/service-pipeline#development-environment).

- [docker](https://docs.docker.com/get-docker)
- [docker-buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [yq](https://mikefarah.gitbook.io/yq)
- [deno](https://deno.land/)
- [make](https://www.gnu.org/software/make/)
- [embassy-sdk](https://github.com/Start9Labs/embassy-os/tree/master/backend)

## Build environment
Prepare your embassyOS build environment - I have customized this flow for MacOS
1. Install docker desktop

2. Set buildx as the default builder
```
docker buildx install
docker buildx create --use
```

3. Enable cross-arch emulated builds in docker
```
docker run --privileged --rm linuxkit/binfmt:v0.8
```

4. Install yq
```
brew install yq
```

5. Install deno
```
brew install deno
```

6. Install essentials build packages
```
# I didn't do this step
# brew install build-essential openssl libssl-dev libc6-dev clang libclang-dev ca-certificates
```

7. Install Rust
```
brew install rust
```

8. Build and install embassy-sdk
```
cd ~/ && git clone --recursive https://github.com/Start9Labs/embassy-os.git
cd embassy-os/backend/
./install-sdk.sh
embassy-sdk init
```

Now you are ready to build the `hello-world` package!

## Cloning

Clone the project locally:

```

git submodule update --init --recursive
```

## Building

To build the `hello-world` package for all platforms using embassy-sdk version >=0.3.3, run the following command:

```
make
```

To build the `hello-world` package for a single platform using embassy-sdk version <=0.3.2, run:

```
# for amd64
make ARCH=x86_64
```
or
```
# for arm64
make ARCH=aarch64
```

## Installing (on embassyOS)

Run the following commands to determine successful install:
> :information_source: Change embassy-server-name.local to your Embassy address

```
embassy-cli auth login
# Enter your embassy password
embassy-cli --host https://embassy-server-name.local package install hello-world.s9pk
```

If you already have your `embassy-cli` config file setup with a default `host`, you can install simply by running:

```
make install
```

> **Tip:** You can also install the hello-world.s9pk using **Sideload Service** under the **System > Manage** section.

### Verify Install

Go to your Embassy Services page, select **Hello World**, configure and start the service. Then, verify its interfaces are accessible.

**Done!** 
