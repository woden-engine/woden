private
intersectFace: f1 with: f2 with: f3
	| p1 p2 p3 pos index |
	"Compute the intersection between the planes"
	p1 := f1 plane.
	p2 := f2 plane.
	p3 := f3 plane.
	pos := p1 intersect: p2 intersect: p3.
	pos ifNil: [ ^ self ].
	
	"Add the index"
	index := self addPosition: (self roundPosition: pos).
	f1 addIndex: index.
	f2 addIndex: index.
	f3 addIndex: index.