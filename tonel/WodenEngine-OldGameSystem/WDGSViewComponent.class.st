Class {
	#name : #WDGSViewComponent,
	#superclass : #WDGSComponent,
	#instVars : [
		'view',
		'camera'
	],
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #serialization }
WDGSViewComponent class >> jsonTypeName [
	^ 'view'
]

{ #category : #converting }
WDGSViewComponent >> asJsonData [
	^ #()
]

{ #category : #accessing }
WDGSViewComponent >> bucket [
	^ #view
]

{ #category : #'map events' }
WDGSViewComponent >> createCamera [
	| cameraComponent |
	cameraComponent := entity ensureSceneNodeOfType: WDSGCamera.
	view camera: cameraComponent node
]

{ #category : #'map events' }
WDGSViewComponent >> spawn [
	super spawn.
	self createCamera
]

{ #category : #accessing }
WDGSViewComponent >> view [
	^ view
]

{ #category : #accessing }
WDGSViewComponent >> view: anObject [
	view := anObject
]
