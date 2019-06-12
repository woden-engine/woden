Class {
	#name : #RWGroup,
	#superclass : #OrderedCollection,
	#instVars : [
		'elementFromModelCache'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #converting }
RWGroup >> @ anInteraction [
	^ self addInteraction: anInteraction
]

{ #category : #adding }
RWGroup >> addInteraction: anInteraction [
	^ self do: [ :el | el @ anInteraction  ]
]

{ #category : #accessing }
RWGroup >> elementFromModel: anObject [
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
		ifTrue: [ 'KeyForNilObjects' ]
		ifFalse: [ anObject ].
	self elementFromModelCache at: key put: t.
	^ t
]

{ #category : #accessing }
RWGroup >> elementFromModelCache [
	"Define a cache for the element lookup from models"
	elementFromModelCache ifNil: [ elementFromModelCache := Dictionary new ].
	^ elementFromModelCache
]
