Class {
	#name : #RWNode,
	#superclass : #RWAnnounceableObject,
	#traits : 'TWDCTransformationManipulationMethods',
	#classTraits : 'TWDCTransformationManipulationMethods classTrait',
	#instVars : [
		'view',
		'parentGroup',
		'sceneNode',
		'localBoundingBox',
		'boundingBox'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #adding }
RWNode >> addedInGroup: aGroup [
	parentGroup := aGroup.

]

{ #category : #adding }
RWNode >> addedInView: aView [
	view := aView.
]

{ #category : #converting }
RWNode >> asPositionRelativeToGroup: targetParentGroup [
	self assert: targetParentGroup isNotNil.
	parentGroup == targetParentGroup ifTrue: [ ^ self position ].
	^ targetParentGroup globalTransform inverseTransformPosition: self globalPosition
]

{ #category : #converting }
RWNode >> asSceneNode [
	^ sceneNode
]

{ #category : #accessing }
RWNode >> boundingBox [
	^ boundingBox ifNil: [boundingBox := self localBoundingBox transformedWith: sceneNode transform ]
]

{ #category : #initialization }
RWNode >> createSceneNode [
	^ WDSGSpatialObject new
]

{ #category : #accessing }
RWNode >> globalPosition [
	^ sceneNode globalTransform translation
]

{ #category : #accessing }
RWNode >> globalTransform [
	^ sceneNode globalTransform
]

{ #category : #initialization }
RWNode >> initialize [
	super initialize.
	sceneNode := self createSceneNode.
]

{ #category : #updating }
RWNode >> invalidateBoundingBoxCache [
	| oldBoundingBox |
	"Cancel propagation if already invalidated."
	(localBoundingBox isNil and: [boundingBox isNil]) ifTrue: [ ^ self ].
	oldBoundingBox := boundingBox.
	localBoundingBox := nil.
	boundingBox := nil.
	parentGroup ifNotNil: [ parentGroup child: self boundingChangedFrom: oldBoundingBox ].
]

{ #category : #accessing }
RWNode >> localBoundingBox [
	self subclassResponsibility
]

{ #category : #accessing }
RWNode >> orientation [
	^ sceneNode transform matrix
]

{ #category : #accessing }
RWNode >> orientation: anOrientation [
	sceneNode transform orthonormal: anOrientation asFloat32x3x3.
	sceneNode transformChanged.
	self transformChanged
]

{ #category : #accessing }
RWNode >> orientationMatrix [
	^ sceneNode transform matrix
]

{ #category : #accessing }
RWNode >> parentGroup [
	^ parentGroup
]

{ #category : #accessing }
RWNode >> position [
	^ sceneNode position
]

{ #category : #accessing }
RWNode >> position: aPosition [
	sceneNode position: aPosition.
	self transformChanged
]

{ #category : #'ray casting' }
RWNode >> rayCast: ray [
	^ Float infinity -> nil
]

{ #category : #'ray casting' }
RWNode >> rayCast: ray satisfying: predicate [
	^ Float infinity -> nil
]

{ #category : #removing }
RWNode >> remove [
	parentGroup ifNotNil: [ parentGroup removeChild: self ]
]

{ #category : #'as yet unclassified' }
RWNode >> removedFromGroup: aGroup [
	parentGroup := nil
]

{ #category : #'as yet unclassified' }
RWNode >> removedFromView: aView [
	view := nil.
	aView signalUpdate.
]

{ #category : #orientation }
RWNode >> rotateByX: angle [
	sceneNode rotateRadiansOnX: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWNode >> rotateByXDegrees: angle [
	sceneNode rotateDegreesOnX: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWNode >> rotateByY: angle [
	sceneNode rotateRadiansOnY: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWNode >> rotateByYDegrees: angle [
	sceneNode rotateDegreesOnY: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWNode >> rotateByZ: angle [
	sceneNode rotateRadiansOnZ: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #orientation }
RWNode >> rotateByZDegrees: angle [
	sceneNode rotateDegreesOnZ: angle.
	self invalidateBoundingBoxCache.
]

{ #category : #translation }
RWNode >> scaleBy: scaleFactor [
	sceneNode scaleBy: scaleFactor.
	self transformChanged.
]

{ #category : #accessing }
RWNode >> transform [
	^ sceneNode transform
]

{ #category : #accessing }
RWNode >> transform: aTransform [
	sceneNode transform: aTransform.
	self transformChanged.
]

{ #category : #accessing }
RWNode >> transformChanged [
	self invalidateBoundingBoxCache.
]

{ #category : #translation }
RWNode >> translateBy: translation [
	sceneNode translateBy: translation.
	self transformChanged.
]

{ #category : #translation }
RWNode >> translateTo: aWMVector3 [
	sceneNode translateTo: aWMVector3.
	self transformChanged.
]

{ #category : #'as yet unclassified' }
RWNode >> validParentSceneNode [
	^ (parentGroup ifNil: [ view ]) asSceneNode
]

{ #category : #accessing }
RWNode >> view [
	^ view
]
