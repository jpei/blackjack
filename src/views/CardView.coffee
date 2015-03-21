class window.CardView extends Backbone.View
  className: 'card'

  tagName: 'img'

  #template: _.template '<%= rankName %> of <%= suitName %>'
  template: _.template 'img/cards/<%= rankName %>-<%= suitName %>.png'

  initialize: -> @render()

  render: ->
    #@$el.html @template @model.attributes
    @$el.attr 'src', @template
      rankName:(@model.get('rankName')+'').toLowerCase()
      suitName:@model.get('suitName').toLowerCase()
    #@$el.addClass 'covered' unless @model.get 'revealed'
    @$el.attr 'src', 'img/card-back.png' unless @model.get 'revealed'

