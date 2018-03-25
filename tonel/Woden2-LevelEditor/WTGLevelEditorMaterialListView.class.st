Class {
	#name : #WTGLevelEditorMaterialListView,
	#superclass : #WTGLevelEditorViewComponent,
	#instVars : [
		'thumbnailCells',
		'labelFont',
		'verticalScroll',
		'selectedCell',
		'highlightedCell'
	],
	#classVars : [
		'CellHighlightedBackgroundColor',
		'CellMargin',
		'CellSelectedBackgroundColor',
		'CellSize',
		'MaterialTypeBlackList',
		'VerticalScrollAmount'
	],
	#category : 'Woden2-LevelEditor'
}

{ #category : #'class initialization' }
WTGLevelEditorMaterialListView class >> initialize [
	super initialize.
	
	CellSize := 128.
	CellMargin := 4.
	
	CellHighlightedBackgroundColor := Color lightGray.
	CellSelectedBackgroundColor := Color blue.
	VerticalScrollAmount := 32.
	
	MaterialTypeBlackList := Set newFrom: #(skinned 'no-editor')
]

{ #category : #private }
WTGLevelEditorMaterialListView >> computeCellExtent [
	^ self computeCellWidth @ self computeCellHeight
]

{ #category : #private }
WTGLevelEditorMaterialListView >> computeCellHeight [
	^ CellMargin *2 + CellSize + self computeFontHeight
]

{ #category : #private }
WTGLevelEditorMaterialListView >> computeCellWidth [
	^ CellMargin *2 + CellSize
]

{ #category : #private }
WTGLevelEditorMaterialListView >> computeFontHeight [
	^ self labelFont height
]

{ #category : #private }
WTGLevelEditorMaterialListView >> computeGridSize [
	| columns |
	columns := self width // self computeCellWidth max: 1.
	^ columns @ ((thumbnailCells size + columns - 1) // columns)
]

{ #category : #private }
WTGLevelEditorMaterialListView >> computeNumberOfColumns [
	^ self width // self computeCellWidth
]

{ #category : #drawing }
WTGLevelEditorMaterialListView >> drawChildrenOn: aCanvas [
	super drawChildrenOn: aCanvas.
	self drawThumbnailsOn: aCanvas.

]

{ #category : #private }
WTGLevelEditorMaterialListView >> drawThumbnailCell: cell at: position on: canvas [
	| thumbnailPaint font |
	thumbnailPaint := editor thumbnailPaintCache gpuPaintFor: cell thumbnail value.
	font := self labelFont.
	
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateBy: position.
		
		selectedCell == cell ifTrue: [
			canvas setPaint: CellSelectedBackgroundColor.
			canvas setShape: (0 @ 0 extent: self computeCellExtent).
			canvas draw.
		] ifFalse: [ 
			highlightedCell == cell ifTrue: [
				canvas setPaint: CellHighlightedBackgroundColor.
				canvas setShape: (0 @ 0 extent: self computeCellExtent).
				canvas draw.
			]
		].
		
		canvas setPaint: thumbnailPaint.
			
		canvas setShape: (CellMargin @ CellMargin extent: CellSize @ CellSize).
		canvas draw.
		
		canvas pathTransform restoreAfter: [
			canvas pathTransform translateX: CellMargin Y: font getPreciseAscent + CellMargin + CellSize.

			canvas setFont: self labelFont.
			canvas setPaint: Color black.
			
			canvas drawString: cell label.
		]
	].

]

{ #category : #private }
WTGLevelEditorMaterialListView >> drawThumbnailsOn: aCanvas [
	| cellWidth cellHeight columns rows rowIndex columnIndex gridSize thumbnailPosition |
	self ensureThumbnailDataIsUpdated.
	thumbnailCells ifEmpty: [ ^ self ].
	
	cellWidth := self computeCellWidth.
	cellHeight := self computeCellHeight.
	
	gridSize := self computeGridSize.
	columns := gridSize x.
	rows := gridSize y.

	thumbnailCells doWithIndex: [ :cell :index |
		rowIndex := (index - 1) // columns.
		columnIndex := (index - 1) \\ columns.
		thumbnailPosition := (columnIndex*cellWidth) @ (rowIndex*cellHeight + verticalScroll).
		thumbnailPosition y > self height ifTrue: [ ^ self ].
		self drawThumbnailCell: cell at: thumbnailPosition on: aCanvas
	].

]

{ #category : #private }
WTGLevelEditorMaterialListView >> ensureThumbnailDataIsUpdated [
	| thumbDB label path category |
	thumbnailCells ifNotNil: [ ^ self ].
	thumbnailCells := OrderedCollection new.
	thumbDB := editor materialThumbDB.
	thumbDB resources keysAndValuesDo: [ :name :thumbnail |
		(MaterialTypeBlackList includes: thumbnail type) ifFalse: [
			path := name asFileReference.
			category := path parent basename.
			label := path basenameWithoutExtension.
			thumbnailCells add: (WTGLevelEditorMaterialListCell new
				label: label;
				category: category;
				thumbnail: thumbnail;
				value: name)
			]
	].

	thumbnailCells sort.

]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> findCellAtPosition: aPosition [
	| column row gridExtent cellIndex |
	column := aPosition x asInteger // self computeCellWidth.
	row := aPosition y asInteger // self computeCellHeight.
	
	gridExtent := self computeGridSize.
	(column < 0 or: [ row < 0 ]) ifTrue: [ ^ nil ].
	(column >= gridExtent x or: [ row >= gridExtent y ]) ifTrue: [ ^ nil ].

	cellIndex := (row * gridExtent x) + column + 1.
	cellIndex <= thumbnailCells size ifTrue: [ ^ thumbnailCells at: cellIndex ] ifFalse: [ ^ nil ]
]

{ #category : #'initialize-release' }
WTGLevelEditorMaterialListView >> initialize [
	super initialize.
	verticalScroll := 0.
	self initializeHandlers.
]

{ #category : #'initialize-release' }
WTGLevelEditorMaterialListView >> initializeHandlers [
	self
		addEventHandler: (BlEventHandler on: BlMouseEnterEvent do: [ :evt | 
			evt consumed: true.
			self requestFocus.
		]);
		addEventHandler: (BlEventHandler on: BlMouseLeaveEvent do: [ :evt | 
			evt consumed: true.
			highlightedCell := nil.
		]);
		addEventHandler: (BlEventHandler on: BlClickEvent do: [ :evt | 
			evt consumed: true.
			self onClickEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlDblClickEvent do: [ :evt | 
			evt consumed: true.
			self onDoubleClickEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlMouseMoveEvent do: [ :evt |
			self onMouseMoveEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlScrollEvent do: [ :evt | 
			evt consumed: true.
			self onScrollEvent: evt.
		]);
		addEventHandler: (BlEventHandler on: BlKeyDownEvent do: [ :evt | 
			evt consumed: true.
			self onKeyDownEvent: evt.
		])
]

{ #category : #accessing }
WTGLevelEditorMaterialListView >> labelFont [
	labelFont ifNil: [ labelFont := self engine fontCache default normal pointSize: 14 ].
	^ labelFont
]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> onClickEvent: event [
	| newSelectedCell |
	newSelectedCell := self findCellAtPosition: (self globalPointToLocal: event position - (0@verticalScroll)).
	newSelectedCell ifNil: [ ^ self ].
	
	selectedCell := newSelectedCell.
	editor
		currentMaterialName: selectedCell value.
]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> onDoubleClickEvent: event [
	| newSelectedCell |
	newSelectedCell := self findCellAtPosition: (self globalPointToLocal: event position - (0@verticalScroll)).
	newSelectedCell ifNil: [ ^ self ].
	
	selectedCell := newSelectedCell.
	editor
		currentMaterialName: selectedCell value;
		applyCurrentMaterialToSelection
]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> onKeyDownEvent: event [
	| keyValue |
	keyValue := event keyValue.
	
	"TODO: Move the selection element instead of just scrolling."
	keyValue = OSK_DOWN ifTrue: [ 
		verticalScroll := verticalScroll - VerticalScrollAmount.
		self onMouseMoveEvent: event.
	].
	keyValue = OSK_UP ifTrue: [ 
		verticalScroll := verticalScroll + VerticalScrollAmount.
		self snapScrolling.
		self onMouseMoveEvent: event.
	].

]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> onMouseMoveEvent: event [
	highlightedCell := self findCellAtPosition: (self globalPointToLocal: event position - (0@verticalScroll))
]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> onScrollEvent: event [
	event direction = Character arrowUp ifTrue: [ 
		verticalScroll := verticalScroll + VerticalScrollAmount.
		self snapScrolling.
	].
	event direction = Character arrowDown ifTrue: [ 
		verticalScroll := verticalScroll - VerticalScrollAmount.
		self snapScrolling.
	].
	self onMouseMoveEvent: event.


]

{ #category : #'event handling' }
WTGLevelEditorMaterialListView >> snapScrolling [
	verticalScroll := verticalScroll min: 0 max: (self computeCellHeight * (self computeGridSize y - 1) max: 0) negated
]
