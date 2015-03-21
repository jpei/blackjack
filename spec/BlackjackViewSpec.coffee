assert = chai.assert
expect = chai.expect

describe 'game', ->
  game = null
  gameView = null

  beforeEach ->
    game = new Game()
    gameView = new GameView({model: game})

  describe 'betting', ->
    it 'should add chips after a win', ->
      beforeChips = game.get 'chips'
      game.win()
      expect(game.get 'chips').to.equal beforeChips + game.get 'betSize'

    it 'should lose chips after a loss', ->
      beforeChips = game.get 'chips'
      game.lose()
      expect(game.get 'chips').to.equal beforeChips - game.get 'betSize'

    it 'should increase dealer\'s score when he hits', ->
      beforeScore = game.get('dealerHand').minScore()
      game.dealerHit()
      expect(game.get('dealerHand').minScore()).to.be.above beforeScore
  # describe 'flip on game over', ->
  #   it 'should reveal both cards when the game has ended', ->
  #     dealer = deck.dealDealer()

  #     assert.strictEqual (dealer.at(0).get('revealed')), true
