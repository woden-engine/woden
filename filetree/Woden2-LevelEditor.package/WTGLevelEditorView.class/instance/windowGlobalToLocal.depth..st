coordinate systems
windowGlobalToLocal: aPosition depth: aDepth
	^ self windowToLocal: (self globalPointToLocal: aPosition) depth: aDepth