as yet unclassified
computeProjectionMatrices
	| leftEyeProjection rightEyeProjection leftEyeUndistortedProjection rightEyeUndistortedProjection |
	validMatrices ifTrue: [ ^ true ].
	
	leftProjection := self computeLeftProjectionMatrix: true.
	leftUndistortedProjection := self computeLeftProjectionMatrix: false.
	
	rightProjection := self computeRightProjectionMatrix: true.
	rightUndistortedProjection := self computeRightProjectionMatrix: false.
		
	leftEyeProjection := WMMatrix3F ndcToTexcoord2D * leftProjection as2DProjectionMatrix.
	leftEyeUndistortedProjection := WMMatrix3F ndcToTexcoord2D * leftUndistortedProjection as2DProjectionMatrix.
	rightEyeProjection := WMMatrix3F ndcToTexcoord2D * rightProjection as2DProjectionMatrix.
	rightEyeUndistortedProjection := WMMatrix3F ndcToTexcoord2D * rightUndistortedProjection as2DProjectionMatrix.
	
	state := WTVRState new
		leftProjectionTransform: leftEyeProjection as2DProjectionVector;
		leftUndistortedProjectionInverseTransform: leftEyeUndistortedProjection as2DInverseProjectionVector;
		rightProjectionTransform: rightEyeProjection as2DProjectionVector;
		rightUndistortedProjectionInverseTransform: rightEyeUndistortedProjection as2DInverseProjectionVector;
		distortionCoefficients: distortionCoefficients;
		yourself.
		
	validMatrices := true.
