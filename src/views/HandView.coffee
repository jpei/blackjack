class window.HandView extends Backbone.View
  className: 'hand'

  template: _.template '<h2><%= name %> (<span class="score"></span>)</h2>'

  initialize: (params) ->
    #@collection.set 'name', name or 'Dealer'
    @collection.on 'add remove change', => @render()
    @options.name = params.name || 'Dealer'
    @render()

  render: ->
    @$el.children().detach()
    @$el.html @template name:@options.name
    @$el.append @collection.map (card) ->
      new CardView(model: card).$el
    @$('.score').text @collection.maxScore()

