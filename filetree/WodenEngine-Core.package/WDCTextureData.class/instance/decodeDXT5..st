converting
decodeDXT5: level
	| levelWidth levelHeight resultBuffer result rowSize levelData numberOfRows destRow destBase srcRow srcIndex lookupColors levelPitch c0 c1 c0r c0g c0b c1r c1g c1b rowOffset value lookupIndex rowPitch lookupAlpha a0 a1 alphaData |
	levelWidth := level width.
	levelHeight := level height.
	levelData := level data.
	levelPitch := levelWidth * 4.
	resultBuffer := ByteArray new: levelPitch*levelHeight.
	rowSize := (levelWidth + 3) // 4.
	rowPitch := rowSize *16.
	numberOfRows := (levelHeight + 3) // 4.

	lookupAlpha := ByteArray new: 8.
	lookupColors := ByteArray new: 16.
	
	destRow := 1.
	srcRow := 1.
	1 to: numberOfRows do: [ :r |
		destBase := destRow.
		srcIndex := srcRow.
		1 to: rowSize do: [ :c |
			"Alpha data"
			a0 := levelData at: srcIndex.
			a1 := levelData at: srcIndex + 1.
			lookupAlpha at: 1 put: a0.
			lookupAlpha at: 2 put: a1.
			a0 > a1 ifTrue: [ 
				lookupAlpha at: 3 put: ((6*a0) + a1) // 7.
				lookupAlpha at: 4 put: ((5*a0) + (2*a1)) // 7.
				lookupAlpha at: 5 put: ((4*a0) + (3*a1)) // 7.
				lookupAlpha at: 6 put: ((3*a0) + (4*a1)) // 7.
				lookupAlpha at: 7 put: ((2*a0) + (5*a1)) // 7.
				lookupAlpha at: 8 put: ((a0) + (6*a1)) // 7.
			] ifFalse: [ 
				lookupAlpha at: 3 put: ((4*a0) + a1) // 5.
				lookupAlpha at: 4 put: ((3*a0) + (2*a1)) // 5.
				lookupAlpha at: 5 put: ((2*a0) + (3*a1)) // 5.
				lookupAlpha at: 6 put: ((a0) + (4*a1)) // 5.
				lookupAlpha at: 7 put: 0.
				lookupAlpha at: 8 put: 255.
			].
			
			alphaData := (levelData at: srcIndex + 2) |
				((levelData at: srcIndex + 3) << 8) |
				((levelData at: srcIndex + 4) << 16) |
				((levelData at: srcIndex + 5) << 24) |
				((levelData at: srcIndex + 6) << 32) |
				((levelData at: srcIndex + 7) << 40).

			rowOffset := 0.
			1 to: 4 do: [:i |
				0 to: 3 do: [ :j |
					lookupIndex := (alphaData bitAnd: 7) + 1.
					resultBuffer at: destBase + rowOffset + (j*4) + 3 put: (lookupAlpha at: lookupIndex).
					alphaData := alphaData >> 3.
				].
			
				rowOffset := rowOffset + levelPitch.
			].
						
			srcIndex := srcIndex + 8.
				
			"Color data"
			c0 := ((levelData at: srcIndex)) | ((levelData at: srcIndex + 1) << 8).
			c1 := ((levelData at: srcIndex + 2)) | (((levelData at: srcIndex + 3)) << 8).
			srcIndex := srcIndex + 4.

			c0r := ((c0 >> 11) bitAnd: 31) << 3.
			c0g := ((c0 >> 5) bitAnd: 63) << 2.
			c0b := (c0 bitAnd: 31) << 3.

			lookupColors at: 1 put: c0b.
			lookupColors at: 2 put: c0g.
			lookupColors at: 3 put: c0r.
			lookupColors at: 4 put: 255.

			c1r := ((c1 >> 11) bitAnd: 31)<<3.
			c1g := ((c1 >> 5) bitAnd: 63)<<2.
			c1b := (c1 bitAnd: 31)<<3.

			lookupColors at: 5 put: c1b.
			lookupColors at: 6 put: c1g.
			lookupColors at: 7 put: c1r.
			"lookupColors at: 8 put: 255."
			
			c0 > c1 ifTrue: [
				lookupColors at: 9 put: (2*c0b + c1b) // 3.
				lookupColors at: 10 put: (2*c0g + c1g) // 3.
				lookupColors at: 11 put: (2*c0r + c1r) // 3.
				"lookupColors at: 12 put: 255."

				lookupColors at: 13 put: (2*c1b + c0b) // 3.
				lookupColors at: 14 put: (2*c1g + c0g) // 3.
				lookupColors at: 15 put: (2*c1r + c0r) // 3.
				"lookupColors at: 16 put: 255."
			] ifFalse: [
				lookupColors at: 9 put: (c0b + c1b) // 2.
				lookupColors at: 10 put: (c0g + c1g) // 2.
				lookupColors at: 11 put: (c0r + c1r) // 2.
				"lookupColors at: 12 put: 255."

				lookupColors at: 13 put: 0.
				lookupColors at: 14 put: 0.
				lookupColors at: 15 put: 0.
				"lookupColors at: 16 put: 255."
			].
			
			rowOffset := 0.
			1 to: 4 do: [:i |
				value := levelData at: srcIndex.
				0 to: 3 do: [ :j |
					lookupIndex := (value bitAnd: 3) * 4 + 1.
					resultBuffer at: destBase + rowOffset + (j*4) put: (lookupColors at: lookupIndex).
					resultBuffer at: destBase + rowOffset + (j*4) + 1 put: (lookupColors at: lookupIndex + 1).
					resultBuffer at: destBase + rowOffset + (j*4) + 2 put: (lookupColors at: lookupIndex + 2).
					"resultBuffer at: destBase + rowOffset + (j*4) + 3 put: (lookupColors at: lookupIndex + 3)."
					value := value >> 2.
				].
			
				rowOffset := rowOffset + levelPitch.
				srcIndex := srcIndex + 1
			].

			destBase := destBase + 16
		].
	
		destRow := destRow + (levelPitch * 4).
		srcRow := srcRow + rowPitch.
	].
	
	result := Form extent: levelWidth @ levelHeight depth: 32.
	result unhibernate.
	LibC memCopy: resultBuffer to: result bits size: resultBuffer size.
	^ result