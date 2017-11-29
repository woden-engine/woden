as yet unclassified
view: view dragControllerFor: anEvent
	| oldBox actualExpansion expandedBox forward isBoxTranslation fullTranslation expandDirection memento pivot transformation |
	oldBox := view editor selectionBox box copy.
	forward := view cameraTransform matrix thirdColumn negated.
	isBoxTranslation := (direction closeTo: forward) or:
		[ (direction closeTo: forward negated) or:
		[ direction closeTo: WMVector3D new] ].
	fullTranslation := WMVector3D new.
	expandDirection := WMVector3D x: direction x sign asFloat y: direction y sign asFloat z: direction z sign asFloat.

	memento := view editor selectionBox transformMemento.
	(isBoxTranslation not and: [ view editor selectionBox rotationMode ]) ifTrue: [
		pivot := oldBox center.
		^ WTGEDragRotate new
			pivotPoint: (view worldToWindow: pivot);
			onNewRotation: [ :rotation |
				view editor selection restoreTransformMemento: memento.
				view editor selection rotate: rotation axis: forward pivot: pivot.
			]
	].

	^ WTGEDragTranslate new
		depthPoint: node transform translation;
		onNewTranslation: [ :translation |
			view editor selection restoreTransformMemento: memento.
			isBoxTranslation ifTrue: [
				view editor selection translateBy: (view snapTranslation: translation).
			] ifFalse: [
				actualExpansion := translation * expandDirection.
				expandedBox := view snapBox: (self expand: actualExpansion direction: expandDirection box: oldBox).
				transformation := oldBox computeTransformationInto: expandedBox.
				view editor selection applyTransformation: transformation.
			].
		]