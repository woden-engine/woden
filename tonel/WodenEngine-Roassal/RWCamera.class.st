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
	^ WTSCamera new
]

{ #category : #accessing }
RWCamera >> frustum [
	^ sceneNode frustum
]

{ #category : #'camera projection' }
RWCamera >> worldRayAtWindowCoordinate: point [
	| ray |
	frustum := self frustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayAtNormalizedPoint: point.
	^ ray transformedWith: sceneNode transform
]
