accessing
cameraTransform
	^ cameraTransform ifNil: [ cameraTransform := cameraTransformFunction value: camera renderTransform ]