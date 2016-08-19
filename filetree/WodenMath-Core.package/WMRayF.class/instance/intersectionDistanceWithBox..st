intersection
intersectionDistanceWithBox: box
	<argument: #box type: #(WMBox3DF object)>
	"Algorithm taken from paper An Efficient and Robust Ray–Box Intersection Algorithm. Written by A. Williams et al. Available at: http://www.cs.utah.edu/~awilliam/box/"
	| txmin txmax tymin tymax tzmin tzmax |
	txmin := ((box boundsAtSign: signs x) x - (origin x)) * invertedDirection x.
	txmax := ((box boundsAtSign: 1 - signs x) x - (origin x)) * invertedDirection x.
	tymin := ((box boundsAtSign: signs y) y - (origin y)) * invertedDirection y.
	tymax := ((box boundsAtSign: 1 - signs y) y - (origin y)) * invertedDirection y.
	
	(txmin > tymax or: [ tymin > txmax ]) ifTrue: [ ^ nil ].
	tymin > txmin ifTrue: [ txmin := tymin ].
	tymax < txmax ifTrue: [ txmax := tymax ].
	
	tzmin := ((box boundsAtSign: signs z) z - (origin z)) * invertedDirection z.
	tzmax := ((box boundsAtSign: 1 - signs z) z - (origin z)) * invertedDirection z.
	
	(txmin > tzmax or: [ tzmin > txmax ]) ifTrue: [ ^ nil ].
	tzmin > txmin ifTrue: [ txmin := tzmin ].
	tzmax < txmax ifTrue: [ txmax := tzmax ].
	
	^ txmax > 0.0 ifTrue: [ txmin ] ifFalse: [ nil ].
	