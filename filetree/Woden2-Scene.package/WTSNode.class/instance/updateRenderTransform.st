accessing
updateRenderTransform
	parent ifNotNil: [
		renderTransform := parent renderTransform transformTransform: transform.
	] ifNil: [
		renderTransform := transform.
	].
