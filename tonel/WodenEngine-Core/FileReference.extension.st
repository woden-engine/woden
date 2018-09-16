Extension { #name : #FileReference }

{ #category : #'*WodenEngine-Core' }
FileReference >> concretizeWodenSRGBTextureWithResourceCache: resourceCache [
	^ resourceCache loadSRGBTexture: self
]

{ #category : #'*WodenEngine-Core' }
FileReference >> concretizeWodenTextureWithResourceCache: resourceCache [
	^ resourceCache loadTexture: self
]

{ #category : #'*WodenEngine-Core' }
FileReference >> gtInspectorStTextScriptIn: composite [
	<gtInspectorPresentationOrder: 0>
	composite pharoScript
			title: 'Procedural Texture';
			doItReceiver: [ WDCPharoProceduralScriptContext forInspector ];
			display: [ self readStreamDo: [ :s | s contents ] ];
			act: [ :text |
					text selectionInterval: (1 to: text text size).
					text highlightEvaluateAndDo: [ :result | text selection: result ] ]
				icon: GLMUIThemeExtraIcons glamorousGo
				on: $G
				entitled: 'Do it all and go';
			installDefaultSelectionActions;
			act: [ :text |
				self ensureDelete; writeStreamDo: [ :s | s nextPutAll: text text asString ] ]
				icon: GLMUIThemeExtraIcons glamorousSave
				on: $s
				entitled: 'Save';
			when: [ self isFile and: [ self extension = 'sttex' ] ]
]
