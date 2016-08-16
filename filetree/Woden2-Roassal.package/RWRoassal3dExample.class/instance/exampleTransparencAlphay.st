sources
exampleTransparencAlphay

| v els shape |
"Alpha over transparency"

v := RWView new.
shape := RWCube new alphaOverTranslucent color: (WDColor red a: 0.8).
els := shape elementsOn: (1 to: 20).
v addAll: els.
RWCubeLayout on: els.
v addInteraction: RWMouseKeyControl.
^	 v