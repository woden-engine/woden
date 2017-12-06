adding
addedIn: aView
	renderable := shape buildRenderableFor: self view: aView.
	sceneNode isInstance ifFalse: [
		aView validScene add: sceneNode.
	].

	self buildRigidBodyForView: aView.

	view := aView