Class {
	#name : #WDASampleSceneModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'deltaTimeBlock'
	],
	#category : #'WodenEngine-Scene-Examples'
}

{ #category : #opening }
WDASampleSceneModel >> defaultViewClass [
	^ WDAFPSSceneView allowingVR
]

{ #category : #enumerating }
WDASampleSceneModel >> onDeltaTimeDo: aBlock [
	deltaTimeBlock := aBlock
]

{ #category : #'rendering process stages' }
WDASampleSceneModel >> updateForFrameDelta: delta [.
	super updateForFrameDelta: delta.
	deltaTimeBlock ifNotNil: [ deltaTimeBlock value: delta ]
]
