opening
openInOSWindow
	window := WDAOSWindowViewWindow new view: self; engine: engine; yourself.
	window open.
	^ window