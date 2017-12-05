rendering process stages
computeProjectionMatrices
	| camera sensorState |
	camera := view camera.
	headsetDescription
		nearDistance: camera nearDistance;
		farDistance: camera farDistance;
		invertedY: engine projectionInvertedY.
		
	leftProjectionMatrix := headsetDescription leftUndistortedProjection.
	rightProjectionMatrix := headsetDescription rightUndistortedProjection.
	
	vrTransform := WMReversibleAffineTransformF identity.
	engine vrSensorReader ifNotNil: [ :sensor |
		sensorState := sensor sensorState.
		vrTransform orthonormal: sensorState orientation asWMMatrix3F
	].
