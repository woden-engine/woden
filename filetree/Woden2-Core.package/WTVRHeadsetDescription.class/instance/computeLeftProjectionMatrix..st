as yet unclassified
computeLeftProjectionMatrix: distorted
	| eyeFov |
	eyeFov := self computeLeftEyeFov: distorted.
	^ eyeFov reverseDepthNear: nearDistance far: farDistance invertedY: invertedY