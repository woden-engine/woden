Class {
	#name : #WDCNullRenderable,
	#superclass : #WDCRenderable,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'extra per object rendering data' }
WDCNullRenderable >> createSceneDependentDataFor: engine into: objectStateBindings [
	^ nil
]

{ #category : #rendering }
WDCNullRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]

{ #category : #'as yet unclassified' }
WDCNullRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]
