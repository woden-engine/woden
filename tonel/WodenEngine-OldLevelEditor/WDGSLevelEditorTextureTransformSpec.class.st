Class {
	#name : #WDGSLevelEditorTextureTransformSpec,
	#superclass : #ComposableModel,
	#instVars : [
		'editor',
		'xScale',
		'xScaleLabel',
		'xScaleMore',
		'xScaleLess',
		'yScale',
		'yScaleLabel',
		'yScaleMore',
		'yScaleLess',
		'xOffset',
		'xOffsetLabel',
		'xOffsetMore',
		'xOffsetLess',
		'yOffset',
		'yOffsetLabel',
		'yOffsetMore',
		'yOffsetLess',
		'rotation',
		'rotationLabel',
		'rotationMore',
		'rotationLess'
	],
	#category : #'WodenEngine-OldLevelEditor-Specs'
}

{ #category : #specs }
WDGSLevelEditorTextureTransformSpec class >> defaultSpec [
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [:mainColumn |
			mainColumn newRow: [ :row |
				row
					add: #xScaleLabel;
					add: #xScale;
					add: #xScaleMore;
					add: #xScaleLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #yScaleLabel;
					add: #yScale;
					add: #yScaleMore;
					add: #yScaleLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #xOffsetLabel;
					add: #xOffset;
					add: #xOffsetMore;
					add: #xOffsetLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #yOffsetLabel;
					add: #yOffset;
					add: #yOffsetMore;
					add: #yOffsetLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #rotationLabel;
					add: #rotation;
					add: #rotationMore;
					add: #rotationLess.
			].

		];
		yourself
]

{ #category : #initialization }
WDGSLevelEditorTextureTransformSpec >> addAmount: amount with: getter to: setter [
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) + amount. 
	].

	self selectionChanged.
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorTextureTransformSpec >> convertToFloat: string thenSetWith: selector [
	| selection number |
	selection := editor selection.
	selection elements ifEmpty: [ ^ self ].
	Transcript show: string; cr.
	number := Number readFrom: string asString ifFail: [ ^ self ].
	Transcript show: number; cr.
	selection perform: selector with: number asFloat.
]

{ #category : #initialization }
WDGSLevelEditorTextureTransformSpec >> decrease: getter with: setter [
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) / 2.0
	].

	self selectionChanged.
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> editor [
	^ editor
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> editor: anObject [
	editor := anObject
]

{ #category : #initialization }
WDGSLevelEditorTextureTransformSpec >> increase: getter with: setter [
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) * 2.0
	].

	self selectionChanged.
]

{ #category : #initialization }
WDGSLevelEditorTextureTransformSpec >> initializeWidgets [
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

]

{ #category : #'as yet unclassified' }
WDGSLevelEditorTextureTransformSpec >> optionalValueToString: anObject [
	anObject ifNil: [ ^ '' ].
	^ anObject asString
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotation [
	^ rotation
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotation: anObject [
	rotation := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotationLabel [
	^ rotationLabel
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotationLabel: anObject [
	rotationLabel := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotationLess [
	^ rotationLess
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotationLess: anObject [
	rotationLess := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotationMore [
	^ rotationMore
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> rotationMore: anObject [
	rotationMore := anObject
]

{ #category : #'event handling' }
WDGSLevelEditorTextureTransformSpec >> selectionChanged [
	| selection |
	editor ifNil: [ ^ self ].
	
	selection := editor selection.
	xScale text: (self optionalValueToString: selection xTextureScale) asText.
	yScale text: (self optionalValueToString: selection yTextureScale) asText.
	xOffset text: (self optionalValueToString: selection xTextureOffset) asText.
	yOffset text: (self optionalValueToString: selection yTextureOffset) asText.
	rotation text: (self optionalValueToString: selection textureRotation) asText.
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffset [
	^ xOffset
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffset: anObject [
	xOffset := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffsetLabel [
	^ xOffsetLabel
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffsetLabel: anObject [
	xOffsetLabel := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffsetLess [
	^ xOffsetLess
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffsetLess: anObject [
	xOffsetLess := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffsetMore [
	^ xOffsetMore
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xOffsetMore: anObject [
	xOffsetMore := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScale [
	^ xScale
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScale: anObject [
	xScale := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScaleLabel [
	^ xScaleLabel
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScaleLabel: anObject [
	xScaleLabel := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScaleLess [
	^ xScaleLess
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScaleLess: anObject [
	xScaleLess := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScaleMore [
	^ xScaleMore
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> xScaleMore: anObject [
	xScaleMore := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffset [
	^ yOffset
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffset: anObject [
	yOffset := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffsetLabel [
	^ yOffsetLabel
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffsetLabel: anObject [
	yOffsetLabel := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffsetLess [
	^ yOffsetLess
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffsetLess: anObject [
	yOffsetLess := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffsetMore [
	^ yOffsetMore
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yOffsetMore: anObject [
	yOffsetMore := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScale [
	^ yScale
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScale: anObject [
	yScale := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScaleLabel [
	^ yScaleLabel
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScaleLabel: anObject [
	yScaleLabel := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScaleLess [
	^ yScaleLess
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScaleLess: anObject [
	yScaleLess := anObject
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScaleMore [
	^ yScaleMore
]

{ #category : #accessing }
WDGSLevelEditorTextureTransformSpec >> yScaleMore: anObject [
	yScaleMore := anObject
]
