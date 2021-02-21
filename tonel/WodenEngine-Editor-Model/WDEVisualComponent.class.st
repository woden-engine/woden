Class {
	#name : #WDEVisualComponent,
	#superclass : #WDEEntityComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> box: box [
	^ WDEBoxVisualComponent new
		box: box;
		yourself
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> directionalLight [
	^ WDEDirectionalLightSourceVisualComponent new
]

{ #category : #testing }
WDEVisualComponent class >> isAbstract [
	^ self == WDEVisualComponent
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> pointLight [
	^ WDEPointLightSourceVisualComponent new
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> rectangle: rectangle [
	^ WDERectangleVisualComponent new
		rectangle: rectangle;
		yourself
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> spotLight [
	^ WDESpotLightSourceVisualComponent new
]

{ #category : #accessing }
WDEVisualComponent >> boundingBox [
	^ self subclassResponsibility
]

{ #category : #testing }
WDEVisualComponent >> isVisualComponent [
	^ true
]
