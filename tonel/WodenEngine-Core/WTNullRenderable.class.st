Class {
	#name : #WTNullRenderable,
	#superclass : #WTRenderable,
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #'extra per object rendering data' }
WTNullRenderable >> createSceneDependentDataFor: engine into: objectStateBindings [
	^ nil
]

{ #category : #rendering }
WTNullRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]

{ #category : #'as yet unclassified' }
WTNullRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]
