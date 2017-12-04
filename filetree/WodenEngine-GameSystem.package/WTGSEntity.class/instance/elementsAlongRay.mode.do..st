selection
elementsAlongRay: ray mode: mode do: aBlock
	| models distance result localRay spatialDescription |
	localRay := ray.
	spatialDescription := self spatialDescription.
	spatialDescription ifNotNil: [ 
		localRay := ray transformedWithInverseOf: spatialDescription transform.
	].

	(mode == #entity and: [ worldEntity not ]) ifTrue: [
		distance := localRay intersectionDistanceWithBox: self localBoundingBox.
		distance ifNil: [ ^ self ].
		result := ray testResultForDistance: distance value: self.
		^ aBlock value: result
	].

	models := components at: #modeling ifAbsent: [ ^ self ].
	models do: [ :model | model elementsAlongRay: localRay mode: mode do: aBlock ]