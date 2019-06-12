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

{ #category : #hooks }
RWLayout >> doExecute: elements [
	"Performs the layout"

	self subclassResponsibility
]

{ #category : #public }
RWLayout >> doInitialize: elements [
	"Method executed before beginning the layout. Useful when the graph to be ordered need to be prepared"
]

{ #category : #hooks }
RWLayout >> doPost: elements [
	"Method executed after performing the layout"

]

{ #category : #hooks }
RWLayout >> executeOnElements: elements [ 
	"Execute the layout, myself, on the elements"
		
	self doInitialize: elements.
	self doExecute: elements asOrderedCollection.
	self doPost: elements.

]

{ #category : #public }
RWLayout >> on: elements [
	"Override this method to particularize the layout"
	self subclassResponsibility
]
