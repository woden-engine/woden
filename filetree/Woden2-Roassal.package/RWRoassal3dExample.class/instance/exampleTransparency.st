sources
exampleTransparency

| v els shape |
"Additive blending"
v := RWView new.
shape := RWCube new color: (WDColor gray).
els := shape elementsOn: (1 to: 10).
v addAll: els.

shape := RWCube new translucent color: (WDColor red a: 0.5).
els := shape elementsOn: (11 to: 20).
v addAll: els.

RWCubeLayout on: els.
v addInteraction: RWMouseKeyControl.
^	 v