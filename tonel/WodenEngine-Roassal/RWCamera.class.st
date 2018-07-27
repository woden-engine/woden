Class {
	#name : #RWCamera,
	#superclass : #RWElement,
	#instVars : [
		'frustum'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #initialization }
RWCamera >> createSceneNode [
	^ WDSGCamera new
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

{ #category : #'camera projection' }
RWCamera >> worldRayAtWindowCoordinate: point [
	| ray |
	frustum := self frustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayAtNormalizedPoint: point.
	^ ray transformedWith: sceneNode transform
]
