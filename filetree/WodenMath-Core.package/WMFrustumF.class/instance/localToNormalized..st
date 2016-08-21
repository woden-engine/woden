window points
localToNormalized: local
	| clipPosition ndcPosition |
	clipPosition := matrix transformVector4: (WMVector4F x: local x y: local y z: local z w: 1.0).
	ndcPosition := WMVector3F x: clipPosition x / clipPosition w y: clipPosition y / clipPosition w z: clipPosition z / clipPosition w.
	^ ndcPosition * 0.5 + (WMVector3F x: 0.5 y: 0.5 z: 0.5)