class window.GameView extends Backbone.View
  template: _.template '
    <span class = "chips">Chips: $<%=chips%> </span>
    <button class="hit-button">Hit</button>
    <button class="stand-button">Stand</button>
    <%= button %>
    <div class = "betSize">Bet Size: $<%=betSize%></div>
    <div class="player-hand-container"></div>
    <div class="dealer-hand-container"></div>
  '

  newGameTemplate: _.template '<button class= "newGame"><%= status %></button>'

  good: ->
    '#0C9917'
  neutral: ->
    '#BD80CC'
  bad: ->
    '#A62593'

  newGameText: ->
    switch @model.get 'status'
      when 'win' then (@options.color = @good()) and @newGameTemplate status:'YOU WIN!!!!!'
      when 'draw' then (@options.color = @neutral()) and @newGameTemplate status:'YOU DRAW ' + '\xAF\\_(\u30C4)_/\xAF' # '¯\\_(ツ)_/¯'
      when 'lose' then (@options.color = @bad()) and @newGameTemplate status:'YOU LOSE :('
      when 'bankrupt' then (@options.color = @bad()) and @newGameTemplate status:'THANKS FOR THE MONEY!!!!!'
      else ''

  events:
    'click .hit-button': -> @model.playerHit()
    'click .stand-button': -> @model.playerStand()

  initialize: ->
    @model.set 'name', prompt('What is your name?', 'Anonymous') or 'Anonymous'
    if @model.get('name') isnt 'Anonymous'
      @model.set 'chips', JSON.parse window.localStorage[@model.get 'name'] || @model.get('initChips') + ''
    @listenTo @model, 'change:status', @render
    @listenTo @model, 'change:chips', -> if window.localStorage then window.localStorage[@model.get 'name'] = JSON.stringify @model.get 'chips'
    @$el.on 'click', '.newGame', => @model.newGame()
    keyDown = [false, false, false] # space is 32, h is 72, s is 83
    $(document).keyup (evt) =>
      if evt.keyCode is 32 and not keyDown[0] and @model.get('status') in ['win', 'lose', 'draw']
        @model.newGame()
        evt.preventDefault()
        keyDown[0] = true
      if evt.keyCode is 72 and not keyDown[1]
        @model.playerHit()
        keyDown[1] = true
      if evt.keyCode is 83 and not keyDown[2]
        @model.playerStand()
        keyDown[2] = true
    $(document).keydown (evt) ->
      if evt.keyCode is 32
        keyDown[0] = false
      if evt.keyCode is 72
        keyDown[1] = false
      if evt.keyCode is 83
        keyDown[2] = false
    @options.color = @neutral()
    @model.newGame()
    @render()

  chipColor: ->
    chips = @model.get 'chips'
    initChips = @model.get 'initChips'
    if chips > initChips then @good()
    else if chips is initChips then @neutral()
    else @bad()

  render: ->
    @$el.html @template
      button:@newGameText()
      chips:@model.get 'chips'
      betSize:@model.get 'betSize'
    @$el.children('.chips').css('color', @chipColor())
    @$el.children('.newGame').css('color', @options.color)
    @$('.player-hand-container').html new HandView(collection: (@model.get 'playerHand'), name: @model.get 'name').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el
