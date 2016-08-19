transforming
transformedWith: transformation
	^ self class
		halfExtent: (transformation transformVector3: self halfExtent)
		center: (transformation transformPosition3: self center)