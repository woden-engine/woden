as yet unclassified
someEdges
"
self new someEdges
"

| v els |
v := RWView new.

els := RWCube blue elementsOn: (1 to: 10).
v addAll: els.

RWXZGridLayout on: els.

1 to: 10 do: [ :i |
	1 to: 10 do: [ :j |
		i ~~ j ifTrue: [ v add: (RWLine green edgeFrom: (els at: i) to: (els at: j))]
	].
].

v addInteraction: RWMouseKeyControl.
v open.
