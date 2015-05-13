'use strict'

describe 'Filter: time', ->

  # load the filter's module
  beforeEach module 'volunteerTrackerHtmlApp'

  # initialize a new instance of the filter before each test
  time = {}
  beforeEach inject ($filter) ->
    time = $filter 'time'

  it 'should format date as am/pm time', ->
    text = '12:34'
    expect(time text).toBe ('12:34 PM')
