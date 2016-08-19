window points
localPoint: aPosition atDistance: depth
	| nearPoint farPoint |
	nearPoint := self nearNormalizedPoint: aPosition.
	farPoint := self farNormalizedPoint: aPosition.
	^ self lerp: nearPoint end: farPoint alpha: depth