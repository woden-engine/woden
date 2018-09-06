Class {
	#name : #WDGSLevelEditorMaterialListView,
	#superclass : #WDGSLevelEditorViewComponent,
	#instVars : [
		'verticalScroll',
		'thumbnailCells',
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
	#category : #'WodenEngine-LevelEditor-View'
}

{ #category : #initialization }
WDGSLevelEditorMaterialListView class >> initialize [
	super initialize.
	
	CellSize := 128.
	CellMargin := 4.
	
	CellHighlightedBackgroundColor := Color lightGray.
	CellSelectedBackgroundColor := Color blue.
	VerticalScrollAmount := 32.
	
	MaterialTypeBlackList := Set newFrom: #(skinned 'no-editor')
]

{ #category : #drawing }
WDGSLevelEditorMaterialListView >> buildMeshContentOn: meshBuilder [
	super buildMeshContentOn: meshBuilder.
	self drawThumbnailsOn: meshBuilder.
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> computeCellExtent [
	^ self computeCellWidth @ self computeCellHeight
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> computeCellHeight [
	^ CellMargin *2 + CellSize + self computeFontHeight
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> computeCellWidth [
	^ CellMargin *2 + CellSize
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> computeFontHeight [
	^ self theme widgetFont height
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> computeGridSize [
	| columns |
	columns := self width // self computeCellWidth max: 1.
	^ columns @ ((thumbnailCells size + columns - 1) // columns)
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> computeNumberOfColumns [
	^ self width // self computeCellWidth
]

{ #category : #private }
WDGSLevelEditorMaterialListView >> drawThumbnailCell: cell at: cellPosition on: meshBuilder [
	| font cellBounds cellInterior |
	font := self theme widgetFont.
	
	meshBuilder transform restoreAfter: [
		meshBuilder transform translateBy: cellPosition.
		
		cellBounds := (0 @ 0 extent: self computeCellExtent).		
		selectedCell == cell ifTrue: [
			meshBuilder fill
				color: CellSelectedBackgroundColor;
				rectangle: cellBounds
		] ifFalse: [ 
			highlightedCell == cell ifTrue: [
			meshBuilder fill
				color: CellHighlightedBackgroundColor;
				rectangle: cellBounds
			]
		].
		
		cellInterior := (CellMargin @ CellMargin extent: CellSize @ CellSize).
		meshBuilder fill
			paint: cell thumbnail value tileRectangle: cellInterior;
			rectangle: cellInterior.
		
		meshBuilder text
			position: CellMargin @ (font getPreciseAscent + CellMargin + CellSize);
			color: Color black;
			font: self theme widgetFont;
			draw: cell label
	].

]

{ #category : #private }
WDGSLevelEditorMaterialListView >> drawThumbnailsOn: aCanvas [
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
WDGSLevelEditorMaterialListView >> ensureThumbnailDataIsUpdated [
	| thumbDB label path category |
	thumbnailCells ifNotNil: [ ^ self ].
	thumbnailCells := OrderedCollection new.
	thumbDB := self editor materialThumbDB.
	thumbDB resources keysAndValuesDo: [ :name :thumbnail |
		(MaterialTypeBlackList includes: thumbnail type) ifFalse: [
			path := name asFileReference.
			category := path parent basename.
			label := path basenameWithoutExtension.
			thumbnailCells add: (WDGSLevelEditorMaterialListCell new
				label: label;
				category: category;
				thumbnail: thumbnail;
				value: name)
			]
	].

	thumbnailCells sort.

]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> findCellAtPosition: aPosition [
	| column row gridExtent cellIndex |
	column := aPosition x asInteger // self computeCellWidth.
	row := aPosition y asInteger // self computeCellHeight.
	
	gridExtent := self computeGridSize.
	(column < 0 or: [ row < 0 ]) ifTrue: [ ^ nil ].
	(column >= gridExtent x or: [ row >= gridExtent y ]) ifTrue: [ ^ nil ].

	cellIndex := (row * gridExtent x) + column + 1.
	cellIndex <= thumbnailCells size ifTrue: [ ^ thumbnailCells at: cellIndex ] ifFalse: [ ^ nil ]
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> handleClick: event [
	| newSelectedCell |
	newSelectedCell := self findCellAtPosition: event position - (0@verticalScroll).
	newSelectedCell ifNil: [ ^ self ].
	
	selectedCell := newSelectedCell.
	self editor
		currentMaterialName: selectedCell value.
	self changed.
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> handleDoubleClick: event [
	| newSelectedCell |
	newSelectedCell := self findCellAtPosition: event position - (0@verticalScroll).
	newSelectedCell ifNil: [ ^ self ].
	
	selectedCell := newSelectedCell.
	self editor
		currentMaterialName: selectedCell value;
		applyCurrentMaterialToSelection.
	self changed.
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> handleKeyDown: event [
	| keyValue |
	keyValue := event keyValue.
	
	"TODO: Move the selection element instead of just scrolling."
	keyValue = OSK_DOWN ifTrue: [ 
		verticalScroll := verticalScroll - VerticalScrollAmount.
		self highlightCellAtPosition: event position
	].
	keyValue = OSK_UP ifTrue: [ 
		verticalScroll := verticalScroll + VerticalScrollAmount.
		self snapScrolling.
		self highlightCellAtPosition: event position
	].
	^ super handleKeyDown: event
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> handleMouseMove: event [
	self highlightCellAtPosition: event position.
	^ super handleMouseMove: event.
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> handleMouseWheel: event [
	verticalScroll := verticalScroll + (VerticalScrollAmount * event scrollVertical).
	self snapScrolling.

	self highlightCellAtPosition: event position.
	^ super handleMouseWheel: event
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> highlightCellAtPosition: cellPosition [
	highlightedCell := self findCellAtPosition: cellPosition - (0@verticalScroll).
	self changed
]

{ #category : #initialization }
WDGSLevelEditorMaterialListView >> initialize [
	super initialize.
	self meshScope: true.
	verticalScroll := 0.
]

{ #category : #'event handling' }
WDGSLevelEditorMaterialListView >> snapScrolling [
	verticalScroll := verticalScroll min: 0 max: (self computeCellHeight * (self computeGridSize y - 1) max: 0) negated
]
