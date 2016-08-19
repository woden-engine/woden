transformation
transformedWithInverseOf: transform
	^ self class origin: (transform inverseTransformPosition3: origin) direction: (transform inverseTransformVector3: direction)