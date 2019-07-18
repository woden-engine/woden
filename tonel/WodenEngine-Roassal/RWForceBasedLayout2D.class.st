"
A basic force layout for 3d elements
"
Class {
	#name : #RWForceBasedLayout2D,
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
		'oldPositions'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #algorithm }
RWForceBasedLayout2D >> accumulate: aQuad [
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

{ #category : #accessing }
RWForceBasedLayout2D >> charge: aFloat [
	"Typically a negative value. E.g., -300"
	charge := aFloat
]

{ #category : #algorithm }
RWForceBasedLayout2D >> chargeOf: aNode [ 
	^ charges at: aNode ifAbsent: [ ^ charge ] 
]

{ #category : #initialization }
RWForceBasedLayout2D >> defaultInitialLayout [
	^ RWXYGridLayout new
]

{ #category : #hook }
RWForceBasedLayout2D >> doExecute: nodeElements [
	self start: nodeElements.
	self shouldRunLayoutWithProgressBar
		ifTrue: [ self runLayoutInJob ]
		ifFalse: [ self runLayoutSimply ].
	alpha := 0.
	self centerElements: nodeElements.
]

{ #category : #configuration }
RWForceBasedLayout2D >> doNotUseProgressBar [
	shouldUseProgressBar := false
]

{ #category : #public }
RWForceBasedLayout2D >> executeOnElements: elements [ 
	self setEdgesFromElements: elements.
	super executeOnElements: elements
]

{ #category : #accessing }
RWForceBasedLayout2D >> initialPositionOfNodes: nodeElements [
	initialLayout on: nodeElements
]

{ #category : #initialization }
RWForceBasedLayout2D >> initialize [
	super initialize.
	nbIterations := 0.
	edges := #().
	nodes := #().
	initialLayout := self defaultInitialLayout.
	fixedNodes := Dictionary new.
	strengths := Dictionary new.
	lengths := Dictionary new.
	charges := Dictionary new.
	strength := 1.
	length := 20.
	charge := -30.
	gravity := 0.1.
	friction := 0.9.
	theta := 0.8.
	center := WMVector3F zero.
	alpha := 0.1.
	self useProgressBar
]

{ #category : #testing }
RWForceBasedLayout2D >> isFixed: aNode [

	^ fixedNodes includesKey: aNode 
]

{ #category : #testing }
RWForceBasedLayout2D >> isJobInstalled [
	"Return true if the class Job exist. This is mainly useful to make a distinction between Pharo and VisualWorks"
	^ Smalltalk globals includesKey: #Job
]

{ #category : #accessing }
RWForceBasedLayout2D >> length: aFloat [
	^ length
]

{ #category : #algorithm }
RWForceBasedLayout2D >> lengthOf: anEdge [
	^ lengths at: anEdge ifAbsent: [ ^ length ] 
]

{ #category : #initialization }
RWForceBasedLayout2D >> prepareNodes: nodeElements [
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
RWForceBasedLayout2D >> repulse: aNode from: aQuad [
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

{ #category : #hook }
RWForceBasedLayout2D >> runLayoutInJob [
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
RWForceBasedLayout2D >> runLayoutSimply [
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
RWForceBasedLayout2D >> set: aNode charge: aFloat [ 
	charges at: aNode put: aFloat
]

{ #category : #configuration }
RWForceBasedLayout2D >> set: anEdge length: aFloat [ 

	lengths at: anEdge put: aFloat
]

{ #category : #configuration }
RWForceBasedLayout2D >> set: anEdge strength: aFloat [ 

	strengths at: anEdge put: aFloat
]

{ #category : #testing }
RWForceBasedLayout2D >> shouldRunLayoutWithProgressBar [
	^ self isJobInstalled and: [ self shouldUseProgressBar ]
]

{ #category : #accessing }
RWForceBasedLayout2D >> shouldUseProgressBar [
	^ shouldUseProgressBar
]

{ #category : #accessing }
RWForceBasedLayout2D >> start: nodeElements [
	self initialPositionOfNodes: nodeElements.
	self prepareNodes: nodeElements
]

{ #category : #'update cycle' }
RWForceBasedLayout2D >> step [
	"run a step of the force layout algorithm"
	"If there is no nodes, then there is not much to do"
	nodes ifEmpty: [ ^ self ].
	self stepWeightsStrengths.
	self stepGravity.
	self stepQuadTree.
	
]

{ #category : #'update cycle' }
RWForceBasedLayout2D >> stepGravity [
	| k x y z |
	k := alpha * gravity.
	(k closeTo: 0) ifTrue: [ ^ self ].
	x := center x.
	y := center y.
	z := center z.
	nodes do: [ :ea | 
		| pos |
		pos := ea position.
		ea translateTo: (WMVector3F
			x: pos x + ((x - pos x) * k)
			y: pos y + ((y - pos y) * k) 
			z: pos z + ((z - pos z) * k) ) ]
]

{ #category : #'update cycle' }
RWForceBasedLayout2D >> stepQuadTree [
	| quad old |
	quad := RWQuadTree withAll: nodes.
	self accumulate: quad.
	nodes do: [ :e | 
		(self isFixed: e) ifFalse: [ self repulse: e from: quad ]
		ifTrue: [ 
			translator translateTopLeftOf: e to: (fixedNodes at: e) ] ].

	nodes do: [ :e | 
		old := e position.
		e translateTo: (WMVector3F 
			x: (old x - (( (oldPositions at: e) x - old x ) * friction))
			y: (old y - (( (oldPositions at: e) y - old y ) * friction))
			z: 0 ).
		oldPositions at: e put: old.].
	
]

{ #category : #'update cycle' }
RWForceBasedLayout2D >> stepWeightsStrengths [
	edges do: [ :e |
		| from fp to tp x y z len k | 
		from := e from. 
		fp := from position.
		to := e to. 
		tp := to position.
		x := tp x - fp x.
		y := tp y - fp y.
		z := tp z - fp z. 
		len := ((x * x) + (y * y) + (z * z)) sqrt.
		(len closeTo: 0) ifFalse: [ 
			len :=  alpha * (self strengthOf: e) * ( len - (self lengthOf: e) ) / len.
			x := x * len.
			y := y * len.
			z := z * len.
			k := (weights at: from) / (( weights at: from) +( weights at: to )).
			to translateTo: (WMVector3F 
				x: tp x - (x * k) 
				y: tp y - (y * k) 
				z: tp z - (z * k)).
			k := 1 -  k.
			from translateTo: (WMVector3F 
				x: fp x + (x * k) 
				y: fp y + (y * k) 
				z: tp z + (z * k) )  ] 
	].
]

{ #category : #accessing }
RWForceBasedLayout2D >> strength: aFloat [
	"Set the force of attraction for the edges. A high value results in having nodes together.
	The default value is 1.0"
	strength := aFloat
]

{ #category : #algorithm }
RWForceBasedLayout2D >> strengthOf: anEdge [
	^ strengths at: anEdge ifAbsent: [ ^ strength ] 
]

{ #category : #configuration }
RWForceBasedLayout2D >> useProgressBar [
	shouldUseProgressBar := true
]
