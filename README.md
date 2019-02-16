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

## Loading Woden

Woden can be loaded in a Pharo 7 image by running the following script in a
playground:

```smalltalk
Metacello new
   baseline: 'WodenEngine';
   repository: 'github://ronsaldo/woden/tonel';
   load
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
