Class {
	#name : #RWCamera,
	#superclass : #RWElement,
	#instVars : [
		'frustum'
	],
	#category : 'Woden2-Roassal-Core'
}

{ #category : #initialization }
RWCamera >> createSceneNode [
	^ WTSCamera new
]

{ #category : #accessing }
RWCamera >> frustum [
	^ frustum
]

{ #category : #initialization }
RWCamera >> initialize [
	super initialize.
	frustum := WMFrustumF new.
]

{ #category : #'camera projection' }
RWCamera >> updateProjectionWithAspectRatio: aspectRatio [
	| engine |
	engine := sceneNode scene engine.
	frustum reverseDepthPerspectiveFovY: 60.0 aspect: aspectRatio near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.
	sceneNode state 
		projectionMatrix: frustum matrix.
]

{ #category : #'camera projection' }
RWCamera >> worldRayAtWindowCoordinate: point [
	| ray |
	ray := frustum rayAtNormalizedPoint: point.
	^ ray transformedWith: sceneNode transform
]
