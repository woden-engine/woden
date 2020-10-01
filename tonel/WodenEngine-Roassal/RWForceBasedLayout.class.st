Class {
	#name : #RWForceBasedLayout,
	#superclass : #RWEdgeDrivenLayout,
	#instVars : [
		'alpha',
		'nodes',
		'translator',
		'nbIterations',
		'initialLayout',
		'fixedNodes',
		'strengths',
		'lengths',
		'charges',
		'strength',
		'length',
		'charge',
		'gravity',
		'friction',
		'theta',
		'center',
		'shouldUseProgressBar',
		'weights',
		'oldPositions',
		'random',
		'axisConstraints'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #algorithm }
RWForceBasedLayout >> accumulate: aQuad [
	| cx cy k random |
	cx := 0.
	cy := 0.
	aQuad
		charge: 0;
		cx: 0;
		cy: 0.
	random := Random new.
	aQuad leaf ifFalse: [ 
		aQuad nodes do: [ :e | 
			e isNil ifFalse: [ 
				self accumulate: e.
				aQuad charge: aQuad charge + e charge.
				cx := cx + (e charge * e cx).
				cy := cy + (e charge * e cy) ] ] ].
	aQuad node isNil ifFalse: [ 
		aQuad leaf ifFalse: [ 
			aQuad node translateTo: aQuad node position + 
				((random next - 0.5) @ (random next - 0.5)) ].
		
		k := alpha * (self chargeOf: aQuad node).
		aQuad charge: aQuad charge + k.
		cx := cx + (k * aQuad node position x).
		cy := cy + (k * aQuad node position y) ].
	
	aQuad charge = 0 ifTrue: [ ^ self ].
	aQuad cx: cx / aQuad charge.
	aQuad cy: cy / aQuad charge
]

{ #category : #algorithm }
RWForceBasedLayout >> accumulateChargeOnTree: treeNode [
	| nodeCharge nodeCenter k |
	nodeCharge := 0.0.
	nodeCenter := Float32x3 zero.
	treeNode children do: [ :childNode |
		self accumulateChargeOnTree: childNode.
		nodeCharge := nodeCharge + childNode charge.
		nodeCenter := nodeCenter + (childNode chargeCenter * axisConstraints * nodeCharge)
	].

	treeNode elements do: [ :spatialElement |
		| element |
		element := spatialElement node.
		treeNode isLeaf ifFalse: [
			self halt
		].
	
		k := alpha * (self chargeOf: element).
		nodeCharge := nodeCharge + k.
		nodeCenter := nodeCenter + (element position * axisConstraints * k)
	].

	(nodeCharge closeTo: 0.0) ifFalse: [
		nodeCenter := nodeCenter / nodeCharge
	].

	treeNode
		charge: nodeCharge;
		chargeCenter: nodeCenter.
]

{ #category : #hook }
RWForceBasedLayout >> axisConstraints [
	^ Float32x3 ones
]

{ #category : #accessing }
RWForceBasedLayout >> charge: aFloat [
	"Typically a negative value. E.g., -300"
	charge := aFloat
]

{ #category : #algorithm }
RWForceBasedLayout >> chargeOf: aNode [ 
	^ charges at: aNode ifAbsent: [ ^ charge ] 
]

{ #category : #initialization }
RWForceBasedLayout >> defaultInitialLayout [
	^ RWCubeLayout new
]

{ #category : #hook }
RWForceBasedLayout >> doExecute: nodeElements [
	self start: nodeElements.
	self shouldRunLayoutWithProgressBar
		ifTrue: [ self runLayoutInJob ]
		ifFalse: [ self runLayoutSimply ].
	alpha := 0.
	self centerElements: nodeElements.
]

{ #category : #configuration }
RWForceBasedLayout >> doNotUseProgressBar [
	shouldUseProgressBar := false
]

{ #category : #public }
RWForceBasedLayout >> executeOnElements: elements [ 
	self setEdgesFromElements: elements.
	super executeOnElements: elements
]

{ #category : #accessing }
RWForceBasedLayout >> initialPositionOfNodes: nodeElements [
	initialLayout on: nodeElements
]

{ #category : #initialization }
RWForceBasedLayout >> initialize [
	super initialize.
	nbIterations := 0.
	edges := #().
	nodes := #().
	initialLayout := self defaultInitialLayout.
	fixedNodes := Dictionary new.
	strengths := Dictionary new.
	lengths := Dictionary new.
	charges := Dictionary new.
	strength := 1.0.
	length := 20.0.
	charge := -30.0.
	gravity := 0.1.
	friction := 0.9.
	theta := 0.8.
	center := Float32x3 zero.
	alpha := 0.1.
	random := Random new.
	axisConstraints := self axisConstraints.
	self useProgressBar
]

{ #category : #testing }
RWForceBasedLayout >> isFixed: aNode [

	^ fixedNodes includesKey: aNode 
]

{ #category : #testing }
RWForceBasedLayout >> isJobInstalled [
	"Return true if the class Job exist. This is mainly useful to make a distinction between Pharo and VisualWorks"
	^ Smalltalk globals includesKey: #Job
]

{ #category : #accessing }
RWForceBasedLayout >> length: aFloat [
	^ length
]

{ #category : #algorithm }
RWForceBasedLayout >> lengthOf: anEdge [
	^ lengths at: anEdge ifAbsent: [ ^ length ] 
]

{ #category : #initialization }
RWForceBasedLayout >> prepareNodes: nodeElements [
	"Initialize the meta data associated to the nodes. At that stage, position of nodes is not modified"
	weights := Dictionary new.
	oldPositions := Dictionary new.
	nodes := nodeElements.
	nodes
		do: [ :e | 
			weights add: (Association key: e value: 0).
			oldPositions add: (Association key: e value: e position) ].
	edges
		do: [ :e | 
			| from to |
			from := e from.
			to := e to.
			weights at: from put: (weights at: from) + 1.
			weights at: to put: (weights at: to) + 1 ].
	alpha := 0.1
]

{ #category : #algorithm }
RWForceBasedLayout >> repulse: aNode from: aQuad [
	| dx dy dn k p |
	dx := aQuad cx - aNode position x.
	dy := aQuad cy - aNode position y.
	((dx closeTo: 0) and: [ dy closeTo: 0 ]) ifFalse: [ 
		dn := 1 / (dx * dx + (dy * dy)) sqrt.
		p := oldPositions at: aNode.
		aQuad node ~= aNode ifTrue: [
			(aQuad corner x - aQuad origin x) * dn < theta ifTrue: [ 
				k := aQuad charge * dn * dn.
				oldPositions at: aNode put: (p x - (dx * k)) @ (p y - (dy * k)).
				^ self ].
			(aQuad node isNil not and: [ dn < 1e9 ]) ifTrue: [ 
				k := (self chargeOf: aQuad node) * dn * dn * alpha.
				oldPositions at: aNode put: (p x - (dx * k)) @ (p y - (dy * k)) ] ] ].
	(aQuad charge closeTo: 0) ifFalse: [ 
		aQuad nodes do: [ :e | 
			e isNil ifFalse: [ self repulse: aNode from: e ] ] ]
]

{ #category : #algorithm }
RWForceBasedLayout >> repulseNode: node fromTree: treeNode [
	| delta deltaLength p k treeNodeElement invDeltaLength invDeltaLength2 |
	delta := (treeNode chargeCenter - node position) * axisConstraints.
	deltaLength := delta length.
	(deltaLength closeTo: 0.0) ifFalse: [
		invDeltaLength := deltaLength reciprocal.
		invDeltaLength2 := invDeltaLength*invDeltaLength.
		p := oldPositions at: node.
		self assert: treeNode elements size <= 1. 
		treeNodeElement := treeNode elements
			ifEmpty: [ nil ]
			ifNotEmpty: [ treeNode elements first node ].

		(treeNodeElement ~~ node) ifTrue: [
			(treeNode boundingBox extent * axisConstraints) length * invDeltaLength *2.0 < theta ifTrue: [
				k := treeNode charge * invDeltaLength2.
				oldPositions at: node put: p - (delta *k).
				^ self
			].
			(treeNodeElement isNotNil and: [ invDeltaLength < 1e9 ]) ifTrue: [ 
				k := (self chargeOf: treeNodeElement) * invDeltaLength2 * alpha.
				oldPositions at: node put: p - (delta *k).
			].
		]
	].

	(treeNode charge closeTo: 0.0) ifFalse: [ 
		treeNode children do: [ :child |
			self repulseNode: node fromTree: child
		]
	]
]

{ #category : #hook }
RWForceBasedLayout >> runLayoutInJob [
	[ :job | 
	job
		title: 'Laying out elements';
		min: 1 - alpha;
		max: 1.
	nbIterations = 0
		ifTrue: [ 
			[ 
			alpha := alpha * 0.99.
			alpha > 0.005 ]
				whileTrue: [ 
					self step.
					job currentValue: 1 - alpha ] ]
		ifFalse: [ 
			nbIterations
				timesRepeat: [ 
					alpha := alpha * 0.99.
					self step.
					job currentValue: 1 - alpha ] ] ] asJob run
]

{ #category : #hook }
RWForceBasedLayout >> runLayoutSimply [
	nbIterations = 0
		ifTrue: [ 
			[ 
			alpha := alpha * 0.99.
			alpha > 0.005 ] whileTrue: [ self step ] ]
		ifFalse: [ 
			nbIterations
				timesRepeat: [ 
					alpha := alpha * 0.99.
					self step ] ]
]

{ #category : #configuration }
RWForceBasedLayout >> set: aNode charge: aFloat [ 
	charges at: aNode put: aFloat
]

{ #category : #configuration }
RWForceBasedLayout >> set: anEdge length: aFloat [ 

	lengths at: anEdge put: aFloat
]

{ #category : #configuration }
RWForceBasedLayout >> set: anEdge strength: aFloat [ 

	strengths at: anEdge put: aFloat
]

{ #category : #testing }
RWForceBasedLayout >> shouldRunLayoutWithProgressBar [
	^ self isJobInstalled and: [ self shouldUseProgressBar ]
]

{ #category : #accessing }
RWForceBasedLayout >> shouldUseProgressBar [
	^ shouldUseProgressBar
]

{ #category : #accessing }
RWForceBasedLayout >> start: nodeElements [
	self initialPositionOfNodes: nodeElements.
	self prepareNodes: nodeElements
]

{ #category : #'update cycle' }
RWForceBasedLayout >> step [
	"run a step of the force layout algorithm"
	"If there is no nodes, then there is not much to do"
	nodes ifEmpty: [ ^ self ].
	self stepWeightsStrengths.
	self stepGravity.
	self stepRepulsion.
]

{ #category : #'update cycle' }
RWForceBasedLayout >> stepGravity [
	| k |
	k := alpha * gravity.
	(k closeTo: 0.0) ifTrue: [ ^ self ].
	nodes do: [ :ea | 
		| position |
		position := ea position.
		ea translateTo: position + ((center - position) * axisConstraints * k)
	]
]

{ #category : #'update cycle' }
RWForceBasedLayout >> stepRepulsion [
	| tree |
	tree := RWForceBasedLayoutOctTree forAll: (nodes collect: [:node | RWForceBasedLayoutOctTreeElement new node: node]).
	self accumulateChargeOnTree: tree root.

	nodes do: [ :e | 
		(self isFixed: e) ifFalse: [
			self repulseNode: e fromTree: tree root
		] ifTrue: [ 
			translator translateTopLeftOf: e to: (fixedNodes at: e) ]
	].

	nodes do: [ :e | 
		| newPosition |
		newPosition := e position.
		e translateTo: newPosition - (((oldPositions at: e) - newPosition) * friction).
		oldPositions at: e put: newPosition
	].
	
]

{ #category : #'update cycle' }
RWForceBasedLayout >> stepWeightsStrengths [
	edges do: [ :e |
		| from fromPosition to toPosition vector newLength k vectorLength | 
		from := e from. 
		fromPosition := from position.
		
		to := e to. 
		toPosition := to position.
		
		vector := (toPosition - fromPosition) * axisConstraints.
		vectorLength := vector length.
		(vectorLength closeTo: 0.0) ifFalse: [ 
			newLength :=  alpha * (self strengthOf: e) * ( vectorLength - (self lengthOf: e) ).
			vector := vector normalized * newLength.
			
			k := (weights at: from) / (( weights at: from) +( weights at: to )).
			to translateTo: toPosition - (vector*k).

			k := 1 -  k.
			from translateTo: fromPosition + (vector*k)
		] 
	].
]

{ #category : #accessing }
RWForceBasedLayout >> strength: aFloat [
	"Set the force of attraction for the edges. A high value results in having nodes together.
	The default value is 1.0"
	strength := aFloat
]

{ #category : #algorithm }
RWForceBasedLayout >> strengthOf: anEdge [
	^ strengths at: anEdge ifAbsent: [ ^ strength ] 
]

{ #category : #configuration }
RWForceBasedLayout >> useProgressBar [
	shouldUseProgressBar := true
]
