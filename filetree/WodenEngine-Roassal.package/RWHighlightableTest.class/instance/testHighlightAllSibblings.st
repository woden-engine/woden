tests
testHighlightAllSibblings

	| v e1 e2 e3 |
	v := RWView new.
	e1 := (RWCube new color: Color gray) elementOn: 1.
	e2 := (RWUVSphere new color: Color gray) elementOn: 1.
	e3 := (RWCube new color: Color gray) elementOn: 2.
	
	v add: e1; add: e2; add: e3.
	
	e1 @ RWHighlightable allSibblings.
	self assert: (e1 shape colorFor: e1) = Color gray.
	self assert: (e2 shape colorFor: e2) = Color gray.
	self assert: (e3 shape colorFor: e3) = Color gray.
	
	e1 announce: RWMouseEnter.
	self assert: (e1 shape colorFor: e1) ~= Color gray.
	self assert: (e2 shape colorFor: e2) ~= Color gray.
	self assert: (e3 shape colorFor: e3) = Color gray.