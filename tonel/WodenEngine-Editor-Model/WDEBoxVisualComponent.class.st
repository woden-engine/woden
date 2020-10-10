Class {
	#name : #WDEBoxVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDEBoxVisualComponent >> accept: visitor [
	^ visitor visitBoxVisualComponent: self
]
