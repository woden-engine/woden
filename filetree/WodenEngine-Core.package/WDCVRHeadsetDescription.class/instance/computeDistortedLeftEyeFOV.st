as yet unclassified
computeDistortedLeftEyeFOV
	
	| centerLeftDistance centerRightDistance bottomDistance topDistance centerLeftAngle centerRightAngle bottomAngle topAngle maxFovAngle eyeToScreenDistance |
	centerLeftDistance := (physicalExtent x - interLensDistance) / 2.
	centerRightDistance := interLensDistance / 2.
	bottomDistance := screenVerticalAlignment - bevelLength.
	topDistance := physicalExtent y - bottomDistance.
	
	maxFovAngle := fov degreesToRadians.

	eyeToScreenDistance := screenLensDistance.
	
	centerLeftAngle := (self distortRadius: centerLeftDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	centerRightAngle := (self distortRadius: centerRightDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	bottomAngle := (self distortRadius: bottomDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	topAngle := (self distortRadius: topDistance / eyeToScreenDistance) arcTan min: maxFovAngle.
	
	^ WDCVREyeFieldOfView new
		left: centerLeftAngle; right: centerRightAngle;
		bottom: bottomAngle; top: topAngle;
		yourself