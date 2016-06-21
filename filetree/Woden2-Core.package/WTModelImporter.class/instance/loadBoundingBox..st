as yet unclassified
loadBoundingBox: bboxData
	| min max |
	min := WMVector3F x: (bboxData at: 1) y: (bboxData at: 2) z: (bboxData at: 3).
	max := WMVector3F x: (bboxData at: 4) y: (bboxData at: 5) z: (bboxData at: 6).
	^ WMBox3DF min: min max: max