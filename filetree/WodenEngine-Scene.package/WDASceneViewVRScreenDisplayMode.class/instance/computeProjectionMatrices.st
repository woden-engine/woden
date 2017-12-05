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
	
	headsetOrientation := WMMatrix3F identity.
	headsetTranslation := WMVector3F new.
	engine vrSensorReader ifNotNil: [ :sensor |
		sensorState := sensor sensorState.
		headsetOrientation := sensorState orientation asWMMatrix3F
	].
