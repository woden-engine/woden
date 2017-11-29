opening
openInMorphic
	| vw |
	vw := RWViewWindow initializeWithEngine: engine.
	vw view: self.
	^ vw openInMorphic