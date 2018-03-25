Class {
	#name : #RWTreeLayout,
	#superclass : #RWLayout,
	#instVars : [
		'gap',
		'nodes',
		'edges',
		'parents',
		'children',
		'roots',
		'subtreeBounds'
	],
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #configuration }
RWTreeLayout class >> defaultGap [
	^ 1.0
]

{ #category : #private }
RWTreeLayout >> addChild: child to: parent [
	| collection |
	collection := children at: parent ifAbsent: [ collection := OrderedCollection new. children at: parent put: collection ].
	collection add: child
]

{ #category : #private }
RWTreeLayout >> addHeight: nextHeight to: aNode [
	self addHeight: nextHeight toNodes: (self childrenFor: aNode)
]

{ #category : #private }
RWTreeLayout >> addHeight: nextHeight toNodes: nextNodes [
	| childrenHeight newHeight |
	childrenHeight := self computeBoundingHeightFor: nextNodes.
	newHeight := nextHeight - childrenHeight - 1.0.
	nextNodes do: [ :node | node translateToY: nextHeight . self addHeight: newHeight to: node	]
]

{ #category : #private }
RWTreeLayout >> addParent: parent for: child [
	parents at: child put: parent
]

{ #category : #private }
RWTreeLayout >> buildConnectivity [
	edges do: [ :edge |
		self addChild: edge to to: edge from.
		self addParent: edge from for: edge to.
	]
	
]

{ #category : #private }
RWTreeLayout >> buildGraph [
	self buildConnectivity.
	self extractRoots.
]

{ #category : #private }
RWTreeLayout >> childrenFor: anElement [
	^ children at: anElement ifAbsent: [ ^#() ]
]

{ #category : #private }
RWTreeLayout >> computeBoundingHeightFor: nodeCollection [
	| height |
	height := 0.0.
	nodeCollection do: [ :node | height := node height max: height ].
	^ height
]

{ #category : #private }
RWTreeLayout >> computeHeights [
	self addHeight: 0.0 toNodes: roots.
]

{ #category : #private }
RWTreeLayout >> computeSubtreeBounds: subtreeRoot [
	| bounds childBounds rootBounds childrenNodes w d pos |
	bounds := nil.
	childrenNodes := self childrenFor: subtreeRoot.
	childrenNodes do: [ :cn | 
		childBounds := self subtreeBounds: cn.
		bounds ifNil: [ bounds := childBounds ] ifNotNil: [ bounds := bounds merge: childBounds ]
	].

	w := subtreeRoot width.
	d := subtreeRoot depth.
	pos := subtreeRoot position.
	rootBounds := (w negated + pos x @ d negated + pos z) rectangle: (w + pos x @ d + pos z).
	bounds ifNil: [ bounds := rootBounds ]
			ifNotNil: [ bounds := bounds merge: (Rectangle center: bounds center extent: rootBounds extent) ].
	
	^ bounds.
]

{ #category : #private }
RWTreeLayout >> distributeHorizontally [
	self distributeNodesHorizontally: roots
]

{ #category : #private }
RWTreeLayout >> distributeNodesHorizontally: nodeCollection [
	| bounds |
	nodeCollection ifEmpty: [ ^ self ].
	nodeCollection do: [ :node | self distributeNodesHorizontally: (self childrenFor: node)].
	bounds := nodeCollection collect: [ :node | self subtreeBounds:  node ].
	self distributeSubtreeNodes: nodeCollection withBounds: bounds

]

{ #category : #protected }
RWTreeLayout >> distributeSubtreeNodes: subtreeNodes withBounds: bounds [
	self subclassResponsibility
	
]

{ #category : #private }
RWTreeLayout >> extractRoots [
	roots := nodes select: [ :n | (self parentFor: n) isNil ]
]

{ #category : #public }
RWTreeLayout >> gap [
	^ gap
]

{ #category : #public }
RWTreeLayout >> gap: aNumber [
	gap := aNumber
]

{ #category : #public }
RWTreeLayout >> initialize [
	super initialize.
	children := IdentityDictionary new.
	parents := IdentityDictionary new.
	subtreeBounds := IdentityDictionary new.
	gap := self class defaultGap 
]

{ #category : #public }
RWTreeLayout >> on: allElements [
	self on: (allElements select: [ :e | e isEdge not] )
		edges: (allElements select: [ :e | e isEdge] )
]

{ #category : #public }
RWTreeLayout >> on: nodeCollection edges: edgeCollection [
	nodes := nodeCollection.
	edges := edgeCollection.
	self buildGraph.
	self computeHeights.
	self distributeHorizontally
]

{ #category : #private }
RWTreeLayout >> parentFor: anElement [
	^ parents at: anElement ifAbsent: [ ^ nil ]
]

{ #category : #protected }
RWTreeLayout >> subtreeBounds:  subtreeRoot [
	^ self computeSubtreeBounds: subtreeRoot
"	| bounds |
	^ subtreeBounds at: subtreeRoot 
		ifAbsent: [ bounds := self computeSubtreeBounds: subtreeRoot.
			subtreeBounds at: subtreeRoot put: bounds.
			^ bounds ]"
]

{ #category : #protected }
RWTreeLayout >> translate: translation subtree: subtreeRoot [
	| childrenNodes |
	childrenNodes := self childrenFor: subtreeRoot.
	childrenNodes do: [ :cn |
		cn translateBy: translation.
		self translate: translation subtree: cn
	]
]
