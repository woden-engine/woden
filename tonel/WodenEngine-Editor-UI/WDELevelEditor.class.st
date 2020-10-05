Class {
	#name : #WDELevelEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'content',
		'levelTreeView',
		'wodenApplication'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDELevelEditor class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 2/3;
		add: #content;
		add: #levelTreeView;
		yourself
]

{ #category : #accessing }
WDELevelEditor >> content [
	^ content
]

{ #category : #initialization }
WDELevelEditor >> initializePresenters [
	wodenApplication := WDELevelEditorSceneModel new.
	content := self newWodenView.
	content
		wodenApplication: wodenApplication;
		wodenViewClass: WDELevelEditorSceneView.
	levelTreeView := self newTreeTable.
	levelTreeView
		addColumn: (SpCompositeTableColumn new
			title: 'Element';
			addColumn: (SpStringTableColumn evaluated: [ :node | node name ]);
			yourself
		);
		hideColumnHeaders;
		children: [ :node | node children ].
		"contextMenu: [ self treeViewMenu ];
		whenSelectionChangedDo: [ :selection | self treeViewItemSelected: selection selectedItem ];
		whenActivatedDo: [ :selection | self treeViewItemActivated: selection selectedItem ]"
	
]

{ #category : #accessing }
WDELevelEditor >> levelTreeView [
	^ levelTreeView
]

{ #category : #initialization }
WDELevelEditor >> modelChanged [
	levelTreeView roots: self model level children.
]

{ #category : #accessing }
WDELevelEditor >> wodenApplication [
	^ wodenApplication
]

{ #category : #accessing }
WDELevelEditor >> wodenApplication: anObject [
	wodenApplication := anObject
]