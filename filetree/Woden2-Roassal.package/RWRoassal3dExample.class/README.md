RWRoassal3dExample new installTitle: 'MatrixHandling' 
		code:
		'
| v es |
v := RWView new.
es := RWCube elementsOn: (1 to: 10).
v addAll: es.
RWCubeLayout on: es.

es when: RWMouseButtonDown do: [ :evt |
        | node |
        node := evt element sceneNode.
          node shapeMatrix: (WDMatrix4 scale: 1.1) * (node shapeMatrix )
         ].

^	 v'
	