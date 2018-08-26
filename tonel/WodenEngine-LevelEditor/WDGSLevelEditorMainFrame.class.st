Class {
	#name : #WDGSLevelEditorMainFrame,
	#superclass : #WDAViewWithVesuvius,
	#instVars : [
		'levelViews'
	],
	#category : #'WodenEngine-LevelEditor-View'
}

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createLevelViews [
	| topLeft topRight bottomLeft bottomRight |
	topLeft := WDGSLevelEditorSceneViewPanel for: self.
	topRight := WDGSLevelEditorSceneViewPanel for: self.
	bottomLeft := WDGSLevelEditorSceneViewPanel for: self.
	bottomRight := WDGSLevelEditorSceneViewPanel for: self.
	
	levelViews := { topLeft . topRight . bottomLeft . bottomRight }.
	vsWindow addAll: levelViews.
	topLeft backgroundColor: Color red.
	topRight backgroundColor: Color green.
	bottomLeft backgroundColor: Color yellow.
	bottomRight backgroundColor: Color magenta.
	
	^ VsTkVerticalBoxSizer new
		element: (VsTkHorizontalBoxSizer new
			element: topLeft do: [ :el | el proportion: 1; expand];
			element: topRight do: [ :el | el proportion: 1; expand]
		) do: [ :el | el proportion: 1; expand];
		element: (VsTkHorizontalBoxSizer new
			element: bottomLeft do: [ :el | el proportion: 1; expand];
			element: bottomRight do: [ :el | el proportion: 1; expand]
		) do: [ :el | el proportion: 1; expand];
		yourself
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createMenuBar [
	| menuBar |
	menuBar := VsTkMenuBar new.
	vsWindow add: menuBar.
	
	^ menuBar
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createStatusBar [
	| statusBar |
	statusBar := VsTkStatusBar new.
	vsWindow add: statusBar.
	
	^ statusBar
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createToolBar [
	| toolBar |
	toolBar := VsTkToolBar new.
	vsWindow add: toolBar.
	
	^ toolBar
]

{ #category : #'window layout' }
WDGSLevelEditorMainFrame >> createWindowLayout [
	| layout |
		
	layout := VsTkVerticalBoxSizer new
		element: self createMenuBar do: [ :el | el expand ];
		element: self createToolBar do: [ :el | el expand ];
		element: self createLevelViews do: [ :el | el proportion: 1; expand];
		element: self createStatusBar do: [ :el | el expand ];
		yourself.
	vsWindow sizer: layout
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
	levelViews do: #createSceneView
]
