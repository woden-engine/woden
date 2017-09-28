as yet unclassified
computeUndistortedParameters
	| eyeToScreenDistance halfLensDistance screenWidth screenHeight eyePositionX eyePositionY viewerMaxDistance outerDistance innerDistance bottomDistance topDistance |
	eyeToScreenDistance := screenLensDistance.
	halfLensDistance := (interLensDistance / 2) / eyeToScreenDistance.
	screenWidth := physicalExtent x / eyeToScreenDistance.
	screenHeight := physicalExtent y / eyeToScreenDistance.

	eyePositionX := screenWidth / 2 - halfLensDistance.
	eyePositionY := (screenVerticalAlignment - bevelLength) / eyeToScreenDistance.

	viewerMaxDistance := self inverseDistortRadius: fov degreesToRadians tan.
	
	outerDistance := eyePositionX min: viewerMaxDistance.
	innerDistance := halfLensDistance min: viewerMaxDistance.
	bottomDistance := eyePositionY min: viewerMaxDistance.
	topDistance := screenHeight - bottomDistance min: viewerMaxDistance.

	^ WTVREyeViewportParameters new
		outside: outerDistance;
		inner: innerDistance;
		bottom: bottomDistance;
		top: topDistance;
		eyeX: eyePositionX;
		eyeY: eyePositionY;
		yourself