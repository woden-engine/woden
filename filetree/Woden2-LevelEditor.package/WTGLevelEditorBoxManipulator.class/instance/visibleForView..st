testing
visibleForView: aView
	^ aView isPerspective or: [ (aView zBackwardDirection dot: direction) > 0 ]