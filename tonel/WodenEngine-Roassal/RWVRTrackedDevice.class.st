Class {
	#name : #RWVRTrackedDevice,
	#superclass : #WDCVREventHandler,
	#instVars : [
		'deviceHandle',
		'shape',
		'sceneView'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'instance creation' }
RWVRTrackedDevice class >> for: sceneView device: aTrackedDevice [
	^ self new deviceHandle: aTrackedDevice; addToSceneView: sceneView; yourself
]

{ #category : #adding }
RWVRTrackedDevice >> addToSceneView: anSceneView [
	sceneView := anSceneView.
	self addToView: sceneView model.
]

{ #category : #adding }
RWVRTrackedDevice >> addToView: aView [
	"Hook for connecting with a view."
]

{ #category : #accessing }
RWVRTrackedDevice >> deviceHandle [
	^ deviceHandle
]

{ #category : #accessing }
RWVRTrackedDevice >> deviceHandle: anObject [
	deviceHandle := anObject.
	deviceHandle eventHandler: self.
]

{ #category : #accessing }
RWVRTrackedDevice >> transform: newTransform [
	self transformChanged
]

{ #category : #accessing }
RWVRTrackedDevice >> transformChanged [
]

{ #category : #'rendering process stages' }
RWVRTrackedDevice >> updateForFrameDelta: delta [
]
