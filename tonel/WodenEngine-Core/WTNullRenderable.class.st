Class {
	#name : #WTNullRenderable,
	#superclass : #WTRenderable,
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #rendering }
WTNullRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]

{ #category : #'as yet unclassified' }
WTNullRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	"Do nothing"
]
