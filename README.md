# Woden - World Dynamic Engine
### A 3D graphics engine for Pharo

## Requirements

### 3D Graphics Card
Woden communicates with the 3D graphics via the abstract-gpu abstraction layer.

#### Windows and Linux

Woden on windows requires a modern graphics card with support for at least one
of the following two graphics APIs:
* Vulkan
* OpenGL 4.5

#### OS X

Woden on OS X requires a Mac with support for the Metal API.

### Native libraries

The native has a dependency on some native libraries. These native libraries are
being built on CI (Travis, Appveyor), and deployed into bintray. The
fetchAndLoadWoden.py Python script takes care of downloading the latest version
of these native libraries.

### Dependencies for loading Woden manually

For loading a Woden image manually by using the Python script, the following
dependencies are required:
* Python 2.7
* Git

## Loading Woden

The easy way to load Woden 2 consists in executing the fetchAndLoadWoden.py python scripty. On Linux and OS X, this script can be executed by running the following in bash:

```bash
./fetchAndLoadWoden.py
```

On Windows the Python script can be executed by double clicking on
fetchAndLoadWoden.py, after having Python 2.7 and Git installed. For the script
succeed, git must be available in the local user PATH environment variable (i.e:
you must be able to call git by just writing git in the command line).

The fetchAndLoadWoden.py script will take care of downloading all of the
dependencies that are used by Woden, the Pharo VM, the Pharo image, the Pharo
source. After downloading the required dependencies, this script will take of
loading a clean Pharo image with Woden, which will be saved as woden.image

```bash
./woden.sh woden.image
```

## Woden samples

For checking the Woden samples, you should check the class side of WDASceneExamples
for some examples, or you can just run the following script for blue window:

```smalltalk
model := WDAModel new.
model openWith: (WDASolidColorViewSample new color: Color blue)
```

## Bug reporting

For bug reporting, use the GitHub issue tracker at the Woden repository https://github.com/ronsaldo/woden
