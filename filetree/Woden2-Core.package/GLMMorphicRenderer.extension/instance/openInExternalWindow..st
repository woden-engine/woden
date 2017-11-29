*Woden2-Core
openInExternalWindow: aRenderable
	window := GLMWTOSWindowMorphWorldRenderer render: aRenderable from: self.
	^ window open