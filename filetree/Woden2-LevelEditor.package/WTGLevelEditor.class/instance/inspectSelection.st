actions
inspectSelection
	currentInspector ifNotNil: [ ^ self ].
	currentInspector := GTInspector new.
	(currentInspector openInExternalWindowOn: self)
		extent: 640@480;
		closeCallback: [ currentInspector := nil ].