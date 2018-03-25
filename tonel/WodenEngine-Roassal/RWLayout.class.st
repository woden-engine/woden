Class {
	#name : #RWLayout,
	#superclass : #Object,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #public }
RWLayout class >> on: elements [
	"Execute the layout on the given set of elements"
	^ self new on: elements
]

{ #category : #public }
RWLayout class >> on: elements edges: edges [
	"Execute the layout on the given set of elements and edges"
	^ self new on: elements edges: edges.
]

{ #category : #protected }
RWLayout >> centerElements: elements [
	RWMove centerElements: elements
]

{ #category : #public }
RWLayout >> on: elements [
	"Override this method to particularize the layout"
	self subclassResponsibility
]

{ #category : #public }
RWLayout >> on: elements edges: edges [
	"Override this method to particularize the layout"
	self subclassResponsibility
]
