as yet unclassified
view: view dragControllerFor: anEvent
	| oldBox actualExpansion expandedBox forward isBoxTranslation |
	oldBox := view editor selectionBox copy.
	forward := view cameraTransform matrix thirdRow.
	isBoxTranslation := (direction closeTo: forward) or:
		[ (direction closeTo: forward negated) or:
		[ direction closeTo: WMVector3D new] ].

	^ WTGEDragTranslate new
		depthPoint: box center;
		onNewTranslation: [ :translation |
			isBoxTranslation ifTrue: [
				view editor selectionBox: (oldBox translatedBy: (view snapTranslation: translation))
			] ifFalse: [
				actualExpansion := translation * direction.
				expandedBox := view snapBox: (self expand: actualExpansion box: oldBox).
				view editor selectionBox: expandedBox.
			].
		]