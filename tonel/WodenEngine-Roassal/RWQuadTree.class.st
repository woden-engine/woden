Class {
	#name : #RWQuadTree,
	#superclass : #RWObject,
	#instVars : [
		'corner',
		'origin',
		'leaf',
		'x',
		'y',
		'node',
		'nodes',
		'charge',
		'cx',
		'cy'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #'instance creation' }
RWQuadTree class >> withAll: aNodeCollection [
	| min max |
	min := Float fmax asPoint.
	max := Float fmin asPoint.

	aNodeCollection do: [ :e | | p |
		p := e position.
		min := min min: p.
		max := max max: p ].
	^ self 
		withAll: aNodeCollection 
		origin: min
		corner: max
		
	

]

{ #category : #'instance creation' }
RWQuadTree class >> withAll: aNodeCollection origin: aPoint corner: anotherPoint [

	| dx dy root |
	dx := anotherPoint x - aPoint x.
	dy := anotherPoint y - aPoint y.
	(dx closeTo: dy ) ifTrue: [ 
		root := self new.
		root 
			origin: aPoint;
			corner: anotherPoint;
			addAll: aNodeCollection.
		^ root ] .
	^ self
		withAll: aNodeCollection
		origin: aPoint
		corner: (dx > dy
			ifTrue: [ anotherPoint x @ (aPoint y + dx) ]
			ifFalse: [(aPoint x + dy) @ anotherPoint y  ]  ).
	
]

{ #category : #adding }
RWQuadTree >> add: aNode [
	| n |
	leaf ifTrue: [ 
		x isNil ifFalse: [ 
			(x - aNode position x) abs + (y - aNode position y) abs < 0.01
				ifTrue: [ self addChild: aNode ]
				ifFalse: [ 
					n := node.
					x := nil.
					y := nil.
					node := nil.
					self
						addChild: aNode;
						addChild: n ] ]
		ifTrue: [ 
			x := aNode position x.
			y := aNode position y.
			node := aNode ] ]
	ifFalse: [ self addChild: aNode ]
]

{ #category : #adding }
RWQuadTree >> addAll: aCollection [
	aCollection do: [ :n | self add: n ].
]

{ #category : #adding }
RWQuadTree >> addChild: aNode [
	| sx sy new clazz|
	sx := (origin x + corner x) / 2.
	sy := (origin y + corner y) / 2.
	leaf := false.
	clazz := self class.
	aNode position x < sx
		ifTrue: [ aNode position y < sy
				ifTrue: [ (nodes at: 1) isNil
						ifTrue: [ new := clazz new.
							new
								origin: origin;
								corner: sx @ sy.
							nodes at: 1 put: new ].
					(nodes at: 1) add: aNode ]
				ifFalse: [ (nodes at: 3) isNil
						ifTrue: [ new := clazz new.
							new
								origin: origin x @ sy;
								corner: sx @ corner y.
							nodes at: 3 put: new ].
					(nodes at: 3) add: aNode ] ]
		ifFalse: [ aNode position y < sy
				ifTrue: [ (nodes at: 2) isNil
						ifTrue: [ new := clazz new.
							new
								origin: sx @ origin y;
								corner: corner x @ sy.
							nodes at: 2 put: new ].
					(nodes at: 2) add: aNode ]
				ifFalse: [ (nodes at: 4) isNil
						ifTrue: [ new := clazz new.
							new
								origin: sx @ sy;
								corner: corner.
							nodes at: 4 put: new ].
					(nodes at: 4) add: aNode ] ]
]

{ #category : #accessing }
RWQuadTree >> charge [
	^ charge
]

{ #category : #accessing }
RWQuadTree >> charge: anObject [
	charge := anObject
]

{ #category : #accessing }
RWQuadTree >> corner [
	^ corner
]

{ #category : #accessing }
RWQuadTree >> corner: anObject [
	corner := anObject
]

{ #category : #accessing }
RWQuadTree >> cx [
	^ cx
]

{ #category : #accessing }
RWQuadTree >> cx: aFloat [
	cx := aFloat
]

{ #category : #accessing }
RWQuadTree >> cy [
	^ cy
]

{ #category : #accessing }
RWQuadTree >> cy: aFloat [
	cy := aFloat
]

{ #category : #initialization }
RWQuadTree >> initialize [
	super initialize.
	leaf := true.
	nodes := Array new: 4.
]

{ #category : #accessing }
RWQuadTree >> leaf [
	^ leaf
]

{ #category : #accessing }
RWQuadTree >> node [
	^ node
]

{ #category : #accessing }
RWQuadTree >> nodes [
	^ nodes
]

{ #category : #accessing }
RWQuadTree >> origin [
	^ origin
]

{ #category : #accessing }
RWQuadTree >> origin: anObject [
	origin := anObject
]
