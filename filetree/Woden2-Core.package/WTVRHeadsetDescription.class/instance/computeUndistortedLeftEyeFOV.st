as yet unclassified
computeUndistortedLeftEyeFOV
	| params |
	params := self computeUndistortedParameters.
	
	^ WTVREyeFieldOfView new
		left: params outside arcTan; right: params inner arcTan;
		bottom: params bottom arcTan; top: params top arcTan;
		yourself