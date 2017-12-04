rendering
sendTouchEvents
	| firstBox secondBox |
	self flag: 'Use a proper no always O(n^2) algorithm, or use the physics engine for this'.
	touchListeners do: [ :a |		
		firstBox := a boundingBox.
		touchListeners do: [ :b |
			a ~~ b ifTrue: [
 				secondBox := b boundingBox.
				(firstBox intersectsOrContainsBox: secondBox) ifTrue: [
					a touch: b.
					b touch: a
				] 
			]
		]
	]