Class {
	#name : #RWAnnounceableObject,
	#superclass : #RWObject,
	#instVars : [
		'attributes',
		'announcer'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWAnnounceableObject >> announcer [
	^ announcer
]

{ #category : #attributes }
RWAnnounceableObject >> attributeAt: aKey [
	^ self attributes at: aKey
]

{ #category : #attributes }
RWAnnounceableObject >> attributeAt: aKey ifAbsent: aBlockClosure [ 
	
	^ self attributes at: aKey ifAbsent: aBlockClosure 
]

{ #category : #attributes }
RWAnnounceableObject >> attributeAt: aKey ifAbsentPut: aBlockClosure [ 
	
	^ self attributes at: aKey ifAbsentPut: aBlockClosure 
]

{ #category : #attributes }
RWAnnounceableObject >> attributeAt: aKey put: value [
	^ self attributes at: aKey put: value
]

{ #category : #attributes }
RWAnnounceableObject >> attributes [
	"Return the list of attributes associated to the element. Attributes are useful for caching values"

	^ attributes ifNil: [ attributes := Dictionary new ]
]

{ #category : #attributes }
RWAnnounceableObject >> hasAttribute: aKey [ 
	"Return true if attributes includes aKey"
	
	^ attributes notNil and: [ attributes includesKey: aKey ]
]

{ #category : #attributes }
RWAnnounceableObject >> hasAttributes [ 
	"Return true if at least one attributes is present"
	
	^ attributes notNil and: [ attributes notEmpty ]
]

{ #category : #testing }
RWAnnounceableObject >> hasInteraction: anInteractionClass [
	self announcer subscriptions ifNil: [ ^ false ].
	
	^ self announcer subscriptions handleSubscriberClass: anInteractionClass
]

{ #category : #initialization }
RWAnnounceableObject >> initialize [
	super initialize.
	announcer := Announcer new.
	
]

{ #category : #interaction }
RWAnnounceableObject >> on: anEvent do: aBlock [
	self deprecated: 'Please use when:do: instead of on:do'.
	self when: anEvent do: aBlock.
]

{ #category : #attributes }
RWAnnounceableObject >> removeAttributeAt: aKey [
	^ self attributes removeKey: aKey
]

{ #category : #attributes }
RWAnnounceableObject >> removeAttributeAt: aKey ifAbsent: anErrorBlock [
	^ self attributes removeKey: aKey ifAbsent: anErrorBlock
]

{ #category : #interaction }
RWAnnounceableObject >> when: anEvent do: aBlock [
	"Register a callback"
	announcer when: anEvent do: aBlock
]
