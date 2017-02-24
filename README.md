# Woden2 - World Dynamic Engine 2

## Requirements

### Lowcode Virtual Machine

Woden 2 depends on native libraries and a modified Pharo Virtual Machine with
an additional bytecode instruction set called Lowcode, which allows to perform
C style low level operations with pointer and primitive types inline with normal
Pharo code.

The Lowcode instructions are used in Woden 2 with an extended OpalCompiler.
This instructions are used to implement C style structures with a fixed and
known memory layout. These structures that can be efficiently copied into the GPU
dedicated memory.

This repository contains scripts for downloading automatically the required VM,
however they allow to choose a VM that was built manually by using the
useVM.sh script. The usage of this script is explained in a separate section.

### Native libraries

Woden 2 depends on two native libraries: AbstractGPU and AbstractPhysics. The
AbstractGPU is an abstraction layer above low-level graphics APIs such as
Vulkan, Metal and Direct3D 12. The AbstractPhysics is an abstraction layer
for physical simulation libraries such as Bullet physics.

These native libraries can be downloaded and be built automatically with the
buildDependencies{32,64}.sh scripts, which are called by the loadWoden2.sh
script. However, before being able to build these libraries, some
dependencies are required:

* A C and C++ compiler that works.
* CMake. Callable from the command line.
* Vulkan development libraries.

#### OSX Requirements

In OS X you should install CMake using Homebrew, so that it can be called from
the command line.

As a special remark for OS X, because Vulkan is not available
in OS X, Metal is required. However, Metal only works in 64 bits applications.
Because of this, on OS X, the Woden 2 scripts use a 64 bits VM, and a 64 bits
image. As the time of writing this documentation, the 64 bits version of Pharo
is far more unstable than the 32 bits version of Pharo. There are several
glitches in the image, but it still seems to work quite well.

#### Ubuntu Requirements

In Ubuntu 16.10, it should be enough to install the dependencies using apt-get install:

```bash
sudo apt-get install build-essential
sudo apt-get install cmake libvulkan-dev libx11-dev libx11-xcb-dev
```

In 64 bits Ubuntu 16.10, it should be enough to install the dependencies using apt-get install:

```bash
sudo apt-get install build-essential gcc-multilib g++-multilib
sudo apt-get install cmake libvulkan-dev libx11-dev libx11-xcb-dev libvulkan-dev:i386 libx11-dev:i386 libx11-xcb-dev:i386
```

## Loading Woden 2
### The mostly easy way

The easy way to load Woden 2 consists in executing the following bash scripts:

```bash
git clone https://github.com/ronsaldo/woden2.git
cd woden 2
./loadWoden2.sh
```

The loadWoden2.sh should take of dowloading and building all of the dependencies.
It will also load a Pharo or Pharo 64 (on OS X) image with Woden 2. The process
of loading an image with Woden 2 can ask to load or merge some packages, specially
the latest version of the UnifiedFFI. When facing that dialog, the "Load" option
must be selected. When the image has been completely loaded with Woden 2, it will
save into woden2.image, and quit. If the loading process was successful, you should
receive in the terminal a message telling that it was complete.

Sometimes the image loading process fails with the VM crashing. In this case, you
should run the loadWoden2Image.sh script for just retrying the image loading
process without having to download or rebuild the dependencies.

Once the image loading process is complete,  you can run the Woden 2 image with
the following command:

```bash
./woden2.sh woden2.image
```

### Selecting another VM

Another VM can be selected to use with Woden 2 instead of the default Release VM
with Lowcode. The alternate VM can selected with the useVM.sh script. The useVM.sh
script has only one required parameter, which is the path of the VM executable or
launch script.

```bash
./useVM.sh AnotherPharoVM/pharo
```

The useVM.sh script creates the woden2.sh script that is used for launching a Woden 2 image.
The loadWoden2.sh does not download a VM if the woden2.sh script already exists.

### Using a different base image instead of the default.

The loadWoden2.sh and the loadWoden2Image.sh script have an optional parameter, which
allows to specify a different base image than the default Pharo image. This could
be used for loading Woden 2 into a Moose image. WARNING: this is untested and not supported yet.

```bash
./loadWoden2.sh Moose.image
```

## Woden 2 samples

For testing Woden 2, the following samples can be executed in a playground:

```smalltalk
WTFPSSampleApplicationCube new openInOSWindow.
WTFPSSampleApplicationTexturedCube new openInOSWindow.
WTFPSSampleApplicationFloor new openInOSWindow.
WTFPSSampleApplicationPool new openInOSWindow.
WTFPSSampleApplicationDangerousPool new openInOSWindow.

WTAthensSampleApplicationShapes new openInOSWindow.
WTAthensSampleApplicationGradients new openInOSWindow.
```

## Bug reporting

For bug reporting, use the GitHub issue tracker at the Woden 2 repository https://github.com/ronsaldo/woden2

## Known issues

These are known issues with Woden 2. We are working on fixing some of them:

* The Linux NVIDIA Vulkan driver is crashing when building the Pipeline State Objects.
* The RADV open source Vulkan driver is hanging the GPU when tested in a AMD Southern Island GPU (AMD HD 7770).
* We have not tested the AMDGPU Pro Vulkan driver on Linux.

# About Windows

Because Windows does not use Bash, and we have not yet updated the Lowcode VM
building scripts for Windows, the Woden 2 support for Windows will have to wait.
I still have to learn Windows PowerShell to be able to make an easy to load
version of Woden 2.
