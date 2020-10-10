Class {
	#name : #WDEVisualComponent3D,
	#superclass : #WDEVisualComponent,
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #testing }
WDEVisualComponent3D class >> isAbstract [
	^ self == WDEVisualComponent3D
]

{ #category : #testing }
WDEVisualComponent3D >> isVisualComponent3D [
	^ true
]
