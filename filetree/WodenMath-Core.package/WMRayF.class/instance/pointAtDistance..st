evaluating
pointAtDistance: distance
	(distance isNil or: [distance < 0.0]) ifTrue: [ ^ nil ].
	^ origin + (direction * distance)