initialization
initializeWidgets
	self flag: 'Use text input field'.
	
	self instantiateModels: #(
		xScaleLabel LabelModel
		xScale TextModel
		xScaleMore ButtonModel
		xScaleLess ButtonModel

		yScaleLabel LabelModel
		yScale TextModel
		yScaleMore ButtonModel
		yScaleLess ButtonModel

		xOffsetLabel LabelModel
		xOffset TextModel
		xOffsetMore ButtonModel
		xOffsetLess ButtonModel

		yOffsetLabel LabelModel
		yOffset TextModel
		yOffsetMore ButtonModel
		yOffsetLess ButtonModel

		rotationLabel LabelModel
		rotation TextModel
		rotationMore ButtonModel
		rotationLess ButtonModel
	).
	
	self title: 'Texture Transform'.
	xScaleLabel label: 'X Scale'.
	yScaleLabel label: 'Y Scale'.
	xOffsetLabel label: 'X Offset'.
	yOffsetLabel label: 'Y Offset'.
	rotationLabel label: 'Rotation'.
	
	xScale whenTextIsAccepted: [ :v | self convertToFloat: v thenSetWith: #xTextureScale: ].
	yScale whenTextIsAccepted: [ :v | self convertToFloat: v thenSetWith: #yTextureScale: ].
	xOffset whenTextIsAccepted: [ :v | self convertToFloat: v thenSetWith: #xTextureOffset: ].
	yOffset whenTextIsAccepted: [ :v | self convertToFloat: v thenSetWith: #yTextureOffset: ].
	rotation whenTextIsAccepted: [ :v | self convertToFloat: v thenSetWith: #textureRotation: ].
	
	xScaleMore label: '+'; whenActionPerformedDo:[ self increase: #xScale with: #xScale: ].
	xScaleLess label: '-'; whenActionPerformedDo:[ self decrease: #xScale with: #xScale: ].

	yScaleMore label: '+'; whenActionPerformedDo:[ self increase: #yScale with: #yScale: ].
	yScaleLess label: '-'; whenActionPerformedDo:[ self decrease: #yScale with: #yScale: ].

	xOffsetMore label: '+'; whenActionPerformedDo:[ self addAmount: 0.25 with: #xOffset to: #xOffset: ].
	xOffsetLess label: '-'; whenActionPerformedDo:[ self addAmount: -0.25 with: #xOffset to: #xOffset: ].

	yOffsetMore label: '+'; whenActionPerformedDo:[ self addAmount: 0.25 with: #yOffset to: #yOffset: ].
	yOffsetLess label: '-'; whenActionPerformedDo:[ self addAmount: -0.25 with: #yOffset to: #yOffset: ].

	rotationMore label: '+'; whenActionPerformedDo:[ self addAmount: 15 with: #rotation to: #rotation: ].
	rotationLess label: '-'; whenActionPerformedDo:[ self addAmount: -15 with: #rotation to: #rotation: ].
