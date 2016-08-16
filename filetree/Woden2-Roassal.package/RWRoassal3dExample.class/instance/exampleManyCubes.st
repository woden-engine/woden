sources
exampleManyCubes

| v cubes |
v := RWView new.
cubes := RWCube elementsOn: (1 to: 100).

v addAll: cubes.
RWCubeLayout on: cubes.
^ v