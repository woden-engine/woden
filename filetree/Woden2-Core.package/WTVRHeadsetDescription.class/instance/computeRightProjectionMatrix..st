as yet unclassified
computeRightProjectionMatrix: distorted
	| eyeFov |
	eyeFov := self computeRightEyeFov: distorted.
	^ eyeFov reverseDepthNear: nearDistance far: farDistance invertedY: invertedY