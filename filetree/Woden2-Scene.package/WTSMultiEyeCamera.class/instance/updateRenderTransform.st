accessing
updateRenderTransform
	| localTransform |
	localTransform := transform transformTransform: vrTransform.
	parent ifNotNil: [
		renderTransform := parent renderTransform transformTransform: localTransform.
	] ifNil: [
		renderTransform := localTransform.
	].