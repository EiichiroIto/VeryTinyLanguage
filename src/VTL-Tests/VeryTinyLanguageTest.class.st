"
A CVTLTest is a test class for testing the behavior of CVTL
"
Class {
	#name : #VeryTinyLanguageTest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #constants }
VeryTinyLanguageTest >> defaultProgramTop [

	^ 16r108
]

{ #category : #constants }
VeryTinyLanguageTest >> defaultRandomSeed [

	^ 12345
]

{ #category : #constants }
VeryTinyLanguageTest >> memorySize [

	^ 1024 * 32
]

{ #category : #'instance creation' }
VeryTinyLanguageTest >> newContext: anInteger [

	^ VTLContext position: anInteger
]

{ #category : #'instance creation' }
VeryTinyLanguageTest >> newMemory: anInteger [

	^ VTLMemory new
		  allocate: anInteger;
		  yourself
]

{ #category : #'instance creation' }
VeryTinyLanguageTest >> newObj [

	^ VeryTinyLanguage new
]

{ #category : #'instance creation' }
VeryTinyLanguageTest >> newStatus [

	^ VTLStatus new
]

{ #category : #'instance creation' }
VeryTinyLanguageTest >> newUI [

	^ VTLNonInteractiveUI new
]

{ #category : #private }
VeryTinyLanguageTest >> setupFor: aCVTL [

	| memory |
	memory := self newMemory: self memorySize.
	aCVTL memory: memory.
	aCVTL programTop: self defaultProgramTop memorySize: self memorySize.
	memory wordAt: aCVTL randomAddress put: self defaultRandomSeed
]

{ #category : #private }
VeryTinyLanguageTest >> setupProgram1 [

	| obj memory ptr |
	obj := self newObj.
	memory := self newMemory: 300.
	obj memory: memory.
	obj memoryLimit: 300.
	obj boundary: obj programTop.
	ptr := obj boundary.
	memory wordAt: ptr put: 100.
	memory copyString: ' X=5' to: ptr + 2.
	ptr := ptr + 2 + 4 + 1.
	memory wordAt: ptr put: 110.
	memory copyString: ' Y=12' to: ptr + 2.
	ptr := ptr + 2 + 5 + 1.
	memory wordAt: ptr put: 120.
	memory copyString: ' Z=X+Y' to: ptr + 2.
	ptr := ptr + 2 + 6 + 1.
	obj boundary: ptr.
	^ obj
]

{ #category : #private }
VeryTinyLanguageTest >> setupProgram2 [

	| obj ui ptr |
	obj := self newObj.
	ui := self newUI.
	obj ui: ui.
	self setupFor: obj.
	ptr := obj boundary.
	obj memory wordAt: ptr put: 10.
	obj memory copyString: ' ?="BAKA"' to: ptr + 2.
	ptr := ptr + 2 + 10.
	obj memory wordAt: ptr put: 20.
	obj memory copyString: ' #=20' to: ptr + 2.
	ptr := ptr + 2 + 6.
	obj boundary: ptr.
	^ obj
]

{ #category : #tests }
VeryTinyLanguageTest >> testAddressForAsciiValue [

	| obj r |
	VeryTinyLanguage initialize.
	obj := self newObj.
	r := obj addressForAsciiValue: $& asciiValue.
	self assert: r equals: obj boundaryAddress.
	r := obj addressForAsciiValue: $# asciiValue.
	self assert: r equals: obj currentLineNoAddress.
	r := obj addressForAsciiValue: $* asciiValue.
	self assert: r equals: obj memoryLimitAddress.
	r := obj addressForAsciiValue: $' asciiValue.
	self assert: r equals: obj randomAddress.
	r := obj addressForAsciiValue: $% asciiValue.
	self assert: r equals: obj remainderAddress.
	r := obj addressForAsciiValue: $! asciiValue.
	self assert: r equals: obj savedLineNoAddress.
	self
		assert: (obj addressForAsciiValue: $@ asciiValue)
		equals: 16r0004.
	self
		assert: (obj addressForAsciiValue: $@ asciiValue)
		equals: 16r0004.
	self
		assert: (obj addressForAsciiValue: $A asciiValue)
		equals: 16r0006.
	self
		assert: (obj addressForAsciiValue: $B asciiValue)
		equals: 16r0008.
	self
		assert: (obj addressForAsciiValue: $C asciiValue)
		equals: 16r000A.
	self
		assert: (obj addressForAsciiValue: $D asciiValue)
		equals: 16r000C.
	self
		assert: (obj addressForAsciiValue: $E asciiValue)
		equals: 16r000E.
	self
		assert: (obj addressForAsciiValue: $F asciiValue)
		equals: 16r0010.
	self
		assert: (obj addressForAsciiValue: $G asciiValue)
		equals: 16r0012.
	self
		assert: (obj addressForAsciiValue: $H asciiValue)
		equals: 16r0014.
	self
		assert: (obj addressForAsciiValue: $I asciiValue)
		equals: 16r0016.
	self
		assert: (obj addressForAsciiValue: $J asciiValue)
		equals: 16r0018.
	self
		assert: (obj addressForAsciiValue: $K asciiValue)
		equals: 16r001A.
	self
		assert: (obj addressForAsciiValue: $L asciiValue)
		equals: 16r001C.
	self
		assert: (obj addressForAsciiValue: $M asciiValue)
		equals: 16r001E.
	self
		assert: (obj addressForAsciiValue: $N asciiValue)
		equals: 16r0020.
	self
		assert: (obj addressForAsciiValue: $O asciiValue)
		equals: 16r0022.
	self
		assert: (obj addressForAsciiValue: $P asciiValue)
		equals: 16r0024.
	self
		assert: (obj addressForAsciiValue: $Q asciiValue)
		equals: 16r0026.
	self
		assert: (obj addressForAsciiValue: $R asciiValue)
		equals: 16r0028.
	self
		assert: (obj addressForAsciiValue: $S asciiValue)
		equals: 16r002A.
	self
		assert: (obj addressForAsciiValue: $T asciiValue)
		equals: 16r002C.
	self
		assert: (obj addressForAsciiValue: $U asciiValue)
		equals: 16r002E.
	self
		assert: (obj addressForAsciiValue: $V asciiValue)
		equals: 16r0030.
	self
		assert: (obj addressForAsciiValue: $W asciiValue)
		equals: 16r0032.
	self
		assert: (obj addressForAsciiValue: $X asciiValue)
		equals: 16r0034.
	self
		assert: (obj addressForAsciiValue: $Y asciiValue)
		equals: 16r0036.
	self
		assert: (obj addressForAsciiValue: $Z asciiValue)
		equals: 16r0038.
	self
		assert: (obj addressForAsciiValue: $[ asciiValue)
		equals: 16r003A.
	self
		assert: (obj addressForAsciiValue: $\ asciiValue)
		equals: 16r003C.
	self
		assert: (obj addressForAsciiValue: $] asciiValue)
		equals: 16r003E.
	self
		assert: (obj addressForAsciiValue: $^ asciiValue)
		equals: 16r0040.
	self
		assert: (obj addressForAsciiValue: $_ asciiValue)
		equals: 16r0042.
	self
		assert: (obj addressForAsciiValue: Character space asciiValue)
		equals: 16r0044.
	self
		assert: (obj addressForAsciiValue: $! asciiValue)
		equals: 16r0046.
	self
		assert: (obj addressForAsciiValue: $" asciiValue)
		equals: 16r0048.
	self
		assert: (obj addressForAsciiValue: $# asciiValue)
		equals: 16r004A.
	self
		assert: (obj addressForAsciiValue: $$ asciiValue)
		equals: 16r004C.
	self
		assert: (obj addressForAsciiValue: $% asciiValue)
		equals: 16r004E.
	self
		assert: (obj addressForAsciiValue: $& asciiValue)
		equals: 16r0050.
	self
		assert: (obj addressForAsciiValue: $' asciiValue)
		equals: 16r0052.
	self
		assert: (obj addressForAsciiValue: $( asciiValue)
		equals: 16r0054.
	self
		assert: (obj addressForAsciiValue: $) asciiValue)
		equals: 16r0056.
	self
		assert: (obj addressForAsciiValue: $* asciiValue)
		equals: 16r0058.
	self
		assert: (obj addressForAsciiValue: $+ asciiValue)
		equals: 16r005A.
	self
		assert: (obj addressForAsciiValue: $, asciiValue)
		equals: 16r005C.
	self
		assert: (obj addressForAsciiValue: $- asciiValue)
		equals: 16r005E.
	self
		assert: (obj addressForAsciiValue: $. asciiValue)
		equals: 16r0060.
	self
		assert: (obj addressForAsciiValue: $/ asciiValue)
		equals: 16r0062.
	self
		assert: (obj addressForAsciiValue: $0 asciiValue)
		equals: 16r0064.
	self
		assert: (obj addressForAsciiValue: $1 asciiValue)
		equals: 16r0066.
	self
		assert: (obj addressForAsciiValue: $2 asciiValue)
		equals: 16r0068.
	self
		assert: (obj addressForAsciiValue: $3 asciiValue)
		equals: 16r006A.
	self
		assert: (obj addressForAsciiValue: $4 asciiValue)
		equals: 16r006C.
	self
		assert: (obj addressForAsciiValue: $5 asciiValue)
		equals: 16r006E.
	self
		assert: (obj addressForAsciiValue: $6 asciiValue)
		equals: 16r0070.
	self
		assert: (obj addressForAsciiValue: $7 asciiValue)
		equals: 16r0072.
	self
		assert: (obj addressForAsciiValue: $8 asciiValue)
		equals: 16r0074.
	self
		assert: (obj addressForAsciiValue: $9 asciiValue)
		equals: 16r0076.
	self
		assert: (obj addressForAsciiValue: $: asciiValue)
		equals: 16r0078.
	self
		assert: (obj addressForAsciiValue: $; asciiValue)
		equals: 16r007A.
	self
		assert: (obj addressForAsciiValue: $< asciiValue)
		equals: 16r007C.
	self
		assert: (obj addressForAsciiValue: $= asciiValue)
		equals: 16r007E.
	self
		assert: (obj addressForAsciiValue: $> asciiValue)
		equals: 16r0080
]

{ #category : #tests }
VeryTinyLanguageTest >> testBoundary [

	| obj memory |
	obj := self newObj.
	memory := self newMemory: 256.
	obj memory: memory.
	obj boundary: 16r1234.
	self assert: obj boundary equals: 16r1234.
	self assert: (memory byteAt: obj boundaryAddress) equals: 16r34.
	self assert: (memory byteAt: obj boundaryAddress + 1) equals: 16r12
]

{ #category : #tests }
VeryTinyLanguageTest >> testBoundaryAddress [

	self assert: self newObj boundaryAddress equals: 16r50
]

{ #category : #tests }
VeryTinyLanguageTest >> testBreak [

	| obj |
	obj := self newObj.
	obj ui: self newUI.
	obj status beStepping.
	obj break.
	self assert: obj status isPrompted.
	self assert: obj ui outputString equals: '
BREAK
'
]

{ #category : #tests }
VeryTinyLanguageTest >> testCurrentLineNo [

	| obj memory |
	obj := self newObj.
	memory := self newMemory: 256.
	obj memory: memory.
	obj currentLineNo: 16r1234.
	self assert: obj currentLineNo equals: 16r1234.
	self assert: (memory byteAt: obj currentLineNoAddress) equals: 16r34.
	self assert: (memory byteAt: obj currentLineNoAddress + 1) equals: 16r12
]

{ #category : #tests }
VeryTinyLanguageTest >> testCurrentLineNoAddress [

	self assert: self newObj currentLineNoAddress equals: 16r4a
]

{ #category : #tests }
VeryTinyLanguageTest >> testDecimalContext [

	| obj num context |
	obj := self newObj.
	obj memory: (self newMemory: 256).
	obj memory in: [ :m | 
		m byteAt: 3 put: 49.
		m byteAt: 4 put: 48.
		m byteAt: 5 put: 50 ].
	context := self newContext: 0.
	num := obj decimalContext: context.
	self assert: context position equals: 0.
	self assert: num isNil.
	context position: 3.
	num := obj decimalContext: context.
	self assert: context position equals: 6.
	self assert: num equals: 102.
	context position: 4.
	num := obj decimalContext: context.
	self assert: context position equals: 6.
	self assert: num equals: 2
]

{ #category : #tests }
VeryTinyLanguageTest >> testDeleteLineNo [

	| obj org r |
	obj := self setupProgram1.
	org := obj programTop.
	r := obj deleteLineNo: 90.
	self assert: r equals: org.
	r := obj deleteLineNo: 105.
	self assert: r equals: org + 2 + 4 + 1.
	r := obj deleteLineNo: 115.
	self assert: r equals: org + 2 + 4 + 1 + 2 + 5 + 1.
	r := obj deleteLineNo: 130.
	self assert: r isNil.
	obj deleteLineNo: 110.
	self assert: obj boundary equals: org + 2 + 4 + 1 + 2 + 6 + 1.
	self assert: (obj memory wordAt: org) equals: 100.
	self assert: (obj memory byteAt: org + 2) equals: Character space asciiValue.
	self assert: (obj memory byteAt: org + 3) equals: $X asciiValue.
	self assert: (obj memory byteAt: org + 4) equals: $= asciiValue.
	self assert: (obj memory byteAt: org + 5) equals: $5 asciiValue.
	self assert: (obj memory byteAt: org + 6) equals: 0.
	self assert: (obj memory wordAt: org + 7) equals: 120.
	self assert: (obj memory byteAt: org + 9) equals: Character space asciiValue.
	self assert: (obj memory byteAt: org + 10) equals: $Z asciiValue.
	self assert: (obj memory byteAt: org + 11) equals: $= asciiValue.
	self assert: (obj memory byteAt: org + 12) equals: $X asciiValue.
	self assert: (obj memory byteAt: org + 13) equals: $+ asciiValue.
	self assert: (obj memory byteAt: org + 14) equals: $Y asciiValue.
	self assert: (obj memory byteAt: org + 15) equals: 0.
	obj deleteLineNo: 100.
	org := obj programTop.
	self assert: obj boundary equals: org + 2 + 6 + 1.
	self assert: (obj memory wordAt: org) equals: 120.
	self assert: (obj memory byteAt: org + 2) equals: Character space asciiValue.
	self assert: (obj memory byteAt: org + 3) equals: $Z asciiValue.
	self assert: (obj memory byteAt: org + 4) equals: $= asciiValue.
	self assert: (obj memory byteAt: org + 5) equals: $X asciiValue.
	self assert: (obj memory byteAt: org + 6) equals: $+ asciiValue.
	self assert: (obj memory byteAt: org + 7) equals: $Y asciiValue.
	self assert: (obj memory byteAt: org + 8) equals: 0.
	obj deleteLineNo: 120.
	org := obj programTop.
	self assert: obj boundary equals: org
]

{ #category : #tests }
VeryTinyLanguageTest >> testDoList [

	| obj |
	obj := self setupProgram1.
	obj ui: self newUI.
	obj doList.
	self assert: obj ui outputString equals: '100 X=5
110 Y=12
120 Z=X+Y
'
]

{ #category : #tests }
VeryTinyLanguageTest >> testDoOneCycle [

	self testDoOneCycle1.
	self testDoOneCycle2
]

{ #category : #tests }
VeryTinyLanguageTest >> testDoOneCycle1 [

	| obj ui p |
	obj := self newObj.
	self setupFor: obj.
	ui := self newUI.
	ui addInput: '100 X=1'.
	ui addInput: '110 Y=2'.
	ui addInput: '120 Z=X+Y'.
	ui addInput: '0'.
	obj ui: ui.
	obj doOneCycle.
	self assert: obj status isPrompted.
	self assert: obj status position isNil.
	obj currentLineNo: 100.
	p := obj findLine.
	self assert: (obj memory wordAt: p) equals: 100.
	self assert: (obj memory stringFrom: p + 2 until: 0) equals: ' X=1'.
	obj doOneCycle.
	self assert: obj status isPrompted.
	self assert: obj status position isNil.
	obj currentLineNo: 110.
	p := obj findLine.
	self assert: (obj memory wordAt: p) equals: 110.
	self assert: (obj memory stringFrom: p + 2 until: 0) equals: ' Y=2'.
	obj doOneCycle.
	self assert: obj status isPrompted.
	self assert: obj status position isNil.
	obj currentLineNo: 120.
	p := obj findLine.
	self assert: (obj memory wordAt: p) equals: 120.
	self assert: (obj memory stringFrom: p + 2 until: 0) equals: ' Z=X+Y'.
	obj doOneCycle.
	self assert: obj ui outputString equals: '100 X=1
110 Y=2
120 Z=X+Y
0
100 X=1
110 Y=2
120 Z=X+Y
'.
	self assert: obj status isPrompted.
	self assert: obj status position isNil
]

{ #category : #tests }
VeryTinyLanguageTest >> testDoOneCycle2 [

	| obj ui |
	obj := self newObj.
	self setupFor: obj.
	ui := self newUI.
	ui addInput: '100 X=123'.
	ui addInput: '#=1'.
	obj ui: ui.
	self
		assert:
		(obj memory wordAt: (obj addressForAsciiValue: $x asciiValue))
		equals: 0.
	obj doOneCycle.
	self assert: obj status isPrompted.
	self assert: obj status position isNil.
	obj doOneCycle.
	self assert: obj status isStepping.
	self assert: obj status position notNil.
	obj doOneCycle.
	self assert: obj status isPrompted.
	self assert: obj status position notNil.
	self
		assert:
		(obj memory wordAt: (obj addressForAsciiValue: $x asciiValue))
		equals: 123
]

{ #category : #tests }
VeryTinyLanguageTest >> testDoOneCycle3 [

	| obj |
	obj := self setupProgram2.
	obj ui addInput: '#=1'.
	obj doOneCycle.
	self assert: obj status isStepping.
	self assert: (obj variableAt: $#) equals: 10.
	self assert: obj ui outputString equals: '#=1
'.
	obj ui clear.
	obj doOneCycle.
	self assert: obj status isStepping.
	self assert: (obj variableAt: $#) equals: 20.
	obj doOneCycle.
	self assert: obj status isPrompted.
	self assert: (obj variableAt: $#) equals: 20.
	self assert: obj ui outputString equals: 'BAKA

OK
'
]

{ #category : #tests }
VeryTinyLanguageTest >> testEntryIntoLineNo [

	| obj memory |
	obj := self newObj.
	memory := self newMemory: 16.
	obj memory: memory.
	memory copyString: 'ABC' to: 3.
	memory byteAt: 15 put: 99.
	self
		assertCollection: memory core
		equals: #[ 0 0 0 65 66 67 0 0 0 0 0 0 0 0 0 99 ].
	obj entry: 3 into: 10 lineNo: 1000.
	self
		assertCollection: memory core
		equals: #[ 0 0 0 65 66 67 0 0 0 0 16rE8 3 65 66 67 0 ]
]

{ #category : #tests }
VeryTinyLanguageTest >> testEntryLineNo [

	| obj memory org pos |
	obj := self newObj.
	memory := self newMemory: 300.
	obj memory: memory.
	obj memoryLimit: 300.
	org := obj programTop.
	obj boundary: org.
	pos := obj lineBufferAddress + 2.
	memory copyString: 'Y=23' to: pos.
	obj entry: pos lineNo: 110.
	self assert: (memory wordAt: org) equals: 110.
	self assert: (memory byteAt: org + 2) equals: $Y asciiValue.
	self assert: (memory byteAt: org + 3) equals: $= asciiValue.
	self assert: (memory byteAt: org + 4) equals: $2 asciiValue.
	self assert: (memory byteAt: org + 5) equals: $3 asciiValue.
	self assert: (memory byteAt: org + 6) equals: 0.
	self assert: obj boundary equals: org + 7.
	memory copyString: 'X=1' to: pos.
	obj entry: pos lineNo: 100.
	self assert: (memory wordAt: org) equals: 100.
	self assert: (memory byteAt: org + 2) equals: $X asciiValue.
	self assert: (memory byteAt: org + 3) equals: $= asciiValue.
	self assert: (memory byteAt: org + 4) equals: $1 asciiValue.
	self assert: (memory byteAt: org + 5) equals: 0.
	self assert: (memory wordAt: org + 6) equals: 110.
	self assert: (memory byteAt: org + 8) equals: $Y asciiValue.
	self assert: (memory byteAt: org + 9) equals: $= asciiValue.
	self assert: (memory byteAt: org + 10) equals: $2 asciiValue.
	self assert: (memory byteAt: org + 11) equals: $3 asciiValue.
	self assert: (memory byteAt: org + 12) equals: 0.
	self assert: obj boundary equals: org + 13.
	memory copyString: 'Z=X+Y' to: pos.
	obj entry: pos lineNo: 120.
	self assert: (memory wordAt: org) equals: 100.
	self assert: (memory byteAt: org + 2) equals: $X asciiValue.
	self assert: (memory byteAt: org + 3) equals: $= asciiValue.
	self assert: (memory byteAt: org + 4) equals: $1 asciiValue.
	self assert: (memory byteAt: org + 5) equals: 0.
	self assert: (memory wordAt: org + 6) equals: 110.
	self assert: (memory byteAt: org + 8) equals: $Y asciiValue.
	self assert: (memory byteAt: org + 9) equals: $= asciiValue.
	self assert: (memory byteAt: org + 10) equals: $2 asciiValue.
	self assert: (memory byteAt: org + 11) equals: $3 asciiValue.
	self assert: (memory byteAt: org + 12) equals: 0.
	self assert: (memory wordAt: org + 13) equals: 120.
	self assert: (memory byteAt: org + 15) equals: $Z asciiValue.
	self assert: (memory byteAt: org + 16) equals: $= asciiValue.
	self assert: (memory byteAt: org + 17) equals: $X asciiValue.
	self assert: (memory byteAt: org + 18) equals: $+ asciiValue.
	self assert: (memory byteAt: org + 19) equals: $Y asciiValue.
	self assert: (memory byteAt: org + 20) equals: 0.
	self assert: obj boundary equals: org + 21
]

{ #category : #tests }
VeryTinyLanguageTest >> testExpressionContext [

	| obj pos context r |
	obj := self newObj.
	self setupFor: obj.
	pos := obj programTop.

	obj memory copyString: '1+2' to: pos.
	context := self newContext: pos.
	r := obj expressionContext: context.
	self assert: r equals: 3.
	self assert: context position equals: pos + 4.

	obj memory copyString: '1-2' to: pos.
	context := self newContext: pos.
	r := obj expressionContext: context.
	self assert: r equals: 65535.
	self assert: context position equals: pos + 4.

	obj memory copyString: '1-2)' to: pos.
	context := self newContext: pos.
	r := obj expressionContext: context.
	self assert: r equals: 65535.
	self assert: context position equals: pos + 4
]

{ #category : #tests }
VeryTinyLanguageTest >> testFactorContext [

	| obj pos context r |
	obj := self newObj.
	self setupFor: obj.
	pos := obj programTop.
	obj memory byteAt: pos put: 0.
	context := self newContext: pos.
	r := obj factorContext: context.
	self assert: r equals: 0.
	self assert: context position equals: pos.
	obj memory copyString: '123' to: pos.
	r := obj factorContext: context.
	self assert: r equals: 123.
	self assert: context position equals: pos + 3.
	obj memory copyString: 'B' to: pos.
	obj variableAt: $a put: 10.
	obj variableAt: $b put: 20.
	obj variableAt: $c put: 30.
	context := self newContext: pos.
	r := obj factorContext: context.
	self assert: r equals: 20.
	self assert: context position equals: pos + 1
]

{ #category : #tests }
VeryTinyLanguageTest >> testFileExtension [

	self assert: self newObj fileExtension isString
]

{ #category : #tests }
VeryTinyLanguageTest >> testFindLine [

	| obj r |
	obj := self setupProgram1.
	obj currentLineNo: 1.
	r := obj findLine.
	self assert: r equals: obj programTop.
	obj currentLineNo: 100.
	r := obj findLine.
	self assert: r equals: obj programTop.
	self assert: (obj memory byteAt: r) > 0.
	obj currentLineNo: 109.
	r := obj findLine.
	self assert: r equals: obj programTop + 7.
	obj currentLineNo: 110.
	r := obj findLine.
	self assert: r equals: obj programTop + 7.
	self assert: (obj memory byteAt: r - 1) equals: 0.
	self assert: (obj memory byteAt: r) > 0.
	obj currentLineNo: 111.
	r := obj findLine.
	self assert: r equals: obj programTop + 7 + 8.
	obj currentLineNo: 120.
	r := obj findLine.
	self assert: r equals: obj programTop + 7 + 8.
	self assert: (obj memory byteAt: r - 1) equals: 0.
	self assert: (obj memory byteAt: r) > 0.
	obj currentLineNo: 121.
	r := obj findLine.
	self assert: r isNil
]

{ #category : #tests }
VeryTinyLanguageTest >> testGetAsciiValue [

	| obj ui r |
	obj := self newObj.
	ui := self newUI.
	obj ui: ui.
	ui addInput: 'ABC'.
	r := obj getAsciiValue.
	self assert: r equals: $A asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $B asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: $C asciiValue.
	r := obj getAsciiValue.
	self assert: r equals: Character cr asciiValue.
	r := obj getAsciiValue.
	self assert: r isNil
]

{ #category : #tests }
VeryTinyLanguageTest >> testGetLineInto [

	| obj memory ui |
	obj := self newObj.
	memory := self newMemory: 10.
	obj memory: memory.
	ui := self newUI.
	obj ui: ui.
	ui input add: 'ABC'.
	memory byteAt: 8 put: 99.
	obj getLineInto: 5.
	self assert: (memory byteAt: 0) equals: 0.
	self assert: (memory byteAt: 1) equals: 0.
	self assert: (memory byteAt: 2) equals: 0.
	self assert: (memory byteAt: 3) equals: 0.
	self assert: (memory byteAt: 4) equals: 0.
	self assert: (memory byteAt: 5) equals: $A asciiValue.
	self assert: (memory byteAt: 6) equals: $B asciiValue.
	self assert: (memory byteAt: 7) equals: $C asciiValue.
	self assert: (memory byteAt: 8) equals: 0.
	self assert: (memory byteAt: 9) equals: 0
]

{ #category : #tests }
VeryTinyLanguageTest >> testIndexForAsciiValue [

	| obj dict v c tmp |
	obj := self newObj.
	dict := Dictionary new.
	0 to: 127 do: [ :each | 
		v := obj indexForAsciiValue: each.
		c := Character value: each.
		dict at: v ifPresent: [ :list | list add: c ] ifAbsentPut: [ 
			OrderedCollection new
				add: c;
				yourself ] ].
	dict keysDo: [ :each | 
		tmp := dict at: each.
		each = obj invalidCharacterIndex ifFalse: [ 
			(each between: 1 and: 26)
				ifTrue: [ self assert: tmp size equals: 2 ]
				ifFalse: [ self assert: tmp size equals: 1 ] ] ]
]

{ #category : #tests }
VeryTinyLanguageTest >> testInitialize [

	| obj |
	obj := VeryTinyLanguage basicNew.
	self assert: obj status isNil.
	obj initialize.
	self assert: obj status notNil
]

{ #category : #tests }
VeryTinyLanguageTest >> testInsertAt [

	| obj memory r |
	obj := self newObj.
	memory := self newMemory: 512.
	obj memory: memory.
	obj boundary: 291.
	obj memoryLimit: 300.
	r := obj insert: 4 at: 291.
	self assert: r.
	self assert: obj boundary equals: 295.
	memory byteAt: 290 put: 1.
	memory byteAt: 291 put: 2.
	memory byteAt: 292 put: 3.
	memory byteAt: 293 put: 4.
	r := obj insert: 3 at: 291.
	self assert: r.
	self assert: obj boundary equals: 298.
	self assert: (memory byteAt: 290) equals: 1.
	self assert: (memory byteAt: 291) equals: 2.
	self assert: (memory byteAt: 292) equals: 3.
	self assert: (memory byteAt: 293) equals: 4.
	self assert: (memory byteAt: 294) equals: 2.
	self assert: (memory byteAt: 295) equals: 3.
	self assert: (memory byteAt: 296) equals: 4.
	self assert: (memory byteAt: 297) equals: 0.
	r := obj insert: 3 at: 291.
	self deny: r.
	self assert: obj boundary equals: 298.
	self assert: (memory byteAt: 290) equals: 1.
	self assert: (memory byteAt: 291) equals: 2.
	self assert: (memory byteAt: 292) equals: 3.
	self assert: (memory byteAt: 293) equals: 4.
	self assert: (memory byteAt: 294) equals: 2.
	self assert: (memory byteAt: 295) equals: 3.
	self assert: (memory byteAt: 296) equals: 4.
	self assert: (memory byteAt: 297) equals: 0
]

{ #category : #tests }
VeryTinyLanguageTest >> testInvalidCharacterIndex [

	self assert: self newObj invalidCharacterIndex equals: 16r66
]

{ #category : #tests }
VeryTinyLanguageTest >> testLineBufferAddress [

	self assert: self newObj lineBufferAddress equals: 16r88
]

{ #category : #tests }
VeryTinyLanguageTest >> testMemory [

	| obj memory |
	obj := self newObj.
	self assert: obj memory isNil.
	memory := self newMemory: 256.
	obj memory: memory.
	self assert: obj memory identicalTo: memory
]

{ #category : #tests }
VeryTinyLanguageTest >> testMemoryLimit [

	| obj memory |
	obj := self newObj.
	memory := self newMemory: 256.
	obj memory: memory.
	obj memoryLimit: 16r1234.
	self assert: obj memoryLimit equals: 16r1234.
	self assert: (memory byteAt: obj memoryLimitAddress) equals: 16r34.
	self assert: (memory byteAt: obj memoryLimitAddress + 1) equals: 16r12
]

{ #category : #tests }
VeryTinyLanguageTest >> testMemoryLimitAddress [

	self assert: self newObj memoryLimitAddress equals: 16r58
]

{ #category : #tests }
VeryTinyLanguageTest >> testNewContext [

	| obj r |
	obj := self newObj.
	r := obj newContext: 123.
	self assert: r class equals: VTLContext.
	self assert: r position equals: 123
]

{ #category : #tests }
VeryTinyLanguageTest >> testNewStatus [

	| obj r |
	obj := self newObj.
	r := obj newStatus.
	self assert: r isPrompted
]

{ #category : #tests }
VeryTinyLanguageTest >> testNextLineOf [

	| obj org r |
	obj := self setupProgram1.
	org := obj programTop.
	r := obj nextLineOf: org.
	self assert: r equals: org + 7.
	r := obj nextLineOf: org + 7.
	self assert: r equals: org + 7 + 8.
	r := obj nextLineOf: org + 7 + 8.
	self assert: r equals: org + 7 + 8 + 9
]

{ #category : #tests }
VeryTinyLanguageTest >> testNumberBufferAddress [

	self assert: self newObj numberBufferAddress equals: 16r82
]

{ #category : #tests }
VeryTinyLanguageTest >> testProgramTop [

	| obj memory |
	obj := self newObj.
	memory := self newMemory: 256.
	obj memory: memory.
	obj programTop: 16r1234.
	self assert: obj programTop equals: 16r1234.
	self assert: (memory byteAt: obj programTopAddress) equals: 16r34.
	self assert: (memory byteAt: obj programTopAddress + 1) equals: 16r12
]

{ #category : #tests }
VeryTinyLanguageTest >> testProgramTopAddress [

	| obj |
	obj := self newObj.
	self
		assert: obj programTopAddress
		equals: (obj addressForAsciiValue: $= asciiValue)
]

{ #category : #tests }
VeryTinyLanguageTest >> testProgramTopMemorySize [

	| obj |
	obj := self newObj.
	obj memory: (self newMemory: 1000).
	self assert: obj boundary equals: 0.
	self assert: obj programTop equals: 0.
	self assert: obj memoryLimit equals: 0.
	obj programTop: 123 memorySize: 456.
	self assert: obj boundary equals: 123.
	self assert: obj programTop equals: 123.
	self assert: obj memoryLimit equals: 456
]

{ #category : #tests }
VeryTinyLanguageTest >> testPutAsciiValue [

	| obj ui |
	obj := self newObj.
	ui := self newUI.
	obj ui: ui.
	self assert: ui output isEmpty.
	obj putAsciiValue: 65.
	obj putAsciiValue: 66.
	self assertCollection: ui output asArray equals: #( 65 66 ).
	self assert: ui outputString equals: 'AB'
]

{ #category : #tests }
VeryTinyLanguageTest >> testPutCrlf [

	| obj ui |
	obj := self newObj.
	ui := self newUI.
	obj ui: ui.
	self assert: ui output isEmpty.
	obj putCrlf.
	self assertCollection: ui output asArray equals: #( 13 10 )
]

{ #category : #tests }
VeryTinyLanguageTest >> testPutNumber [

	| obj ui |
	obj := self newObj.
	ui := self newUI.
	obj ui: ui.
	obj memory: (self newMemory: 300).
	self assert: ui output isEmpty.
	obj putNumber: 123.
	self assertCollection: ui output asArray equals: #( 49 50 51 ).
	self assert: ui outputString equals: '123'
]

{ #category : #tests }
VeryTinyLanguageTest >> testPutUntilContext [

	| obj ui context |
	obj := self newObj.
	ui := self newUI.
	obj ui: ui.
	obj memory: (self newMemory: 300).
	self assert: ui output isEmpty.
	obj memory copyString: 'ABCDE' to: 290.
	context := self newContext: 290.
	obj putUntil: $D asciiValue context: context.
	self assert: context position equals: 294.
	self assertCollection: ui output asArray equals: #( 65 66 67 )
]

{ #category : #tests }
VeryTinyLanguageTest >> testRandomAddress [

	self assert: self newObj randomAddress equals: 16r52
]

{ #category : #tests }
VeryTinyLanguageTest >> testRemainderAddress [

	self assert: self newObj remainderAddress equals: 16r4e
]

{ #category : #tests }
VeryTinyLanguageTest >> testSavedLineNoAddress [

	self assert: self newObj savedLineNoAddress equals: 16r46
]

{ #category : #tests }
VeryTinyLanguageTest >> testStatementContext [

	| obj pos ui context |
	obj := self newObj.
	self setupFor: obj.
	pos := obj programTop.
	obj memory wordAt: pos put: 0.
	obj memory copyString: '?="abc"' to: pos + 2.
	obj status topOfLine: pos.
	ui := self newUI.
	obj ui: ui.
	context := self newContext: pos + 2.
	obj statementContext: context.
	self assert: obj ui outputString equals: 'abc
'.
	self assert: context position equals: pos + 9.

	obj memory copyString: '?="abc";' to: pos + 2.
	ui := self newUI.
	obj ui: ui.
	context position: pos + 2.
	obj statementContext: context.
	self assert: obj ui outputString equals: 'abc'.
	self assert: context position equals: pos + 10
]

{ #category : #tests }
VeryTinyLanguageTest >> testStatus [

	| obj status |
	obj := self newObj.
	status := self newStatus.
	self assert: obj status isPrompted.
	obj status: status.
	self assert: obj status identicalTo: status
]

{ #category : #tests }
VeryTinyLanguageTest >> testTermContext [

	| obj pos context r |
	obj := self newObj.
	self setupFor: obj.
	pos := obj programTop.
	obj memory copyString: '+2' to: pos.
	context := self newContext: pos.
	r := obj term: 5 context: context.
	self assert: r equals: 7.
	self assert: context position equals: pos + 2.
	obj memory copyString: '-2' to: pos.
	context position: pos.
	r := obj term: 6 context: context.
	self assert: r equals: 4.
	self assert: context position equals: pos + 2.
	obj memory copyString: '*21' to: pos.
	context position: pos.
	r := obj term: 5 context: context.
	self assert: r equals: 105.
	self assert: context position equals: pos + 3.
	self assert: (obj memory wordAt: obj remainderAddress) equals: 0.
	obj memory copyString: '/3' to: pos.
	context position: pos.
	r := obj term: 7 context: context.
	self assert: r equals: 2.
	self assert: context position equals: pos + 2.
	self assert: (obj memory wordAt: obj remainderAddress) equals: 1.
	obj memory copyString: '=99' to: pos.
	context position: pos.
	r := obj term: 99 context: context.
	self assert: r equals: 1.
	self assert: context position equals: pos + 3.
	context position: pos.
	r := obj term: 98 context: context.
	self assert: r equals: 0.
	self assert: context position equals: pos + 3.
	obj memory copyString: '>99' to: pos.
	context position: pos.
	r := obj term: 98 context: context.
	self assert: r equals: 0.
	self assert: context position equals: pos + 3.
	context position: pos.
	r := obj term: 99 context: context.
	self assert: r equals: 1.
	self assert: context position equals: pos + 3.
	context position: pos.
	r := obj term: 100 context: context.
	self assert: r equals: 1.
	self assert: context position equals: pos + 3.
	obj memory copyString: '<100' to: pos.
	context position: pos.
	r := obj term: 99 context: context.
	self assert: r equals: 1.
	self assert: context position equals: pos + 4.
	context position: pos.
	r := obj term: 100 context: context.
	self assert: r equals: 0.
	self assert: context position equals: pos + 4
]

{ #category : #tests }
VeryTinyLanguageTest >> testUi [

	| obj arr |
	obj := self newObj.
	self assert: obj ui isNil.
	arr := #( 1 2 3 ).
	obj ui: arr.
	self assert: obj ui identicalTo: arr
]

{ #category : #tests }
VeryTinyLanguageTest >> testUpdateRandom [

	| obj |
	obj := self newObj.
	self setupFor: obj.
	self assert: (obj memory wordAt: obj randomAddress) equals: 12345.
	obj updateRandom: 123.
	self assert: (obj memory wordAt: obj randomAddress) equals: 16rB430
]

{ #category : #tests }
VeryTinyLanguageTest >> testVariableAt [

	| obj r |
	obj := self newObj.
	self setupFor: obj.
	r := obj variableAt: $=.
	self assert: r equals: self defaultProgramTop.
	r := obj variableAt: $&.
	self assert: r equals: self defaultProgramTop.
	r := obj variableAt: $*.
	self assert: r equals: self memorySize
]

{ #category : #tests }
VeryTinyLanguageTest >> testVariableAtPut [

	| obj |
	obj := self newObj.
	self setupFor: obj.
	obj variableAt: $* put: 16r1234.
	self assert: obj memoryLimit equals: 16r1234.
	obj variableAt: $& put: 500.
	self assert: obj boundary equals: 500
]

{ #category : #tests }
VeryTinyLanguageTest >> testVariableContext [

	| obj memory context pos arr |
	obj := self newObj.
	memory := self newMemory: 300.
	obj memory: memory.
	pos := obj programTop.
	context := self newContext: pos.
	memory byteAt: pos put: $a asciiValue.
	arr := obj variableContext: context.
	self assert: context position equals: pos + 1.
	self assert: arr first equals: $a asciiValue.
	self assert: arr second equals: 6.
	context position: pos.
	memory byteAt: pos put: $# asciiValue.
	arr := obj variableContext: context.
	self assert: context position equals: pos + 1.
	self assert: arr first equals: $# asciiValue.
	self assert: arr second equals: obj currentLineNoAddress
]
