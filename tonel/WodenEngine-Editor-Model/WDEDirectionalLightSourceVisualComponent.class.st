Class {
	#name : #WDEDirectionalLightSourceVisualComponent,
	#superclass : #WDELightSourceVisualComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEDirectionalLightSourceVisualComponent >> accept: visitor [
	^ visitor visitDirectionalLightSourceVisualComponent: self
]

{ #category : #testing }
WDEDirectionalLightSourceVisualComponent >> isDirectionalLightSourceVisualComponent [
	^ true
]

{ #category : #'instance creation' }
WDEDirectionalLightSourceVisualComponent >> newGameLightSourceComponent [
	^ WDESDirectionalLightSourceSceneNodeComponent new
]

{ #category : #accessing }
WDEDirectionalLightSourceVisualComponent >> radius [
	^ 1.0
]
