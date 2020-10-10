Class {
	#name : #WDELevelEditor,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'content',
		'levelTreeView',
		'elementTemplateList',
		'wodenApplication'
	],
	#category : #'WodenEngine-Editor-UI'
}

{ #category : #specs }
WDELevelEditor class >> defaultSpec [
	^ SpPanedLayout newHorizontal
		position: 2/3;
		add: #content;
		add: (SpPanedLayout newVertical
			position: 2/3;
			add: #levelTreeView;
			add: #elementTemplateList;
			yourself)
		yourself
]

{ #category : #accessing }
WDELevelEditor >> content [
	^ content
]

{ #category : #accessing }
WDELevelEditor >> elementTemplateList [
	^ elementTemplateList
]

{ #category : #initialization }
WDELevelEditor >> initializePresenters [
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
		children: [ :node | node children ].
		"contextMenu: [ self treeViewMenu ];
		whenSelectionChangedDo: [ :selection | self treeViewItemSelected: selection selectedItem ];
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
