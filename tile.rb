require "colorize"

class Tile
  attr_reader :revealed, :flagged, :is_bomb
  attr_accessor :num_adj_bombs

  def initialize(is_bomb = false)
    @revealed = false
    @is_bomb = is_bomb
    @flagged = false
    @num_adj_bombs = nil
  end

  def self.random_tile
    Tile.new([true, false].sample)
  end

  def to_s
    if @flagged
      return "F".colorize(:yellow)
    else
      if @revealed
        return "#{@num_adj_bombs}".colorize(:green)
      else
        if @is_bomb
          return "B".colorize(:white)
        else
          return "H".colorize(:red)
        end
      end
    end
  end

  def reveal_tile
    @revealed = true
  end

  def toggle_flag
    @flagged = !@flagged
  end
end
