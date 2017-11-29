private
ensureThumbnailDataIsUpdated
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
