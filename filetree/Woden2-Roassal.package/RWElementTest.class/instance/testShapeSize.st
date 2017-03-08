tests
testShapeSize

	| el |
	shape := RWCube new 
					width: [ :e | e + 1 ];
					height: [ :e | e + 2 ];
					depth: [ :e | e + 3 ].
					
	el := shape elementOn: 5.

	self assert: el extent = (WMVector3F x: 6.0 y: 7.0 z: 8.0)