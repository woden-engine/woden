Class {
	#name : #RWElementAnchorPoint,
	#superclass : #RWObject,
	#instVars : [
		'element'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'instance creation' }
RWElementAnchorPoint class >> for: anElement [
	^ self new element: anElement
]

{ #category : #adding }
RWElementAnchorPoint >> addConnectedEdge: anEdge [
	element addConnectedEdge: anEdge
]

{ #category : #accessing }
RWElementAnchorPoint >> element [
	^ element
]

{ #category : #accessing }
RWElementAnchorPoint >> element: anObject [
	element := anObject
]

{ #category : #accessing }
RWElementAnchorPoint >> position [
	self subclassResponsibility
]
