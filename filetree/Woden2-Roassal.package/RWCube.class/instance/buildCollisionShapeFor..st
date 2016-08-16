hooks
buildCollisionShapeFor: element
	| w h d |
	w := self widthFor: element.
	h := self heightFor: element.
	d := self depthFor: element.
	^ WDBoxCollisionShape halfExtent: (WDVector3 x: w *0.5 y: h*0.5 z: d*0.5).