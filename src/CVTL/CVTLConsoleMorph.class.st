Class {
	#name : #CVTLConsoleMorph,
	#superclass : #Morph,
	#instVars : [
		'font',
		'charExtent',
		'screen',
		'screenSize',
		'cursor',
		'whenKeyPressed'
	],
	#category : #'CVTL-UI'
}

{ #category : #accessing }
CVTLConsoleMorph >> charExtent [

	^ charExtent
]

{ #category : #accessing }
CVTLConsoleMorph >> charExtent: anObject [

	charExtent := anObject
]

{ #category : #private }
CVTLConsoleMorph >> characterAt: aPoint [

	| line |
	(self withinScreen: aPoint) ifFalse: [ ^ Character space ].
	line := screen at: aPoint y + 1.
	aPoint x >= line size ifTrue: [ ^ Character space ].
	^ line at: aPoint x + 1
]

{ #category : #private }
CVTLConsoleMorph >> characterAt: aPoint put: aCharacter [

	| line |
	(self withinScreen: aPoint) ifFalse: [ ^ self ].
	line := screen at: aPoint y + 1.
	line := aPoint x >= line size
		        ifTrue: [ 
		        line , (String new: aPoint x - line size withAll: Character space)
		        , aCharacter asString ]
		        ifFalse: [ 
			        (line copyFrom: 1 to: aPoint x) , aCharacter asString
			        , (line copyFrom: aPoint x + 2 to: line size) ].
	screen at: aPoint y + 1 put: line
]

{ #category : #api }
CVTLConsoleMorph >> clearScreen [

	screen := Array new: screenSize y withAll: ''.
	cursor := 0 @ 0
]

{ #category : #private }
CVTLConsoleMorph >> currentLine [
	^ screen at: cursor y + 1
]

{ #category : #private }
CVTLConsoleMorph >> currentLine: aString [
	screen at: cursor y + 1 put: aString
]

{ #category : #accessing }
CVTLConsoleMorph >> cursor [

	^ cursor
]

{ #category : #accessing }
CVTLConsoleMorph >> cursor: anObject [

	cursor := anObject
]

{ #category : #private }
CVTLConsoleMorph >> defaultFont [
	^ StandardFonts codeFont
]

{ #category : #private }
CVTLConsoleMorph >> defaultScreenSize [
	^ 80 @ 25
]

{ #category : #drawing }
CVTLConsoleMorph >> drawCursorOn: aCanvas [

	| pos c |
	c := self characterAt: cursor.
	pos := self topLeft + (cursor * charExtent).
	aCanvas fillRectangle: (pos extent: charExtent) color: self textColor.
	aCanvas
		drawString: c asString
		at: pos
		font: font
		color: self color
]

{ #category : #drawing }
CVTLConsoleMorph >> drawOn: aCanvas [
	super drawOn: aCanvas.
	self drawScreenOn: aCanvas.
	self drawCursorOn: aCanvas
]

{ #category : #drawing }
CVTLConsoleMorph >> drawScreenOn: aCanvas [

	| pos |
	pos := self topLeft.
	screen do: [ :each | 
		aCanvas
			drawString: each
			at: pos
			font: font
			color: self textColor.
		pos := pos x @ (pos y + charExtent y) ]
]

{ #category : #geometry }
CVTLConsoleMorph >> extent: aPoint [

	| old |
	old := self extent.
	super extent: aPoint.
	aPoint = old ifTrue: [ ^ self ].
	screenSize := aPoint // charExtent.
	self clearScreen
]

{ #category : #accessing }
CVTLConsoleMorph >> font [

	^ font
]

{ #category : #accessing }
CVTLConsoleMorph >> font: anObject [

	font := anObject.
	self updateCharExtent.
	self updateExtent
]

{ #category : #api }
CVTLConsoleMorph >> goto: aPoint [

	(self withinScreen: aPoint) ifFalse: [ ^ cursor := 0 @ 0 ].
	cursor := aPoint
]

{ #category : #'event handling' }
CVTLConsoleMorph >> handlesKeyboard: evt [

	^ true
]

{ #category : #'event handling' }
CVTLConsoleMorph >> handlesMouseDown: evt [
	^ true
]

{ #category : #initialization }
CVTLConsoleMorph >> initialize [
	super initialize.
	self color: Color black.
	screenSize := self defaultScreenSize.
	self clearScreen.
	font := self defaultFont.
	self updateCharExtent.
	self updateExtent
]

{ #category : #'event handling' }
CVTLConsoleMorph >> keyDown: event [

	| c |
	c := event keyCharacter asciiValue.
	(#( 8 13 ) includes: c) ifFalse: [ ^ self ].
	whenKeyPressed ifNotNil: [ 
		whenKeyPressed value: event keyCharacter asciiValue ]
]

{ #category : #'event handling' }
CVTLConsoleMorph >> keyStroke: event [

	whenKeyPressed ifNotNil: [ 
		whenKeyPressed value: event keyCharacter asciiValue ]
]

{ #category : #'event handling' }
CVTLConsoleMorph >> mouseDown: evt [

	self activeHand newKeyboardFocus: self
]

{ #category : #private }
CVTLConsoleMorph >> newLine [

	| line |
	(self withinScreen: cursor) ifFalse: [ ^ self ].
	line := self currentLine.
	line := line copyFrom: 1 to: cursor x.
	self currentLine: line.
	cursor := 0 @ (cursor y + 1).
	cursor y < screenSize y ifTrue: [ ^ self ].
	self scroll: 1.
	cursor := 0 @ (screenSize y - 1)
]

{ #category : #api }
CVTLConsoleMorph >> put: aString [

	aString do: [ :each | 
		(each = Character lf or: [ each = Character cr ])
			ifTrue: [ self newLine ]
			ifFalse: [ self putChar: each ] ]
]

{ #category : #api }
CVTLConsoleMorph >> putAsciiValue: anInteger [

	anInteger = Character lf asciiValue ifTrue: [ ^ self ].
	anInteger = Character cr asciiValue ifTrue: [ 
		self newLine.
		^ self changed ].
	anInteger = Character backspace asciiValue ifTrue: [ 
		cursor x > 0 ifTrue: [ self goto: cursor x - 1 @ cursor y ].
		^ self changed ].
	self putChar: (Character value: anInteger).
	self changed
]

{ #category : #private }
CVTLConsoleMorph >> putChar: aCharacter [

	self characterAt: cursor put: aCharacter.
	cursor := cursor + (1 @ 0).
	(self withinScreen: cursor) ifTrue: [ ^ self ].
	cursor x >= screenSize x ifTrue: [ cursor := 0 @ (cursor y + 1) ].
	cursor y < screenSize y ifTrue: [ ^ self ].
	self scroll: 1.
	cursor := 0 @ (screenSize y - 1)
]

{ #category : #accessing }
CVTLConsoleMorph >> screen [

	^ screen
]

{ #category : #accessing }
CVTLConsoleMorph >> screen: anObject [

	screen := anObject
]

{ #category : #accessing }
CVTLConsoleMorph >> screenSize [

	^ screenSize
]

{ #category : #accessing }
CVTLConsoleMorph >> screenSize: anObject [

	screenSize := anObject.
	self clearScreen.
	self updateExtent
]

{ #category : #private }
CVTLConsoleMorph >> scroll: anInteger [

	anInteger >= screenSize y ifTrue: [ ^ self clearScreen ].
	screen := (screen
		           copyFrom: screen size - (screenSize y - anInteger - 1)
		           to: screen size) , (Array new: anInteger withAll: '')
]

{ #category : #private }
CVTLConsoleMorph >> textColor [
	^ Color green
]

{ #category : #private }
CVTLConsoleMorph >> updateCharExtent [
	charExtent := (font linearWidthOf: $M) @ font height
]

{ #category : #private }
CVTLConsoleMorph >> updateExtent [

	super extent: screenSize * charExtent
]

{ #category : #accessing }
CVTLConsoleMorph >> whenKeyPressed [

	^ whenKeyPressed
]

{ #category : #accessing }
CVTLConsoleMorph >> whenKeyPressed: anObject [

	whenKeyPressed := anObject
]

{ #category : #testing }
CVTLConsoleMorph >> withinScreen: aPoint [

	^ aPoint >= (0 @ 0) and: [ aPoint < screenSize ]
]
