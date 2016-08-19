transformation
transformedWith: transform
	^ self class origin: (transform transformPosition3: origin) direction: (transform transformVector3: direction)