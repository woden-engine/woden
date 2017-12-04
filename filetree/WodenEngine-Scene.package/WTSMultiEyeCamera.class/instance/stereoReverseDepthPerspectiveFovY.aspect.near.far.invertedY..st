projections
stereoReverseDepthPerspectiveFovY: fovy aspect: aspect near: near far: far invertedY: invertedY
	| leftEye rightEye fovyRad top focalWidth ipd2 focalDistanceFactor |
	leftEye := eyes first.
	rightEye := eyes second.

	fovyRad := fovy degreesToRadians * 0.5.
	top := near * fovyRad tan.
	
	ipd2 := ipd * 0.5.
	focalWidth := aspect * focalDistance * fovyRad tan.
 	focalDistanceFactor := near / focalDistance.
	
	leftEye
		reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth - ipd2) negated
		right: focalDistanceFactor * (focalWidth + ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
	rightEye 	reverseDepthFrustumLeft: focalDistanceFactor * (focalWidth + ipd2) negated
		right: focalDistanceFactor * (focalWidth - ipd2)
		bottom: top negated top: top near: near far: far invertedY: invertedY.
