class window.Game extends Backbone.Model
  initialize: ->
    @set
      chips: 100
      betSize: 5
    @newGame()

  playerHit: ->
    if @get('status') is 'player'
      if @get('playerHand').minScore() < 21
        @get('playerHand').hit()
        if @get('playerHand').maxScore() is 21
          @playerStand()
        if @get('playerHand').minScore() > 21
          @lose()

  playerStand: ->
    if @get('status') is 'player'
      @set 'status', 'dealer'
      @dealerStart()

  dealerHit: ->
    @get('dealerHand').hit()
    if @get('dealerHand').minScore() > 21
      @win()

  dealerStart: ->
    @get('dealerHand').at(0).flip()
    while @get('dealerHand').maxScore() < 17 + @get('dealerHand').hasAce()
      @dealerHit()
    if @get('status') is 'dealer'
      playerScore = @get('playerHand').maxScore()
      dealerScore = @get('dealerHand').maxScore()
      if playerScore > dealerScore
        @win()
      else if playerScore is dealerScore
        @draw()
      else @lose()

  newGame: ->
    if @get('chips') > @get 'betSize'
      @set
        deck: new Deck()
      @set
        playerHand: @get('deck').dealPlayer()
        dealerHand: @get('deck').dealDealer()
        status: 'player'
      @checkBlackjack()

  checkBlackjack: ->
    if @get('dealerHand').isBlackjack() and @get('playerHand').isBlackjack()
      @get('dealerHand').at(0).flip()
      @draw()
    else if @get('dealerHand').isBlackjack()
      @get('dealerHand').at(0).flip()
      @lose()
    else if @get('playerHand').isBlackjack()
      @win(true)

  win: (special) ->
    @set 'chips', @get('chips') + (@get 'betSize')*(1+.5*!!special)
    @set 'status', 'win'
    #console.log @get 'chips' #fixme

  lose: ->
    @set 'chips', @get('chips') - @get 'betSize'
    @set 'status', 'lose'
    #console.log @get 'chips' #fixme

  draw: ->
    @set 'status', 'draw'
    #console.log @get 'chips' #fixme
