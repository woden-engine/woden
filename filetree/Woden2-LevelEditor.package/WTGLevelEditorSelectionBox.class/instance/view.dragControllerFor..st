controllers
view: view dragControllerFor: anEvent
	| oldBox |
	oldBox := view editor selectionBox copy.
	^ WTGEDragTranslate new
		depthPoint: view editor selectionBox center;
		onNewTranslation: [ :translation | view editor selectionBox: (oldBox translatedBy: (view snapTranslation: translation)) ]