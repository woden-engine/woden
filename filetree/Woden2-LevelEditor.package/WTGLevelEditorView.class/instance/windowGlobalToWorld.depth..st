coordinate systems
windowGlobalToWorld: aPosition depth: aDepth
	^ self windowToWorld: (self globalPointToLocal: aPosition) depth: aDepth