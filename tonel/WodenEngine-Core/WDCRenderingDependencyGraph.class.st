Class {
	#name : #WDCRenderingDependencyGraph,
	#superclass : #Object,
	#instVars : [
		'nodes',
		'sortedNodes'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #adding }
WDCRenderingDependencyGraph >> addNode: aNode [
	(nodes includes: aNode) ifTrue: [ ^ self ].
	
	nodes add: aNode.
	sortedNodes := nil.
	aNode addRenderingElementsToGraph: self
]

{ #category : #adding }
WDCRenderingDependencyGraph >> addNodes: aCollectionOfNode [
	aCollectionOfNode do: [ :node | self addNode: node ]
]

{ #category : #initialization }
WDCRenderingDependencyGraph >> initialize [
	super initialize.
	nodes := IdentitySet new.
	
]

{ #category : #initialization }
WDCRenderingDependencyGraph >> sortNodesStartingFrom: node visitedSet: visitedSet [
	"Topological sort algorithm main loop."
	(visitedSet includes: node) ifTrue: [
		^ self
	].

	visitedSet add: node.
	node renderingGraphDependencies do: [ :dep |
		self sortNodesStartingFrom: dep visitedSet: visitedSet.		
	].

	sortedNodes add: node
]

{ #category : #initialization }
WDCRenderingDependencyGraph >> sortedNodes [
	"Topological sort"
	| visitedSet |
	sortedNodes ifNotNil: [ ^ sortedNodes ].
	
	sortedNodes := OrderedCollection new.
	visitedSet := IdentitySet new.
	nodes do: [ :node |
		self sortNodesStartingFrom: node visitedSet: visitedSet
	].

	^ sortedNodes
]

{ #category : #initialization }
WDCRenderingDependencyGraph >> sortedNodesDo: aBlock [
	^ self sortedNodes do: aBlock
]
