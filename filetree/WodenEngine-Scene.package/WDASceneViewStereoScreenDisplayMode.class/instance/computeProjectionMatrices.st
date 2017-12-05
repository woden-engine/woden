rendering process stages
computeProjectionMatrices
	| camera near far fovy fovyRad top ipd2 aspect focalWidth focalDistanceFactor invertedY target |
	self flag: 'TODO: Support the orthographic projections.'.
	camera := view camera.
	target := view window validResolveRenderTarget.
	aspect := target width asFloat / target height asFloat.
	invertedY := engine projectionInvertedY.
	
	near := camera nearDistance.
	far := camera farDistance.
	fovy := camera fieldOfView.
	
	fovyRad := fovy degreesToRadians * 0.5.
	top := near * fovyRad tan.
	
	ipd2 := ipd * 0.5.
	focalWidth := aspect * focalDistance * fovyRad tan.
 	focalDistanceFactor := near / focalDistance.
	
	leftProjectionMatrix := WMMatrix4F
		reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth - ipd2) negated
		right: focalDistanceFactor * (focalWidth + ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
	rightProjectionMatrix := WMMatrix4F
	 	reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth + ipd2) negated
		right: focalDistanceFactor * (focalWidth - ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
