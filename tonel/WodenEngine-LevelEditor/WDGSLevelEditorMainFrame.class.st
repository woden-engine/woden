Class {
	#name : #WDGSLevelEditorMainFrame,
	#superclass : #WDAViewWithCyrusToolkit,
	#instVars : [
		'levelViews'
	],
	#classVars : [
		'DefaultSettingsForViews'
	],
	#category : #'WodenEngine-LevelEditor-View'
}

{ #category : #initialization }
WDGSLevelEditorMainFrame class >> initialize [

	DefaultSettingsForViews := {
		"Top Left"
		[ :view | view orthographic; wireframe; topView ].
	
		"Top Right"
		[ :view |
			view perspective; solid; frontView. 
			view cameraTransform translateByZ: 3.0; translateByY: 1.0.
		].
		
		"Bottom Left"
		[ :view | view orthographic; wireframe; frontView ].
		
		"Bottom Right"
		[ :view | view orthographic; wireframe; sideView ].
	}
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createCenterViews [
	^ CyTkHorizontalBoxSizer new
		element: self createLevelViews do: [ :el | el proportion: 3; expand];
		element: self createMaterialListView do: [ :el | el proportion: 1; expand]
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createLevelViews [
	| topLeft topRight bottomLeft bottomRight |
	topLeft := WDGSLevelEditorSceneViewPanel for: self.
	topRight := WDGSLevelEditorSceneViewPanel for: self.
	bottomLeft := WDGSLevelEditorSceneViewPanel for: self.
	bottomRight := WDGSLevelEditorSceneViewPanel for: self.
	
	levelViews := { topLeft . topRight . bottomLeft . bottomRight }.
	cyrusWindow addAll: levelViews.
	
	^ CyTkVerticalBoxSizer new
		element: (CyTkHorizontalBoxSizer new
			element: topLeft do: [ :el | el proportion: 1; expand; allBorders; borderSize: 2];
			element: topRight do: [ :el | el proportion: 1; expand; allBorders; borderSize: 2]
		) do: [ :el | el proportion: 1; expand];
		element: (CyTkHorizontalBoxSizer new
			element: bottomLeft do: [ :el | el proportion: 1; expand; allBorders; borderSize: 2];
			element: bottomRight do: [ :el | el proportion: 1; expand; allBorders; borderSize: 2]
		) do: [ :el | el proportion: 1; expand];
		yourself
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createMaterialListView [
	| view |
	view := WDGSLevelEditorMaterialListView for: self.
	cyrusWindow add: view.
	
	^ view
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createMenuBar [
	| menuBar |
	menuBar := CyTkMenuBar new.
	cyrusWindow add: menuBar.
	
	menuBar
		addMenuItem: 'File' menuWith: [ :menu |
			menu
				addMenuItem: 'Open' action: [ :evt | model fileOpen ];
				addMenuItem: 'Save' action: [ :evt | model save ];
				addMenuItem: 'Save As' action: [ :evt | model saveAs ];
				addMenuSeparator;
				addMenuItem: 'Exit' action: [ :evt |  ]
		 ];
		addMenuItem: 'Object' menuWith: [ :menu |
			menu
				addMenuItem: 'Inspect' action: [ :evt | model inspectSelection ];
				addMenuItem: 'Texture Transform' action: [ :evt | model openTextureTransformEditor ];
				addMenuItem: 'Subtract' action: [ :evt | model subtractSelectedBrushes ];
				addMenuItem: 'Make Brush Entity' action: [ :evt | model makeBrushEntity ]
		].
	
	^ menuBar
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createStatusBar [
	| statusBar |
	statusBar := CyTkStatusBar new.
	cyrusWindow add: statusBar.
	
	^ statusBar
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createToolBar [
	| toolBar |
	toolBar := CyTkToolBar new.
	cyrusWindow add: toolBar.
	
	^ toolBar
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createWindowLayout [
	| layout |
		
	layout := CyTkVerticalBoxSizer new
		element: self createMenuBar do: [ :el | el expand ];
		element: self createToolBar do: [ :el | el expand ];
		element: self createCenterViews do: [ :el | el proportion: 1; expand];
		element: self createStatusBar do: [ :el | el expand ];
		yourself.
	cyrusWindow sizer: layout
]

{ #category : #accessing }
WDGSLevelEditorMainFrame >> defaultExtent [
	^ 1024@768
]

{ #category : #initialization }
WDGSLevelEditorMainFrame >> initialize [
	super initialize.
	self createWindowLayout.	
]

{ #category : #opening }
WDGSLevelEditorMainFrame >> openedWithWindow: aWindow [
	levelViews do: #createSceneView.
	levelViews doWithIndex: [ :view :index | (DefaultSettingsForViews at: index) value: view ].
	
]

{ #category : #accessing }
WDGSLevelEditorMainFrame >> scene [
	^ model scene
]

{ #category : #accessing }
WDGSLevelEditorMainFrame >> selectionBox [
	^ model selectionBox
]
