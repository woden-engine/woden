rendering
convertWMTransform: transform
	^ APHYTransform new
		rotation: (self convertWMMatrix3: transform matrix);
		origin: (self convertWMVector3: transform translation);
		yourself