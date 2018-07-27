Class {
	#name : #WTGLevelEditorTextureTransformSpec,
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
	#category : #'WodenEngine-LevelEditor-Old'
}

{ #category : #specs }
WTGLevelEditorTextureTransformSpec class >> defaultSpec [
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
WTGLevelEditorTextureTransformSpec >> addAmount: amount with: getter to: setter [
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) + amount. 
	].

	self selectionChanged.
]

{ #category : #'as yet unclassified' }
WTGLevelEditorTextureTransformSpec >> convertToFloat: string thenSetWith: selector [
	| selection number |
	selection := editor selection.
	selection elements ifEmpty: [ ^ self ].
	Transcript show: string; cr.
	number := Number readFrom: string asString ifFail: [ ^ self ].
	Transcript show: number; cr.
	selection perform: selector with: number asFloat.
]

{ #category : #initialization }
WTGLevelEditorTextureTransformSpec >> decrease: getter with: setter [
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) / 2.0
	].

	self selectionChanged.
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> editor [
	^ editor
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> editor: anObject [
	editor := anObject
]

{ #category : #initialization }
WTGLevelEditorTextureTransformSpec >> increase: getter with: setter [
	editor selection textureTransformsDo: [ :transform |
		transform perform: setter with: (getter value: transform) * 2.0
	].

	self selectionChanged.
]

{ #category : #initialization }
WTGLevelEditorTextureTransformSpec >> initializeWidgets [
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
WTGLevelEditorTextureTransformSpec >> optionalValueToString: anObject [
	anObject ifNil: [ ^ '' ].
	^ anObject asString
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotation [
	^ rotation
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotation: anObject [
	rotation := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotationLabel [
	^ rotationLabel
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotationLabel: anObject [
	rotationLabel := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotationLess [
	^ rotationLess
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotationLess: anObject [
	rotationLess := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotationMore [
	^ rotationMore
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> rotationMore: anObject [
	rotationMore := anObject
]

{ #category : #'event handling' }
WTGLevelEditorTextureTransformSpec >> selectionChanged [
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
WTGLevelEditorTextureTransformSpec >> xOffset [
	^ xOffset
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffset: anObject [
	xOffset := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffsetLabel [
	^ xOffsetLabel
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffsetLabel: anObject [
	xOffsetLabel := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffsetLess [
	^ xOffsetLess
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffsetLess: anObject [
	xOffsetLess := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffsetMore [
	^ xOffsetMore
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xOffsetMore: anObject [
	xOffsetMore := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScale [
	^ xScale
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScale: anObject [
	xScale := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScaleLabel [
	^ xScaleLabel
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScaleLabel: anObject [
	xScaleLabel := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScaleLess [
	^ xScaleLess
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScaleLess: anObject [
	xScaleLess := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScaleMore [
	^ xScaleMore
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> xScaleMore: anObject [
	xScaleMore := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffset [
	^ yOffset
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffset: anObject [
	yOffset := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffsetLabel [
	^ yOffsetLabel
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffsetLabel: anObject [
	yOffsetLabel := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffsetLess [
	^ yOffsetLess
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffsetLess: anObject [
	yOffsetLess := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffsetMore [
	^ yOffsetMore
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yOffsetMore: anObject [
	yOffsetMore := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScale [
	^ yScale
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScale: anObject [
	yScale := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScaleLabel [
	^ yScaleLabel
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScaleLabel: anObject [
	yScaleLabel := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScaleLess [
	^ yScaleLess
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScaleLess: anObject [
	yScaleLess := anObject
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScaleMore [
	^ yScaleMore
]

{ #category : #accessing }
WTGLevelEditorTextureTransformSpec >> yScaleMore: anObject [
	yScaleMore := anObject
]
