Class {
	#name : #VeryTinyLanguage,
	#superclass : #Object,
	#instVars : [
		'memory',
		'ui',
		'status'
	],
	#classVars : [
		'VariableTable'
	],
	#category : #'VTL-Core'
}

{ #category : #'class initialization' }
VeryTinyLanguage class >> initialize [
	"CVTL initialize"

	VariableTable := self variableTable
]

{ #category : #private }
VeryTinyLanguage class >> variableTable [

	| obj arr |
	obj := self new.
	arr := Array new: 256.
	0 to: 255 do: [ :each | 
	arr at: each + 1 put: (obj indexForAsciiValue: each) ].
	^ arr
]

{ #category : #accessing }
VeryTinyLanguage >> addressForAsciiValue: anInteger [

	VariableTable ifNil: [ self class initialize ].
	^ 2 * ((VariableTable at: anInteger + 1) + 2)
]

{ #category : #accessing }
VeryTinyLanguage >> boundary [

	^ memory wordAt: self boundaryAddress
]

{ #category : #accessing }
VeryTinyLanguage >> boundary: anInteger [

	memory wordAt: self boundaryAddress put: anInteger
]

{ #category : #constants }
VeryTinyLanguage >> boundaryAddress [

	^ 2 * (2 + $& asciiValue)
]

{ #category : #action }
VeryTinyLanguage >> break [

	self
		putCrlf;
		putAsciiValue: $B asciiValue;
		putAsciiValue: $R asciiValue;
		putAsciiValue: $E asciiValue;
		putAsciiValue: $A asciiValue;
		putAsciiValue: $K asciiValue;
		putCrlf.
	status bePrompted
]

{ #category : #accessing }
VeryTinyLanguage >> currentLineNo [

	^ memory wordAt: self currentLineNoAddress
]

{ #category : #accessing }
VeryTinyLanguage >> currentLineNo: anInteger [

	memory wordAt: self currentLineNoAddress put: anInteger
]

{ #category : #constants }
VeryTinyLanguage >> currentLineNoAddress [

	^ 2 * (2 + $# asciiValue)
]

{ #category : #private }
VeryTinyLanguage >> decimalContext: aContext [

	| c ch num |
	c := aContext byteIn: memory.
	(Character value: c) isDigit ifFalse: [ ^ nil ].
	num := 0.
	[ (ch := Character value: c) isDigit ] whileTrue: [ 
		num := num * 10.
		num := num + ch digitValue.
		aContext increment.
		c := aContext byteIn: memory ].
	^ num
]

{ #category : #private }
VeryTinyLanguage >> deleteLineNo: anInteger [

	| cur src dst boundary |
	self currentLineNo: anInteger.
	cur := self findLine.
	cur ifNil: [ ^ nil ].
	(memory wordAt: cur) = anInteger ifFalse: [ ^ cur ].
	src := self nextLineOf: cur.
	boundary := self boundary.
	dst := cur.
	[ src ~= boundary ] whileTrue: [ 
		memory copyByteFrom: src to: dst.
		src := src + 1.
		dst := dst + 1 ].
	self boundary: dst.
	^ cur
]

{ #category : #action }
VeryTinyLanguage >> doList [

	| context num boundary |
	context := self newContext: self programTop.
	boundary := self boundary.
	[ context position < boundary ] whileTrue: [ 
		num := memory wordAt: context position.
		self putNumber: num.
		context
			increment;
			increment.
		self putUntil: 0 context: context.
		self putCrlf ]
]

{ #category : #action }
VeryTinyLanguage >> doOneCycle [

	| pos context lineNo |
	status isPrompted ifTrue: [ 
		pos := self lineBufferAddress + 2.
		self getLineInto: pos.
		context := self newContext: pos.
		lineNo := self decimalContext: context.
		lineNo ifNotNil: [ 
			^ lineNo = 0
				  ifTrue: [ self doList ]
				  ifFalse: [ self entry: context position lineNo: lineNo ] ].
		status position: pos.
		pos := self lineBufferAddress.
		memory wordAt: pos put: 0.
		self currentLineNo: 0.
		status
			beStepping;
			topOfLine: pos ].
	status isStepping ifTrue: [ 
		self executeOnce
			ifTrue: [ 
				self
					putCrlf;
					putAsciiValue: $O asciiValue;
					putAsciiValue: $K asciiValue;
					putCrlf.
				status bePrompted ]
			ifFalse: [ 
				lineNo := memory wordAt: status topOfLine.
				self currentLineNo: lineNo ].
		^ self ].
	self error
]

{ #category : #private }
VeryTinyLanguage >> entry: anInteger into: anInteger2 lineNo: anInteger3 [

	| src dst tmp |
	memory wordAt: anInteger2 put: anInteger3.
	src := anInteger.
	dst := anInteger2 + 2.
	[ 
	tmp := memory copyByteFrom: src to: dst.
	src := src + 1.
	dst := dst + 1.
	tmp ~= 0 ] whileTrue
]

{ #category : #private }
VeryTinyLanguage >> entry: anInteger lineNo: anInteger2 [

	| cur count |
	cur := self deleteLineNo: anInteger2.
	cur ifNil: [ cur := self boundary ].
	(memory byteAt: anInteger) = 0 ifTrue: [ ^ self ].
	count := 3 + (memory countFrom: anInteger until: 0).
	(self insert: count at: cur) ifFalse: [ ^ self ].
	self entry: anInteger into: cur lineNo: anInteger2
]

{ #category : #private }
VeryTinyLanguage >> executeOnce [

	| lineNo r2 |
	self statementContext: (self newContext: status position).
	lineNo := self currentLineNo.
	r2 := memory wordAt: status topOfLine.
	(lineNo = 0 or: [ lineNo = r2 ])
		ifTrue: [ 
			status topOfLine = self lineBufferAddress ifTrue: [ ^ true ].
			status topOfLine: (self nextLineOf: status topOfLine).
			status topOfLine >= self boundary ifTrue: [ ^ true ] ]
		ifFalse: [ 
			lineNo := memory wordAt: status topOfLine.
			memory wordAt: self savedLineNoAddress put: lineNo + 1.
			status topOfLine: self findLine.
			status topOfLine ifNil: [ ^ true ] ].
	status position: 0.
	^ false
]

{ #category : #private }
VeryTinyLanguage >> expressionContext: aContext [

	| value c |
	value := self factorContext: aContext.
	[ (c := aContext byteIn: memory) ~= 0 and: [ c ~= $) asciiValue ] ] 
		whileTrue: [ 
			value := self term: value context: aContext.
			value := value bitAnd: 16rFFFF ].
	aContext increment.
	^ value
]

{ #category : #private }
VeryTinyLanguage >> factorContext: aContext [

	| c tmp |
	c := aContext byteIn: memory.
	c = 0 ifTrue: [ ^ 0 ].
	tmp := self decimalContext: aContext.
	tmp ifNotNil: [ ^ tmp ].
	c := aContext byteIn: memory.
	aContext increment.
	c = $? asciiValue ifTrue: [ 
		tmp := self lineBufferAddress.
		self getLineInto: tmp.
		^ self expressionContext: (self newContext: tmp) ].
	c = $$ asciiValue ifTrue: [ ^ self getAsciiValue ].
	c = $( asciiValue ifTrue: [ ^ self expressionContext: aContext ].
	aContext decrement.
	tmp := self variableContext: aContext.
	^ memory wordAt: tmp second
]

{ #category : #accessing }
VeryTinyLanguage >> fileExtension [

	^ 'vtl'
]

{ #category : #private }
VeryTinyLanguage >> findLine [

	| pos v boundary currentLine |
	boundary := self boundary.
	currentLine := self currentLineNo.
	pos := self programTop.
	[ pos ~= boundary ] whileTrue: [ 
		v := memory wordAt: pos.
		v >= currentLine ifTrue: [ 
			^ pos ].
		pos := self nextLineOf: pos ].
	^ nil
]

{ #category : #'input/output' }
VeryTinyLanguage >> getAsciiValue [

	^ ui getAsciiValue
]

{ #category : #'input/output' }
VeryTinyLanguage >> getLineInto: anInteger [

	| pos c |
	pos := 0.
	[ 
	c := self getAsciiValue.
	c ifNil: [ self error ].
	c = Character backspace asciiValue ifTrue: [ 
		pos > 0 ifTrue: [ 
			pos := pos - 1.
			self putAsciiValue: c ] ].
	c = Character cr asciiValue ifTrue: [ 
		memory byteAt: anInteger + pos put: 0.
		^ self putCrlf ].
	(c = 16r15 or: [ pos > 74 ]) ifTrue: [ 
		self putCrlf.
		pos := 0 ].
	c >= Character space asciiValue ifTrue: [ 
		memory byteAt: anInteger + pos put: c.
		self putAsciiValue: c.
		pos := pos + 1 ] ] repeat
]

{ #category : #private }
VeryTinyLanguage >> indexForAsciiValue: anInteger [

	anInteger = Character delete asciiValue ifTrue: [ 
		^ self invalidCharacterIndex ].
	anInteger = Character space asciiValue ifTrue: [ ^ 16r20 ].
	(anInteger between: $0 asciiValue and: $9 asciiValue) ifTrue: [ 
		^ anInteger ].
	(anInteger between: $! asciiValue and: $? asciiValue) ifTrue: [ 
		^ anInteger ].
	(anInteger between: $@ asciiValue and: $_ asciiValue) ifTrue: [ 
		^ anInteger - $@ asciiValue ].
	(anInteger between: $a asciiValue and: $z asciiValue) ifTrue: [ 
		^ anInteger - 16r60 ].
	^ self invalidCharacterIndex
]

{ #category : #initialization }
VeryTinyLanguage >> initialize [

	status := self newStatus
]

{ #category : #private }
VeryTinyLanguage >> insert: anInteger at: anInteger2 [

	| boundary limit src dst |
	boundary := self boundary.
	limit := self memoryLimit.
	boundary + anInteger >= limit ifTrue: [ ^ false ].
	src := boundary.
	boundary := boundary + anInteger.
	self boundary: boundary.
	dst := boundary.
	[ src ~= anInteger2 ] whileTrue: [ 
		dst := dst - 1.
		src := src - 1.
		memory copyByteFrom: src to: dst ].
	^ true
]

{ #category : #constants }
VeryTinyLanguage >> invalidCharacterIndex [

	^ 16r66
]

{ #category : #constants }
VeryTinyLanguage >> lineBufferAddress [

	^ 16r88
]

{ #category : #accessing }
VeryTinyLanguage >> memory [

	^ memory
]

{ #category : #accessing }
VeryTinyLanguage >> memory: anObject [

	memory := anObject
]

{ #category : #accessing }
VeryTinyLanguage >> memoryLimit [

	^ memory wordAt: self memoryLimitAddress
]

{ #category : #accessing }
VeryTinyLanguage >> memoryLimit: anInteger [

	memory wordAt: self memoryLimitAddress put: anInteger
]

{ #category : #constants }
VeryTinyLanguage >> memoryLimitAddress [

	^ 2 * (2 + $* asciiValue)
]

{ #category : #'instance creation' }
VeryTinyLanguage >> newContext: anInteger [

	^ VTLContext position: anInteger
]

{ #category : #'instance creation' }
VeryTinyLanguage >> newStatus [

	^ VTLStatus new
]

{ #category : #private }
VeryTinyLanguage >> nextLineOf: anInteger [

	| pos c |
	pos := anInteger + 2.
	[ 
	c := memory byteAt: pos.
	pos := pos + 1.
	c ~= 0 ] whileTrue.
	^ pos
]

{ #category : #constants }
VeryTinyLanguage >> numberBufferAddress [

	^ 16r82
]

{ #category : #accessing }
VeryTinyLanguage >> programTop [

	^ memory wordAt: self programTopAddress
]

{ #category : #accessing }
VeryTinyLanguage >> programTop: anInteger [

	memory wordAt: self programTopAddress put: anInteger
]

{ #category : #action }
VeryTinyLanguage >> programTop: anInteger memorySize: anInteger2 [

	self memoryLimit: anInteger2.
	self programTop: anInteger.
	self boundary: anInteger
]

{ #category : #constants }
VeryTinyLanguage >> programTopAddress [

	^ 2 * (2 + $= asciiValue)
]

{ #category : #'input/output' }
VeryTinyLanguage >> putAsciiValue: anInteger [

	ui putAsciiValue: anInteger
]

{ #category : #'input/output' }
VeryTinyLanguage >> putCrlf [

	self
		putAsciiValue: Character cr asciiValue;
		putAsciiValue: Character lf asciiValue
]

{ #category : #'input/output' }
VeryTinyLanguage >> putNumber: anInteger [

	| pos x y |
	x := anInteger.
	pos := self numberBufferAddress + 5.
	memory byteAt: pos put: 0.
	[ 
	y := x \\ 10.
	x := x // 10.
	pos := pos - 1.
	memory byteAt: pos put: y + $0 asciiValue ] doWhileTrue: [ x ~= 0 ].
	self putUntil: 0 context: (self newContext: pos)
]

{ #category : #'input/output' }
VeryTinyLanguage >> putUntil: anInteger context: aContext [

	| c |
	[ 
	c := aContext byteIn: memory.
	c ~= anInteger ] whileTrue: [ 
		self putAsciiValue: c.
		aContext increment ].
	aContext increment
]

{ #category : #constants }
VeryTinyLanguage >> randomAddress [

	^ 2 * (2 + $' asciiValue)
]

{ #category : #constants }
VeryTinyLanguage >> remainderAddress [

	^ 2 * (2 + $% asciiValue)
]

{ #category : #constants }
VeryTinyLanguage >> savedLineNoAddress [

	^ 2 * (2 + $! asciiValue)
]

{ #category : #private }
VeryTinyLanguage >> statementContext: aContext [

	| tmp c address c2 value |
	aContext position = 0 ifTrue: [ 
		aContext position: status topOfLine + 3 ].
	tmp := self variableContext: aContext.
	c := tmp first.
	address := tmp second.
	aContext increment.
	c2 := aContext byteIn: memory.
	c2 = $" asciiValue ifTrue: [ 
		aContext increment.
		self putUntil: $" asciiValue context: aContext.
		c2 := aContext byteIn: memory.
		c2 = $; asciiValue
			ifTrue: [ aContext increment ]
			ifFalse: [ self putCrlf ].
		^ self ].
	value := self expressionContext: aContext.
	c = $$ asciiValue ifTrue: [ 
		^ self putAsciiValue: (value bitAnd: 16rFF) ].
	c = $? asciiValue ifTrue: [ ^ self putNumber: value ].
	memory wordAt: address put: value.
	self updateRandom: value
]

{ #category : #accessing }
VeryTinyLanguage >> status [

	^ status
]

{ #category : #accessing }
VeryTinyLanguage >> status: anObject [

	status := anObject
]

{ #category : #private }
VeryTinyLanguage >> term: anInteger context: aContext [

	| c value |
	c := aContext byteIn: memory.
	aContext increment.
	value := self factorContext: aContext.
	c = $* asciiValue ifTrue: [ ^ anInteger * value ].
	c = $+ asciiValue ifTrue: [ ^ anInteger + value ].
	c = $- asciiValue ifTrue: [ ^ anInteger - value ].
	c = $/ asciiValue ifTrue: [ 
		memory wordAt: self remainderAddress put: anInteger \\ value.
		^ anInteger // value ].
	c = $= asciiValue ifTrue: [ ^ (anInteger = value) asBit ].
	c = $> asciiValue ifTrue: [ ^ (anInteger >= value) asBit ].
	^ (anInteger < value) asBit
]

{ #category : #accessing }
VeryTinyLanguage >> ui [

	^ ui
]

{ #category : #accessing }
VeryTinyLanguage >> ui: anObject [

	ui := anObject
]

{ #category : #private }
VeryTinyLanguage >> updateRandom: anInteger [

	| tmp |
	tmp := memory wordAt: self randomAddress.
	tmp := tmp + anInteger.
	tmp := (tmp << 8 bitAnd: 16rFF00) + (tmp >> 8 bitAnd: 16rFF).
	memory wordAt: self randomAddress put: tmp
]

{ #category : #accessing }
VeryTinyLanguage >> variableAt: aCharacter [

	| address |
	address := self addressForAsciiValue: aCharacter asciiValue.
	^ memory wordAt: address
]

{ #category : #accessing }
VeryTinyLanguage >> variableAt: aCharacter put: anInteger [

	| address |
	address := self addressForAsciiValue: aCharacter asciiValue.
	memory wordAt: address put: anInteger
]

{ #category : #private }
VeryTinyLanguage >> variableContext: aContext [

	| c value address |
	c := aContext byteIn: memory.
	aContext increment.
	c = $: asciiValue
		ifTrue: [ 
			value := self expressionContext: aContext.
			address := self boundary + (value * 2) ]
		ifFalse: [ address := self addressForAsciiValue: c ].
	^ Array with: c with: address
]
