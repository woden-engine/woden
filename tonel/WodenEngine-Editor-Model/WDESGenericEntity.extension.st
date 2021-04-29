Extension { #name : #WDESGenericEntity }

{ #category : #'*WodenEngine-Editor-Model' }
WDESGenericEntity >> loadComponentsFromEditorEntity: editorEntity [
	self loadComponentsFromEditorEntity: editorEntity withTransform: ReversibleAffineTransform3dF32 identity
]

{ #category : #'*WodenEngine-Editor-Model' }
WDESGenericEntity >> loadComponentsFromEditorEntity: editorEntity withTransform: componentsTransform [
	editorEntity components do: [ :each |
		(each createEntitySystemComponentWithTransform: componentsTransform for: self) ifNotNil: [ :comp |
			self addComponent: comp
		]
	]
]

{ #category : #'*WodenEngine-Editor-Model' }
WDESGenericEntity >> loadFromEditorEntity: editorEntity [
	self
		name: editorEntity name;
		typeName: editorEntity className;
		transform: editorEntity transform;
		loadComponentsFromEditorEntity: editorEntity
	
]
