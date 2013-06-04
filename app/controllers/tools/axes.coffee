$ = require 'jqueryify'
{Tool} = require 'marking-surface'
shapeStyle = require '../../lib/shape-style'
Raphael = window.Raphael

class AxesTool extends Tool
  major: null
  minor: null
  dots: null

  markDefaults:
    p0: [-20, -20], p1: [-20, -20]
    p2: [-20, -20], p3: [-20, -20]

  cursors:
    'dots': 'move'

  initialize: ->
    @major = @addShape 'path', 'M 0 0', shapeStyle.line
    @minor = @addShape 'path', 'M 0 0', shapeStyle.line
    @dots = for i in [0...4]
      @addShape 'circle', 0, 0, 8, shapeStyle.dot

  onFirstClick: (e) ->
    {x, y} = @mouseOffset e
    points = if @clicks is 0 then ['p0', 'p1', 'p2', 'p3'] else ['p2', 'p3']
    @mark.set point, [x, y] for point in points

  onFirstDrag: (e) ->
    {x, y} = @mouseOffset e
    points = if @clicks is 0 then ['p1', 'p3'] else ['p3']
    @mark.set point, [x, y] for point in points

  isComplete: ->
    @clicks is 2

  'on drag dots': (e, shape) ->
    index = $.inArray shape, @dots
    {x, y} = @mouseOffset e
    @mark.set "p#{index}", [x, y]

  render: ->
    for point, i in ['p0', 'p1', 'p2', 'p3']
      @dots[i].attr cx: @mark[point][0], cy: @mark[point][1]

    majorPath = "M #{@mark.p0[0]} #{@mark.p0[1]}, L #{@mark.p1[0]} #{@mark.p1[1]}"
    minorPath = "M #{@mark.p2[0]} #{@mark.p2[1]}, L #{@mark.p3[0]} #{@mark.p3[1]}"

    @major.attr path: majorPath
    @minor.attr path: minorPath

    [intersect] = Raphael.pathIntersection majorPath, minorPath
    if intersect?
      label = "#{Math.abs Math.floor Raphael.angle @mark.p0..., @mark.p2..., intersect?.x, intersect?.y}°"
    else
      label = '...'

    # NOTE: Don't call the setter! It calls this render function.
    @mark.label = label

    @controls.moveTo [
      (@mark.p0[0] + @mark.p1[0] + @mark.p2[0] + @mark.p3[0]) / 4
      (@mark.p0[1] + @mark.p1[1] + @mark.p2[1] + @mark.p3[1]) / 4
    ]

module.exports = AxesTool
