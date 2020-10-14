Class {
	#name : #WDELevelEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'content',
		'levelTreeView',
		'elementTemplateList',
		'wodenApplication',
		'mainMenuBar',
		'mainStatusBar',
		'mainToolbar'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDELevelEditor class >> defaultSpec [
	^ SpBoxLayout newVertical
		add: #mainMenuBar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: #mainToolbar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add: (	SpPanedLayout newHorizontal
			position: 2/3;
			add: #content;
			add: (SpPanedLayout newVertical
				position: 2/3;
				add: #levelTreeView;
				add: #elementTemplateList;
				yourself)
			yourself);
		add: #mainStatusBar withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself

]

{ #category : #'world menu' }
WDELevelEditor class >> menuCommandOn: builder [
	<worldMenu>
	(builder item: #'Open level editor')
		parent: #Woden;
		order: 0;
		action: [ WDELevel empty openEditor  ].
]

{ #category : #'main actions' }
WDELevelEditor >> actionAbout [
	self inform: 'TODO: actionAbout'
]

{ #category : #'main actions' }
WDELevelEditor >> actionCopy [
	self inform: 'TODO: actionCopy'
]

{ #category : #'main actions' }
WDELevelEditor >> actionCut [
	self inform: 'TODO: actionCut'
]

{ #category : #'main actions' }
WDELevelEditor >> actionExit [
	self inform: 'TODO: actionExit'
]

{ #category : #'main actions' }
WDELevelEditor >> actionOpenFile [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog title: 'Select the level to open'; answerPathName.
	result := dialog openModal answer.
	self model openFrom: result asFileReference
]

{ #category : #'main actions' }
WDELevelEditor >> actionPaste [
	self inform: 'TODO: actionPaste'
]

{ #category : #'main actions' }
WDELevelEditor >> actionRedo [
	self inform: 'TODO: actionRedo'
]

{ #category : #'main actions' }
WDELevelEditor >> actionSaveFile [
	self model levelFileReference ifNotNil: [ :fileReference |
		self model saveTo: fileReference
	] ifNil: [
		self actionSaveFileAs
	]
]

{ #category : #'main actions' }
WDELevelEditor >> actionSaveFileAs [
	| dialog result |
	dialog := self createLevelFileDialog.
	dialog
		title: 'Select the location to save the level';
		fileNameText: 'level.wlevel';
		answerSaveFile.
	self model levelFileReference ifNotNil: [ :fileRef |
		dialog
			fileNameText: fileRef basename;
			selectPath: fileRef parent
	].

	result := dialog openModal answer.
	self model saveTo: result asFileReference
]

{ #category : #'main actions' }
WDELevelEditor >> actionUndo [
	self inform: 'TODO: actionUndo'
]

{ #category : #menu }
WDELevelEditor >> buildMainMenuBar [
	^ self newMenuBar
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'File';
						subMenu: self fileMenu
				];
				addItem: [ :item |
					item
						name: 'Edit';
						subMenu: self editMenu
				];
				addItem: [ :item |
					item
						name: 'View';
						subMenu: self viewMenu
				];
				addItem: [ :item |
					item
						name: 'Help';
						subMenu: self helpMenu
				]
		];
		yourself
]

{ #category : #initialization }
WDELevelEditor >> buildMainToolbar [
	^ self newToolbar
		addItem: (SpToolbarButtonPresenter new
			label: 'Object';
			action: [ content view activateObjectMode ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Placement';
			action: [ content view activatePlacementMode ];
			yourself);
		yourself
]

{ #category : #menu }
WDELevelEditor >> cameraMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
				item
					name: 'Top';
					action: [ self contentView topView ]
			];
			addItem: [ :item |
				item
					name: 'Front';
					action: [ self contentView frontView ]
			];
			addItem: [ :item |
				item
					name: 'Side';
					action: [ self contentView sideView ]
			]
		];
		addGroup: [ :group |
			group
				addItem: [ :item |
				item
					name: 'Perspective';
					action: [ self contentView perspectiveView ]
			];
			addItem: [ :item |
				item
					name: 'Orthographic';
					action: [ self contentView orthographicView ]
			]
		];
		yourself
]

{ #category : #accessing }
WDELevelEditor >> content [
	^ content
]

{ #category : #accessing }
WDELevelEditor >> contentView [
	^ content view
]

{ #category : #'main actions' }
WDELevelEditor >> createLevelFileDialog [
	^ FileDialogWindow basicNew
		basicTheme: self theme;
		initialize;
		validExtensions: #(wlevel wblevel);
		yourself
]

{ #category : #menu }
WDELevelEditor >> editMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Undo';
						icon: (self iconNamed: #smallUndoIcon);
						action: [ self actionUndo ].
				];
				addItem: [ :item |
					item
						name: 'Redo';
						icon: (self iconNamed: #smallRedoIcon);
						action: [ self actionRedo ].
				]
		];
		addGroup: [ :group |
			group addItem: [ :item |
				item
					name: 'Cut';
					icon: (self iconNamed: #smallCutIcon);
					action: [ self actionCut ]
			].
			group addItem: [ :item |
				item
					name: 'Copy';
					icon: (self iconNamed: #smallCopyIcon);
					action: [ self actionCopy ]
			].
			group addItem: [ :item |
				item
					name: 'Paste';
					icon: (self iconNamed: #smallPasteIcon);
					action: [ self actionPaste ]
			].
		];
		yourself
]

{ #category : #accessing }
WDELevelEditor >> elementTemplateList [
	^ elementTemplateList
]

{ #category : #menu }
WDELevelEditor >> fileMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Open File...';
						icon: (self iconNamed: #openIcon);
						action: [ self actionOpenFile ].
				];
				addItem: [ :item |
					item
						name: 'Save';
						icon: (self iconNamed: #smallSaveIcon);
						action: [ self actionSaveFile ].
				];
				addItem: [ :item |
					item
						name: 'Save As...';
						icon: (self iconNamed: #smallSaveAsIcon);
						action: [ self actionSaveFileAs ].
				]
		];
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Exit';
						action: [ self actionExit ].
				]
		];
		yourself
]

{ #category : #menu }
WDELevelEditor >> helpMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'About...';
						action: [ self actionAbout ].
				]
		];
		yourself
]

{ #category : #initialization }
WDELevelEditor >> initializePresenters [
	mainMenuBar := self buildMainMenuBar.
	mainToolbar := self buildMainToolbar.
	mainStatusBar := self newStatusBar.
	wodenApplication := WDELevelEditorSceneModel new.
	wodenApplication levelEditorSession: self model.
	content := self newWodenView.
	content
		wodenApplication: wodenApplication;
		wodenViewClass: WDELevelEditorSceneView.
	levelTreeView := self newTreeTable.
	levelTreeView
		addColumn: (SpCompositeTableColumn new
			title: 'Element';
			addColumn: (SpStringTableColumn evaluated: [ :node | node treeDisplayName ]);
			yourself
		);
		hideColumnHeaders;
		children: [ :node | node children ];
		beMultipleSelection;
		whenSelectionChangedDo: [ :selection |
			self model selection: (WDELevelEditorSelection for: selection selectedItems)
		].
		"contextMenu: [ self treeViewMenu ];
		whenActivatedDo: [ :selection | self treeViewItemActivated: selection selectedItem ]"
	elementTemplateList := self newTable.
]

{ #category : #initialization }
WDELevelEditor >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter initialExtent: 1024@768
]

{ #category : #accessing }
WDELevelEditor >> levelTreeView [
	^ levelTreeView
]

{ #category : #accessing }
WDELevelEditor >> mainMenuBar [
	^ mainMenuBar
]

{ #category : #accessing }
WDELevelEditor >> mainStatusBar [
	^ mainStatusBar
]

{ #category : #accessing }
WDELevelEditor >> mainToolbar [
	^ mainToolbar
]

{ #category : #initialization }
WDELevelEditor >> modelChanged [
	levelTreeView roots: self model level children.
	self model
		whenSelectionChangedDo: [ :selection |
			levelTreeView selectedItems asSet = selection selectedItems asSet ifFalse: [
				levelTreeView unselectAll; selectItems: selection selectedItems
			]
		];
		whenLevelChangedDo: [ :newLevel |
			levelTreeView roots: self model level children
		]
		
]

{ #category : #menu }
WDELevelEditor >> shadingMenu [
	^ self newMenu
		addItem: [ :item |
			item
				name: 'Wireframe';
				action: [ self contentView activateWireFrame ]
		];
		addItem: [ :item |
			item
				name: 'Flat color';
				action: [ self contentView activateFlatColor ]
		];
		addItem: [ :item |
			item
				name: 'Flat textured';
				action: [ self contentView activateFlatTextured ]
		];
		addItem: [ :item |
			item
				name: 'Shaded color';
				action: [ self contentView activateShadedColor ]
		];
		addItem: [ :item |
			item
				name: 'Full shaded';
				action: [ self contentView activateFullShaded ]
		];
		yourself
]

{ #category : #menu }
WDELevelEditor >> viewMenu [
	^ self newMenu
		addGroup: [ :group |
			group
				addItem: [ :item |
					item
						name: 'Shading mode';
						subMenu: self shadingMenu.
				];
				addItem: [ :item |
					item
						name: 'Camera';
						subMenu: self cameraMenu.
				]
		];
		yourself
]

{ #category : #accessing }
WDELevelEditor >> wodenApplication [
	^ wodenApplication
]

{ #category : #accessing }
WDELevelEditor >> wodenApplication: anObject [
	wodenApplication := anObject
]
