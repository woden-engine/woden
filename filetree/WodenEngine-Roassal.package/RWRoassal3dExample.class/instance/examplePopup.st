sources
examplePopup

| v es shape |
v := RWView new.

shape := RWCube new color: [ :m | Color random ].
es := shape elementsOn: (1 to: 100).
RWCubeLayout on: es.
v addAll: es.

es do: [ :e | e addInteraction: RWPopup ].

^	 v