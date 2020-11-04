Class {
	#name : #RWGroup,
	#superclass : #RWNode,
	#instVars : [
		'children'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'instance creation' }
RWGroup class >> withAll: aCollection [
	^ self new addAll: aCollection
]

{ #category : #adding }
RWGroup >> addAll: aCollectionOfElements [
	aCollectionOfElements do: [ :each | self add: each ]
]

{ #category : #adding }
RWGroup >> addChild: aChild [
	children add: aChild.
	aChild addedInGroup: self.
	view ifNotNil: [ aChild addedInView: view ].
]

{ #category : #adding }
RWGroup >> addElement: anElement [
	self assert: anElement isElement.
	children add: anElement.
	anElement addedInGroup: self.
	view ifNotNil: [ anElement addedInView: self ].
]

{ #category : #private }
RWGroup >> addToParentSceneNode: newParentSceneNode [
	newParentSceneNode addChild: sceneNode.
]

{ #category : #adding }
RWGroup >> addedInGroup: aGroup [
	super addedInGroup: aGroup.
	parentGroup ifNil: [ self addToParentSceneNode: aGroup asSceneNode ].
]

{ #category : #adding }
RWGroup >> addedInView: aView [
	super addedInView: aView.
	parentGroup ifNil: [ self addToParentSceneNode: view asSceneNode ].
	children do: [ :each | each addedInView: aView ].

]

{ #category : #enumerating }
RWGroup >> allElementsDo: aBlock [
	children do: aBlock
]

{ #category : #updating }
RWGroup >> changed [
	children do: [ :each | each changed ]
]

{ #category : #'as yet unclassified' }
RWGroup >> child: child boundingChangedFrom: oldBoundingBox [
	self invalidateBoundingBoxCache.
]

{ #category : #accessing }
RWGroup >> children [
	^ children
]

{ #category : #accessing }
RWGroup >> computeLocalBoundingBox [
	| result |
	result := BoxF32 empty.
	children do: [ :each | result insertBox: each boundingBox ].
	^ result
]

{ #category : #'as yet unclassified' }
RWGroup >> ifEmpty: aBlock [
	^ children ifEmpty: aBlock
]

{ #category : #'as yet unclassified' }
RWGroup >> ifNotEmpty: aBlock [
	^ children ifNotEmpty: aBlock
]

{ #category : #initialization }
RWGroup >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
RWGroup >> isEmpty [
	^ children isEmpty
]

{ #category : #'as yet unclassified' }
RWGroup >> isNotEmpty [
	^ children isNotEmpty
]

{ #category : #accessing }
RWGroup >> localBoundingBox [
	^ localBoundingBox ifNil: [ localBoundingBox := self computeLocalBoundingBox ]
]

{ #category : #'ray casting' }
RWGroup >> rayCast: ray [
	| bestDistance bestResult distanceResult distance result worldBoundingBox transformedRay |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ 0 -> nil ].
	
	distance := worldBoundingBox intersectionWithRay: ray.
	(distance isNil or: [distance <= 0]) ifTrue: [ ^ Float infinity -> nil ].
	
	transformedRay := ray transformedWithInverseOf: self transform.

	bestDistance := Float infinity.
	bestResult := nil.
	children do: [ :element |
		distanceResult := element rayCast: transformedRay.
		distance := distanceResult key.
		result := distanceResult value.
		(result notNil and: [ distance < bestDistance ]) ifTrue: [ 
			bestDistance := distance.
			bestResult := result.
		]
	].

	^ bestDistance -> bestResult.
]

{ #category : #'ray casting' }
RWGroup >> rayCast: ray satisfying: predicate [
	| bestDistance bestResult distanceResult distance result worldBoundingBox transformedRay |
	worldBoundingBox := self boundingBox.
	worldBoundingBox isEmpty ifTrue: [ ^ 0 -> nil ].
	
	distance := worldBoundingBox intersectionWithRay: ray.
	(distance isNil or: [distance <= 0]) ifTrue: [ ^ Float infinity -> nil ].
	
	transformedRay := ray transformedWithInverseOf: self transform.
	
	bestDistance := Float infinity.
	bestResult := nil.
	children do: [ :group |
		distanceResult := group rayCast: transformedRay satisfying: predicate.
		distance := distanceResult key.
		result := distanceResult value.
		(result notNil and: [ distance < bestDistance ]) ifTrue: [ 
			bestDistance := distance.
			bestResult := result.
		]
	].

	^ bestDistance -> bestResult.
]

{ #category : #removing }
RWGroup >> remove [
	parentGroup ifNil: [
		view ifNotNil: [view removeGroup: self]
	] ifNotNil: [
		parentGroup removeChild: self
	]
]

{ #category : #private }
RWGroup >> removeFromScene [
	sceneNode removeFromScene
]

{ #category : #'as yet unclassified' }
RWGroup >> removedFromView: aView [
	children do: [ :each | each removedFromView: aView ].
	parentGroup ifNil: [ self removeFromScene ].
	super removedFromView: aView.

]

{ #category : #'as yet unclassified' }
RWGroup >> size [
	^ children size
]
