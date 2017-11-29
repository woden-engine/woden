as yet unclassified
loadAction: actionData
	| actionBones |
	actionBones := (actionData at: 'bones') collect: [:actionBone | self loadActionBone: actionBone ].
	^ WTAnimationAction new
		name: (actionData at: 'name');
		bones: actionBones;
		yourself