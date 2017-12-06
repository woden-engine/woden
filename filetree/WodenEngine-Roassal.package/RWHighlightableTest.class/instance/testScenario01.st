tests
testScenario01

	| v es originalColor |

	v := RWView new.
	originalColor := Color white.
	es := ((RWCube new size: 1; color: originalColor)) elementsOn: (1 to: 16).

	RWCubeLayout on: es.
	v addAll: es.

	RWHighlightable new doHighlightElement: es first.
	
	self deny: (es second hasAttribute: #originalColor).
	RWHighlightable new doHighlightElement: es second.
	
	self assert: (es second attributes at: #originalColor) b equals: 1.0.
	RWHighlightable new doUnhighlightElement: es first.
	
	self assert: (es second attributes at: #originalColor) b equals: 1.0.
	RWHighlightable new doUnhighlightElement: es second.
	
	self assert: es second attributes size equals: 0