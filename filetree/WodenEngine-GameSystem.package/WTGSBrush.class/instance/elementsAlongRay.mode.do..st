selection
elementsAlongRay: ray mode: mode do: aBlock
	| distance intersectionPoint result bestDistance |
	(ray intersectionDistanceWithBox: boundingBox) ifNil: [ ^ self ].
	bestDistance := nil.
	
	faces do: [ :face |
		distance := ray intersectionDistanceWithPlane: face plane.
		distance ifNotNil: [
			intersectionPoint := ray pointAtDistance: distance.
			(intersectionPoint isNotNil and: [self isPoint: intersectionPoint behindOtherFaces: face]) ifTrue: [
				mode == #face ifTrue: [
					result := ray testResultForDistance: distance value: face.
					aBlock value: result
				] ifFalse: [
					(bestDistance isNil or: [ bestDistance > distance ]) ifTrue: [
						bestDistance := distance
					]
				]
			]
		]
	].

	bestDistance ifNotNil: [
		result := ray testResultForDistance: bestDistance value: self.
		aBlock value: result.
	]