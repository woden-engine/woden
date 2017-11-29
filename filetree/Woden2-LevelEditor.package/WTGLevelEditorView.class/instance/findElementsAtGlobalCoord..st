selection
findElementsAtGlobalCoord: aPosition
	^ self findElementsAtWindowCoord: (self globalPointToLocal: aPosition)