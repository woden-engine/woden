intersection
intersectWithSegment: startPoint end: endPoint
	| startFront endFront n dir den t|
	startFront := self isInFront: startPoint.
	endFront := self isInFront: endPoint.
	"Check for the existence of the intersection."
	startFront = endFront ifTrue: [ ^ nil ].
	
	dir := endPoint - startPoint.
	n := self normal.
	den := dir dot: self normal.
	(den closeTo: 0) ifTrue: [ ^ nil ].
	t := (self distance - (startPoint dot: self normal)) / den .
	^ startPoint + (dir * t)
	
