accessing
transformIntoBox: aBox
	| transformation |
	elements ifNotEmpty: [ 
		transformation := box computeTransformationInto: aBox.
		elements do: [:el | el applyTransformation: transformation ]
	].

	self box: aBox.
	