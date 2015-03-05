define [
  "underscore",
  "renderer/properties",
  "./glyph",
], (_, Properties, Glyph) ->
  
  lv_counter = 0

  class LineView extends Glyph.View
    
    
    constructor: (x...) ->
        lv_counter += 1
        @lv_id = lv_counter
        console.log "creating LineView #{@lv_id}"
        super(x...)
    
    _fields: ['x', 'y']
    _properties: ['line']

    _map_data: () ->
      [@sx, @sy] = @renderer.map_to_screen(@x, @glyph.x.units, @y, @glyph.y.units)

    _render: (ctx, indices) ->
      drawing = false
      @props.line.set(ctx, @props)
      
      console.log "render LineView #{@lv_id}"
        
      for i in indices
        if !isFinite(@sx[i] + @sy[i]) and drawing
          ctx.stroke()
          ctx.beginPath()
          drawing = false
          continue

        if drawing
          ctx.lineTo(@sx[i], @sy[i])
        else
          ctx.beginPath()
          ctx.moveTo(@sx[i], @sy[i])
          drawing = true

      if drawing
        ctx.stroke()

    draw_legend: (ctx, x0, x1, y0, y1) ->
      @_generic_line_legend(ctx, x0, x1, y0, y1)

  class Line extends Glyph.Model
    default_view: LineView
    type: 'Line'
    
    constructor: (x...) ->
        console.log 'creating Line Model'
        super(x...)
    
    display_defaults: ->
      return _.extend {}, super(), @line_defaults

  class Lines extends Glyph.Collection
    model: Line
    
    constructor: (x...) ->
        console.log 'creating Line Collection'
        super(x...)

  return {
    Model: Line
    View: LineView
    Collection: new Lines()
  }
