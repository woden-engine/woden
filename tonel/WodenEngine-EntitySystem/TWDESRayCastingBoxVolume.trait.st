Trait {
	#name : #TWDESRayCastingBoxVolume,
	#traits : 'TWDESRayCastingVolume',
	#classTraits : 'TWDESRayCastingVolume classTrait',
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
TWDESRayCastingBoxVolume >> boxVolume [
	self explicitRequirement
]

{ #category : #'ray casting' }
TWDESRayCastingBoxVolume >> rayCast: ray [
	| globalTransform boxVolume localRay localIntersectionDistance intersectionDistance localIntersectionPoint intersectionPoint |
	globalTransform := self volumeGlobalTransform.
	boxVolume := self boxVolume.
	localRay := ray transformedWithInverseOf: globalTransform.
	
	localIntersectionDistance := boxVolume intersectionWithRay: localRay.
	localIntersectionDistance ifNil: [ ^ Float infinity -> nil ].
	
	localIntersectionPoint := localRay pointAtDistance: localIntersectionDistance.
	intersectionPoint := globalTransform transformPosition: localIntersectionPoint.
	
	intersectionDistance := intersectionPoint - ray origin dot: ray direction.
	^ intersectionDistance -> self
]

{ #category : #accessing }
TWDESRayCastingBoxVolume >> volumeGlobalTransform [
	self explicitRequirement
]
