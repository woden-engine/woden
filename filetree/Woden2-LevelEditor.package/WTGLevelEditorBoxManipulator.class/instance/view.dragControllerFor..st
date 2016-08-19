as yet unclassified
view: view dragControllerFor: anEvent
	| oldBox actualExpansion expandedBox forward isBoxTranslation fullTranslation expandDirection |
	oldBox := view editor selectionBox box copy.
	forward := view cameraTransform matrix thirdColumn negated.
	isBoxTranslation := (direction closeTo: forward) or:
		[ (direction closeTo: forward negated) or:
		[ direction closeTo: WMVector3D new] ].
	fullTranslation := WMVector3D new.
	expandDirection := direction copy.

	^ WTGEDragTranslate new
		depthPoint: node transform translation;
		onNewTranslation: [ :translation |
			isBoxTranslation ifTrue: [
				view editor selectionBox transformIntoBox: (oldBox translatedBy: (view snapTranslation: translation))
			] ifFalse: [
				actualExpansion := translation * expandDirection.
				expandedBox := view snapBox: (self expand: actualExpansion direction: expandDirection box: oldBox).
				view editor selectionBox transformIntoBox: expandedBox.
			].
		]