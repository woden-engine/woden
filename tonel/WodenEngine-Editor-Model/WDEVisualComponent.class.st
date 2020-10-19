Class {
	#name : #WDEVisualComponent,
	#superclass : #WDEEntityComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> box: box color: color [
	^ WDEBoxVisualComponent new
		box: box;
		color: color;
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
WDEVisualComponent class >> rectangle: rectangle color: color [
	^ WDERectangleVisualComponent new
		rectangle: rectangle;
		color: color;
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
