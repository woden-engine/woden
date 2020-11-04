Class {
	#name : #RWCamera,
	#superclass : #RWElement,
	#instVars : [
		'frustum'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWCamera >> accept: aVisitor [
	^ aVisitor visitCamera: self
]

{ #category : #initialization }
RWCamera >> createSceneNode [
	^ WDSGCamera new
		hasAutoExposure: false;
		yourself
]

{ #category : #accessing }
RWCamera >> distance: aDistance [
	sceneNode focalDistance: aDistance
]

{ #category : #accessing }
RWCamera >> frustum [
	^ sceneNode frustum
]

{ #category : #accessing }
RWCamera >> isPerspective: trueOrFalse [
	sceneNode isPerspective: trueOrFalse
]

{ #category : #accessing }
RWCamera >> projectionMatrix [
	^ sceneNode projectionMatrix
]

{ #category : #'camera projection' }
RWCamera >> worldRayAtWindowCoordinate: point [
	| ray |
	frustum := self frustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayForNormalizedPoint: point.
	^ ray transformedWith: sceneNode globalTransform
]
