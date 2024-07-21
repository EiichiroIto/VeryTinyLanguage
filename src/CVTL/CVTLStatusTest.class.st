"
A CVTLStatusTest is a test class for testing the behavior of CVTLStatus
"
Class {
	#name : #CVTLStatusTest,
	#superclass : #TestCase,
	#category : #'CVTL-Tests'
}

{ #category : #'instance creation' }
CVTLStatusTest >> newObj [

	^ CVTLStatus new
]

{ #category : #tests }
CVTLStatusTest >> testAddress [

	| obj |
	obj := self newObj.
	self assert: obj address isNil.
	obj address: 123.
	self assert: obj address equals: 123.
	obj address: 456.
	self assert: obj address equals: 456
]

{ #category : #tests }
CVTLStatusTest >> testBePrompted [

	| obj |
	obj := self newObj.
	obj state: nil.
	self deny: obj isPrompted.
	obj bePrompted.
	self assert: obj isPrompted.
	self deny: obj isStepping
]

{ #category : #tests }
CVTLStatusTest >> testBeStepping [

	| obj |
	obj := self newObj.
	self assert: obj isPrompted.
	obj beStepping.
	self deny: obj isPrompted.
	self assert: obj isStepping
]

{ #category : #tests }
CVTLStatusTest >> testInitialize [

	| obj |
	obj := self newObj.
	self assert: obj isPrompted.
	self assert: obj pos isNil.
	self assert: obj address isNil
]

{ #category : #tests }
CVTLStatusTest >> testIsPrompted [

	| obj |
	obj := self newObj.
	obj bePrompted.
	self assert: obj isPrompted.
	obj beStepping.
	self deny: obj isPrompted
]

{ #category : #tests }
CVTLStatusTest >> testIsStepping [

	| obj |
	obj := self newObj.
	obj bePrompted.
	self deny: obj isStepping.
	obj beStepping.
	self assert: obj isStepping
]

{ #category : #tests }
CVTLStatusTest >> testPos [

	| obj |
	obj := self newObj.
	self assert: obj pos isNil.
	obj pos: 123.
	self assert: obj pos equals: 123.
	obj pos: 456.
	self assert: obj pos equals: 456
]

{ #category : #tests }
CVTLStatusTest >> testPrintOn [

	| obj stream |
	obj := self newObj.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self
		assert: stream contents
		equals: 'Status[state=prompted,pos=nil,address=nil]'.
	obj beStepping.
	obj pos: 123.
	obj address: 456.
	stream := WriteStream on: String new.
	obj printOn: stream.
	self
		assert: stream contents
		equals: 'Status[state=stepping,pos=123,address=456]'
]

{ #category : #tests }
CVTLStatusTest >> testState [

	| obj |
	obj := self newObj.
	self assert: obj isPrompted.
	obj state: #abc.
	self assert: obj state equals: #abc.
	obj state: #def.
	self assert: obj state equals: #def
]
