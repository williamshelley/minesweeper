require "fileutils"
require "yaml"
require_relative "board"
require_relative "player"

class Game
  GAMES_DIR = "game_history"

  def initialize(size = 9)
    @board = Board.new(size)
    FileUtils.mkdir_p(GAMES_DIR)
  end

  def save_game(output_file)
    File.open("./" + GAMES_DIR + "/" + output_file + ".yaml", "w") do |file|
      file.write(@board.to_yaml)
    end
  end

  def load_game(file)
    board = nil
    File.open("./" + GAMES_DIR + "/" + file + ".yaml", "r") do |file|
      board = YAML.load(file.read())
    end
    @board = board if board
  end

  def run
    cmd = nil
    while cmd != "exit" && !@board.gameover?
      @board.render
      print "enter a command (cmd *args): "
      cmd, *args = gets.chomp.split(" ")
      case cmd
      when "reveal"
        pos = args[0].split(",").map(&:to_i)
        @board.reveal(pos)
      when "flag"
        pos = args[0].split(",").map(&:to_i)
        @board.flag(pos)
      when "save"
        self.save_game(args.join("-"))
      when "load"
        self.load_game(args[0])
      end
    end

    puts "GAME OVER"
  end
end

game = Game.new(10)
game.run
