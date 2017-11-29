selection
selectionChanged
	currentInspector ifNotNil: [ currentInspector update ].
	textureTransformEditor ifNotNil: [ textureTransformEditor selectionChanged ].