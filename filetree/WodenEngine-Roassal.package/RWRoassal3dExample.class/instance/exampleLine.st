sources
exampleLine

| es v |

v := RWView new.
es := RWCube elementsOn: (1 to: 20).
v addAll: es.
RWCircleLayout on: es.
es @ RWPopup.

2 to: 20 do: [ :i |  
	v add: (RWLine edgeFrom: (v elementFromModel: i) to: (v elementFromModel: 1))
].

^	 v