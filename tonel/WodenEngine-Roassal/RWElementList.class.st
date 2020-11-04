Class {
	#name : #RWElementList,
	#superclass : #OrderedCollection,
	#instVars : [
		'elementFromModelCache'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #converting }
RWElementList >> @ anInteraction [
	^ self addInteraction: anInteraction
]

{ #category : #adding }
RWElementList >> addInteraction: anInteraction [
	^ self do: [ :el | el @ anInteraction  ]
]

{ #category : #converting }
RWElementList >> asRWElementList [
	^ self
]

{ #category : #accessing }
RWElementList >> elementFromModel: anObject [
	"Return an element that corresponds to the object provided as parameter. If none is found, then return nil"
	
	| t key|
	self elementFromModelCache 
		at: anObject 
		ifPresent: [ :v | v isCollection ifFalse: [ ^ v ] ].

	"We have this line because of a bug of the implementation of CompiledMethod>>#="
	t := (anObject class == CompiledMethod) 
		ifTrue: [ [ :el | el model == anObject ] ]
		ifFalse: [ [ :el | el model = anObject ] ].
	t :=  self detect: t ifNone: [ nil ].
	
	"We have this hack for nil objects because in visualWorks a dictionary cannot have nil as a key"
	key := anObject isNil 
		ifTrue: [ #KeyForNilObjects ]
		ifFalse: [ anObject ].
	self elementFromModelCache at: key put: t.
	^ t
]

{ #category : #accessing }
RWElementList >> elementFromModelCache [
	"Define a cache for the element lookup from models"
	elementFromModelCache ifNil: [ elementFromModelCache := Dictionary new ].
	^ elementFromModelCache
]

{ #category : #accessing }
RWElementList >> elementFromModelCache: anObject [
	elementFromModelCache := anObject
]
