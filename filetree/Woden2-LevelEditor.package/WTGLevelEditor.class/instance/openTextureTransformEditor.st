actions
openTextureTransformEditor
	| textureTransformEditorWindow |
	textureTransformEditor ifNotNil: [ ^ self ].
	textureTransformEditor := WTGLevelEditorTextureTransformSpec new editor: self.
	self flag: 'Spec should provide a mechanism for this'.
	textureTransformEditorWindow := textureTransformEditor openExternalWindowWithSpec window value.
	textureTransformEditorWindow closeCallback: [ textureTransformEditor := nil ].
	textureTransformEditor selectionChanged.
	textureTransformEditorWindow changed