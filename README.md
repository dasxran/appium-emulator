# Docker Container with Android Emulator & Appium

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-info-blue.svg)](https://hub.docker.com/r/dasxran/appium-emulator/)
[![Docker Stars](https://img.shields.io/docker/stars/dasxran/appium-emulator.svg)](https://hub.docker.com/r/dasxran/appium-emulator/)
[![Docker Pulls](https://img.shields.io/docker/pulls/dasxran/appium-emulator.svg)](https://hub.docker.com/r/dasxran/appium-emulator/)

[![Docker Badge](https://dockeri.co/image/dasxran/appium-emulator)](https://hub.docker.com/r/dasxran/appium-emulator)

### Why do we need containerized Android Emulator and Appium at first place?

- Helps in quick & easier setup of automation environment for Appium + Android
- Multiple Appium Server along with dedicated Emulator can be deployed quickly
- Individual container's Appium endpoint can be mapped to automation test suite 
- ARM build emulator can be deployed to cloud VM without additional dependency

### Images Included:

This image contains Appium Server with configured AVD (Android Virtual Device x86/arm).

- appium-emulator/appium - Docker Image contains standalone Appium Server 1.22.0.
- appium-emulator/emulator - Contains Appium along with Android Emulator x86 build (android-28/google_apis_playstore/x86)
- appium-emulator/arm25 - Contains Appium along with Android Emulator arm build (android-25/google_apis/armeabi-v7a)

### How to Build:
```bash
$ cd emulator/x86
$ docker build -t appium-emulator .
```

## Supported tags and respective `Dockerfile` links

- [`x86_28`, `latest` (*/emulator/x86/Dockerfile*)](https://github.com/dasxran/appium-emulator/blob/main/emulator/x86/Dockerfile)
- [`arm_25` (*/emulator/arm/Dockerfile*)](https://github.com/dasxran/appium-emulator/blob/main/emulator/arm/Dockerfile)

## Examples

* Basic usage

```bash
# x86 build: runs 10x faster with CPU virtualization in Linux platform
docker run -it --rm --name my_avd --device /dev/kvm dasxran/appium-emulator

# ARM build: runs slower but supported in any platform (Windows/Linux/OSX)
docker run -it --rm --name my_avd dasxran/appium-emulator:arm25

# Use ADB to interact with virtual device
docker exec -it my_avd adb shell
```

* Remote ADB connection

```bash
docker run -it --rm --device /dev/kvm -p 5554:5554 -p 5555:5555 dasxran/appium-emulator

# Connect local ADB process to AVD (not required if both are on localhost)
adb connect IP_OF_AVD_CONTAINER_OR_HOST

# Use ADB to interact with virtual device
adb shell
```


## Interact with AVD via Remote GUI
* To connect the emulator using `adb` on the docker host machine, start the container with `--network host` or with -p 5555:5555.
  You could use [`scrcpy`](https://github.com/Genymobile/scrcpy) to do a screencast of the emulator.

```bash
# Connect local ADB process to AVD (not required if both are on localhost)
adb connect IP_OF_AVD_CONTAINER_OR_HOST:5555

scrcpy --tcpip=IP_OF_AVD_CONTAINER_OR_HOST       # default port is 5555
```

**Installed Packages - x86**
```bash
# sdkmanager --list
  Path                                        | Version | Description                                | Location
  -------                                     | ------- | -------                                    | -------
  build-tools;31.0.0                          | 31.0.0  | Android SDK Build-Tools 31.0.0             | build-tools/31.0.0/
  cmdline-tools;latest                        | 2.1     | Android SDK Command-line Tools (latest)    | cmdline-tools/latest/
  emulator                                    | 30.1.5  | Android Emulator                           | emulator/
  patcher;v4                                  | 1       | SDK Patch Applier v4                       | patcher/v4/
  platform-tools                              | 30.0.4  | Android SDK Platform-Tools                 | platform-tools/
  platforms;android-28                        | 2       | Android SDK Platform 28                    | platforms/android-28/
  system-images;android-28;google_apis;x86_64 | 26      | Google APIs Intel x86 Atom_64 System Image | system-images/android-28/google_apis/x86_64/
```

**Installed Packages - arm**
```bash
# sdkmanager --list
  Path                                        | Version | Description                                | Location
  -------                                     | ------- | -------                                    | -------
  build-tools;31.0.0                          | 31.0.0  | Android SDK Build-Tools 30.0.2             | build-tools/31.0.0/
  cmdline-tools;latest                        | 2.1     | Android SDK Command-line Tools (latest)    | cmdline-tools/latest/
  emulator                                    | 30.1.5  | Android Emulator                           | emulator/
  patcher;v4                                  | 1       | SDK Patch Applier v4                       | patcher/v4/
  platform-tools                              | 30.0.4  | Android SDK Platform-Tools                 | platform-tools/
  platforms;android-25                        | 2       | Android SDK Platform 25                    | platforms/android-25/
  system-images;android-25;google_apis;armv7a | 26      | Google APIs Intel x86 Atom_64 System Image | system-images/android-25/google_apis/armv7a/
```

----

Note: `--device /dev/kvm` flag is required to enable CPU hardware acceleration.
You may also need to activate `kvm` kernel module on your host machine: `modprobe kvm`, or even install it first.

## Test Execution using Robot Framework

For more details, please refer to [Test section](https://github.com/dasxran/appium-emulator/blob/main/robot_test/test_file.robot).

<img src="https://github.com/dasxran/appium-emulator/blob/main/robot_test/results/appium-screenshot-1.png?raw=true" width="200">


References:
---------------
- https://github.com/google/android-emulator-container-scripts/blob/master/REGISTRY.MD
- https://github.com/budtmo/docker-android
- https://github.com/thyrlian/AndroidSDK

LICENSE
--------------
See [License](LICENSE)
