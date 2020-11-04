Class {
	#name : #RWObject,
	#superclass : #Object,
	#traits : 'TRWObject',
	#classTraits : 'TRWObject classTrait',
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #adding }
RWObject >> addConnectedEdge: edge [
	"By default do nothing"
]

{ #category : #testing }
RWObject >> isRWObject [
	^ true
]
