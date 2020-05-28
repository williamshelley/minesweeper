require_relative "board"
require_relative "player"

class Game
  def initialize(size = 9)
    @board = Board.new(size)
  end

  def run
    cmd = nil
    while cmd != "exit" && !@board.gameover?
      @board.render
      cmd, pos = Player.get_cmd_and_pos
      case cmd
      when "reveal"
        @board.reveal(pos)
      when "flag"
        @board.flag(pos)
      end
    end
    puts "GAME OVER"
  end
end

game = Game.new(10)
game.run
