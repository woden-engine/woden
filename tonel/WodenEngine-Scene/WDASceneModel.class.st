Class {
	#name : #WDASceneModel,
	#superclass : #WDAModel,
	#instVars : [
		'scene',
		'camera',
		'currentTime'
	],
	#category : 'WodenEngine-Scene-Application'
}

{ #category : #'as yet unclassified' }
WDASceneModel >> buildScene: aBlock [
	self newScene.
	aBlock cull: scene cull: camera
]

{ #category : #accessing }
WDASceneModel >> camera [
	^ camera
]

{ #category : #accessing }
WDASceneModel >> camera: anObject [
	camera := anObject
]

{ #category : #accessing }
WDASceneModel >> currentTime [
	^ currentTime
]

{ #category : #accessing }
WDASceneModel >> currentTime: anObject [
	currentTime := anObject
]

{ #category : #initialization }
WDASceneModel >> initialize [
	super initialize.
	currentTime := 0.0.
]

{ #category : #'instance creation' }
WDASceneModel >> newScene [
	scene := WTSScene for: engine.

	camera := WTSCamera new.
	scene add: camera.
	^ scene
]

{ #category : #accessing }
WDASceneModel >> scene [
	^ scene
]

{ #category : #accessing }
WDASceneModel >> scene: anObject [
	scene := anObject
]

{ #category : #'rendering process stages' }
WDASceneModel >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	currentTime := currentTime + delta
]
