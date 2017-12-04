adding
computeFrameIndex: frame actionBone: actionBone repeated: repeated
	| result |
	result := repeated
		ifTrue: [ frame % actionBone keyframes size ]
		ifFalse: [ frame min: actionBone keyframes size - 1 max: 0 ].
	^ result + 1