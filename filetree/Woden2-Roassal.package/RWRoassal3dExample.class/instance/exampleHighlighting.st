sources
exampleHighlighting
	| v es |
	v := RWView new.
	es := ((RWCube new size: 1)) elementsOn: (1 to: 16).

	es @ (RWHighlightable highlight: [ :vv | | arr |
		
		arr := OrderedCollection new.
		arr add: vv - 1.
		arr add: vv.
		arr add: vv + 1.
		arr add: vv - 4.
		arr add: vv + 4.
		arr]).

	RWXYGridLayout on: es.
	v addAll: es.
^	 v