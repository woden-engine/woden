Class {
	#name : #WDEVisualComponent3D,
	#superclass : #WDEVisualComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #testing }
WDEVisualComponent3D class >> isAbstract [
	^ self == WDEVisualComponent3D
]

{ #category : #testing }
WDEVisualComponent3D >> canBeUsedForSubtraction [
	^ self polyhedronEnclosingPlanes isNotEmpty
]

{ #category : #testing }
WDEVisualComponent3D >> isVisualComponent3D [
	^ true
]
