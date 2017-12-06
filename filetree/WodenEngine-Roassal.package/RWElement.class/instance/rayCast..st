ray casting
rayCast: ray
	| worldBoundingBox distance |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ 0 -> nil ].
	
	distance := ray intersectionDistanceWithBox: worldBoundingBox.
	(distance isNil or: [distance < 0]) ifTrue: [ ^ distance -> nil ].
	^ distance -> self.