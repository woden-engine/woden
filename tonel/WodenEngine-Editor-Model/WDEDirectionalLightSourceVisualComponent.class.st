Class {
	#name : #WDEDirectionalLightSourceVisualComponent,
	#superclass : #WDELightSourceVisualComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEDirectionalLightSourceVisualComponent >> accept: visitor [
	^ visitor visitDirectionalLightSourceVisualComponent: self
]

{ #category : #accessing }
WDEDirectionalLightSourceVisualComponent >> radius [
	^ 1.0
]
