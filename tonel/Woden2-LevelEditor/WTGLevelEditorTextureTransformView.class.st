Class {
	#name : #WTGLevelEditorTextureTransformView,
	#superclass : #WTGLevelEditorBlocPane,
	#instVars : [
		'xScale',
		'yScale',
		'xOffset',
		'yOffset',
		'rotation'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'as yet unclassified' }
WTGLevelEditorTextureTransformView >> initialize [
	super initialize.
	bloc := BrVBoxPane new
		constraintsDo:[:c| c hMatchParent; vFitContent; alignCenter.].
	self
		addLabel: 'Texture transform'.

	xScale := self addLabel: 'X Scale' inputAction: [:value |] plusAction: [  ] minusAction: [  ].
	yScale := self addLabel: 'Y Scale' inputAction: [:value |] plusAction: [  ] minusAction: [  ].

	xOffset := self addLabel: 'X Offset' inputAction: [:value |] plusAction: [  ] minusAction: [  ].
	yOffset := self addLabel: 'Y Offset' inputAction: [:value |] plusAction: [  ] minusAction: [  ].

	rotation := self addLabel: 'Rotation' inputAction: [:value |] plusAction: [  ] minusAction: [  ].
]
