Class {
	#name : #WDIGLTF2Constants,
	#superclass : #SharedPool,
	#classVars : [
		'GL_2_BYTES',
		'GL_3_BYTES',
		'GL_4_BYTES',
		'GL_BYTE',
		'GL_DOUBLE',
		'GL_FLOAT',
		'GL_INT',
		'GL_LINES',
		'GL_LINE_LOOP',
		'GL_LINE_STRIP',
		'GL_POINTS',
		'GL_POLYGON',
		'GL_QUADS',
		'GL_QUAD_STRIP',
		'GL_SHORT',
		'GL_TRIANGLES',
		'GL_TRIANGLE_FAN',
		'GL_TRIANGLE_STRIP',
		'GL_UNSIGNED_BYTE',
		'GL_UNSIGNED_INT',
		'GL_UNSIGNED_SHORT'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #'class initialization' }
WDIGLTF2Constants class >> initialize [
	"Data types"
	GL_BYTE					:= 16r1400.
	GL_UNSIGNED_BYTE		:= 16r1401.
	GL_SHORT					:= 16r1402.
	GL_UNSIGNED_SHORT		:= 16r1403.
	GL_INT						:= 16r1404.
	GL_UNSIGNED_INT			:= 16r1405.
	GL_FLOAT					:= 16r1406.
	GL_2_BYTES				:= 16r1407.
	GL_3_BYTES				:= 16r1408.
	GL_4_BYTES				:= 16r1409.
	GL_DOUBLE					:= 16r140A.

    "Primitives"
	GL_POINTS				:= 16r0000.
	GL_LINES				:= 16r0001.
	GL_LINE_LOOP			:= 16r0002.
	GL_LINE_STRIP		:= 16r0003.
	GL_TRIANGLES			:= 16r0004.
	GL_TRIANGLE_STRIP	:= 16r0005.
	GL_TRIANGLE_FAN		:= 16r0006.
	GL_QUADS				:= 16r0007.
	GL_QUAD_STRIP		:= 16r0008.
	GL_POLYGON			:= 16r0009.
]
