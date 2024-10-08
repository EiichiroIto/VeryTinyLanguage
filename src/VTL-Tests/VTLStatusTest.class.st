"
A CVTLStatusTest is a test class for testing the behavior of CVTLStatus
"
Class {
	#name : #VTLStatusTest,
	#superclass : #TestCase,
	#category : #'VTL-Tests'
}

{ #category : #'instance creation' }
VTLStatusTest >> newObj [

	^ VTLStatus new
]

{ #category : #tests }
VTLStatusTest >> testBePrompted [

	| obj |
	obj := self newObj.
	obj state: nil.
	self deny: obj isPrompted.
	obj bePrompted.
	self assert: obj isPrompted.
	self deny: obj isStepping
]

{ #category : #tests }
VTLStatusTest >> testBeStepping [

	| obj |
	obj := self newObj.
	self assert: obj isPrompted.
	obj beStepping.
	self deny: obj isPrompted.
	self assert: obj isStepping
]

{ #category : #tests }
VTLStatusTest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj isPrompted.
	self assert: obj position isNil.
	self assert: obj topOfLine isNil
]

{ #category : #tests }
VTLStatusTest >> testIsPrompted [

	| obj |
	obj := self newObj.
	obj bePrompted.
	self assert: obj isPrompted.
	obj beStepping.
	self deny: obj isPrompted
]

{ #category : #tests }
VTLStatusTest >> testIsStepping [

	| obj |
	obj := self newObj.
	obj bePrompted.
	self deny: obj isStepping.
	obj beStepping.
	self assert: obj isStepping
]

{ #category : #tests }
VTLStatusTest >> testPosition [

	| obj |
	obj := self newObj.
	self assert: obj position isNil.
	obj position: 123.
	self assert: obj position equals: 123.
	obj position: 456.
	self assert: obj position equals: 456
]

{ #category : #tests }
VTLStatusTest >> testPrintOn [

	| obj stream |
	obj := self newObj.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self
		assert: stream contents
		equals: 'Status[state=prompted,position=nil,topOfLine=nil]'.
	obj beStepping.
	obj position: 123.
	obj topOfLine: 456.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self
		assert: stream contents
		equals: 'Status[state=stepping,position=123,topOfLine=456]'
]

{ #category : #tests }
VTLStatusTest >> testState [

	| obj |
	obj := self newObj.
	self assert: obj isPrompted.
	obj state: #abc.
	self assert: obj state equals: #abc.
	obj state: #def.
	self assert: obj state equals: #def
]

{ #category : #tests }
VTLStatusTest >> testTopOfLine [

	| obj |
	obj := self newObj.
	self assert: obj topOfLine isNil.
	obj topOfLine: 123.
	self assert: obj topOfLine equals: 123.
	obj topOfLine: 456.
	self assert: obj topOfLine equals: 456
]
