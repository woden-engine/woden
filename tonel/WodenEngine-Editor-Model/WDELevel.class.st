Class {
	#name : #WDELevel,
	#superclass : #WDELevelElement,
	#instVars : [
		'sectors',
		'announcer'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #requirements }
WDELevel class >> empty [
	^ self new
		addSector: (WDESector new
			name: 'Sector';
				addLayer: (WDESectorLayer new
					name: 'Layer';
					yourself);
			yourself);
		yourself
]

{ #category : #visiting }
WDELevel >> accept: visitor [
	^ visitor visitLevel: self
]

{ #category : #adding }
WDELevel >> addSector: aSector [
	self assert: aSector level isNil.
	sectors add: aSector.
	aSector level: self.
	aSector addedToLevel: self.
]

{ #category : #'ray casting' }
WDELevel >> allEntitiesDo: aBlock [
	self sectors do: [ :eachSector |
		eachSector layers do: [ :eachLayer |
			eachLayer entities do: aBlock
		].
	].

]

{ #category : #'as yet unclassified' }
WDELevel >> announceAddedElement: anElement [
	announcer announce: (WDEAddedElementAnnouncement new element: anElement)
]

{ #category : #'as yet unclassified' }
WDELevel >> announceRemovedElement: anElement [
	announcer announce: (WDERemovedElementAnnouncement new element: anElement)
]

{ #category : #accessing }
WDELevel >> announcer [
	^ announcer
]

{ #category : #accessing }
WDELevel >> children [
	^ sectors
]

{ #category : #'ray casting' }
WDELevel >> elementsInFrustum: frustum [
	| result |
	result := OrderedCollection new.
	self allEntitiesDo: [ :eachEntity |
		(eachEntity intersectsFrustum: frustum) ifTrue: [
			result add: eachEntity
		]
	].
	^ result asArray
]

{ #category : #initialization }
WDELevel >> initialize [
	super initialize.
	sectors := OrderedCollection new.
	announcer := Announcer new.
]

{ #category : #testing }
WDELevel >> isLevel [
	^ true
]

{ #category : #accessing }
WDELevel >> level [
	^ self
]

{ #category : #'instance creation' }
WDELevel >> newEditorSession [
	^ WDELevelEditorSession new level: self; yourself
]

{ #category : #'ray casting' }
WDELevel >> rayCast: ray [
	| bestResult |
	bestResult := nil.
	self allEntitiesDo: [ :eachEntity |
		| newResult |
		newResult := eachEntity rayCast: ray.
		newResult ifNotNil: [
			(bestResult isNil or: [ newResult < bestResult ]) ifTrue: [ 
				bestResult := newResult
			].
		].
	].
	^ bestResult
]

{ #category : #accessing }
WDELevel >> sectors [
	^ sectors
]

{ #category : #'as yet unclassified' }
WDELevel >> whenAddedElementDo: aBlock [
	^ announcer when: WDEAddedElementAnnouncement do: [ :ann | aBlock cull: ann element ]
]

{ #category : #'as yet unclassified' }
WDELevel >> whenRemovedElementDo: aBlock [
	^ announcer when: WDERemovedElementAnnouncement do: [ :ann | aBlock cull: ann element ]
]
