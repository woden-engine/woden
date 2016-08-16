adding
addedIn: aView
	renderable := shape buildRenderableFor: self view: aView.
	sceneNode isInstance ifFalse: [
		aView scene add: sceneNode.
	].

	self buildRigidBodyForView: aView.

	view := aView