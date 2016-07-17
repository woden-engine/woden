selection
findBestElementAtGlobalCoord: aPosition
	^ self findBestElementAtWindowCoord: (self globalPointToLocal: aPosition)