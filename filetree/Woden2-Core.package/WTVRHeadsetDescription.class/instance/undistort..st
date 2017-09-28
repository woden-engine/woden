as yet unclassified
undistort: aPoint
	^ aPoint / (self undistortRadius: aPoint length)