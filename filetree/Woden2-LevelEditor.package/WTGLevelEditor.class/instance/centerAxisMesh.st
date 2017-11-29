accessing
centerAxisMesh
	| start end |
	centerAxisMesh ifNotNil: [ ^ centerAxisMesh ].
	start := -10000.0.
	end := start negated. 
	
	centerAxisMesh := (WTGenericMeshBuilder for: engine)
		material: self gridMaterial;
		beginLines;
		color: Color red;
		addP: (WMVector3F x: start y: 0.0 z: 0.0);
		addP: (WMVector3F x: end y: 0.0 z: 0.0);
		color: Color green;
		addP: (WMVector3F x: 0.0 y: start z: 0.0);
		addP: (WMVector3F x: 0.0 y: end z: 0.0);
		color: Color blue;
		addP: (WMVector3F x: 0.0 y: 0.0 z: start);
		addP: (WMVector3F x: 0.0 y: 0.0 z: end);
		addI1: 1 i2: 2;
		addI1: 3 i2: 4;
		addI1: 5 i2: 6;
		mesh.
	^ centerAxisMesh