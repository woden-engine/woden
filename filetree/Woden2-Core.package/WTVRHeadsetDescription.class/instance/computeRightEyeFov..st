as yet unclassified
computeRightEyeFov: distorted
	| leftEyeFov |
	"For the right eye, just swap the left and right angles."
	leftEyeFov := self computeLeftEyeFov: distorted.
	^ WTVREyeFieldOfView new
		left: leftEyeFov right;
		right: leftEyeFov left;
		bottom: leftEyeFov bottom;
		top: leftEyeFov top;
		yourself