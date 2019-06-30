"
I am a null renderable.
"
Class {
	#name : #WDCNullRenderable,
	#superclass : #WDCImmutableRenderable,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'as yet unclassified' }
WDCNullRenderable >> createRenderingRenderablesFor: spatialObject [
	^ #().
]

{ #category : #rendering }
WDCNullRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]
