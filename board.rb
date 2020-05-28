require_relative "tile"
require_relative "player"
require "byebug"

class Board
  attr_reader :size

  def initialize(size = 9)
    @size = size
    @grid = Array.new(@size) { Array.new(@size) { Tile.random_tile } }
    @gameover = false
  end

  def render
    puts "  #{(0...@size).to_a.join(" ")}".colorize(:blue)
    @grid.each_with_index do |row, i|
      puts "#{i}".colorize(:blue) + " #{row.join(" ")}"
    end
    "rendered"
  end

  def gameover?
    @gameover
  end

  def valid_pos?(pos)
    x, y = pos
    x_valid = x >= 0 && x < @size
    y_valid = y >= 0 && y < @size
    x_valid && y_valid
  end

  def reveal(pos, visited = Array.new(@size) { Array.new(@size, false) }, first = true)
    x, y = pos
    return if !valid_pos?(pos)
    return if @grid[x][y].flagged
    return @gameover = true if @grid[x][y].is_bomb && first
    @grid[x][y].reveal_tile if !@grid[x][y].is_bomb
    @grid[x][y].num_adj_bombs = self.find_num_adj_bombs(pos)

    return if @grid[x][y].is_bomb || visited[x][y]
    visited[x][y] = true
    self.reveal([x + 1, y], visited, false)
    self.reveal([x - 1, y], visited, false)
    self.reveal([x, y + 1], visited, false)
    self.reveal([x, y - 1], visited, false)
  end

  def find_num_adj_bombs(pos)
    x, y = pos
    top = x, y + 1
    bot = x, y - 1
    right = x + 1, y
    left = x - 1, y
    num_bombs = [top, bot, left, right].count { |loc| check_for_bomb(loc) }
  end

  def check_for_bomb(pos)
    if valid_pos?(pos)
      x, y = pos
      return @grid[x][y].is_bomb
    end
    false
  end

  def flag(pos)
    x, y = pos
    return false if !valid_pos?(pos)
    @grid[x][y].toggle_flag
  end
end

# 10.times do |variable|
#   puts ""
#   puts "new instance"
#   b = Board.new
#   x = (0...b.size).to_a.sample
#   y = (0...b.size).to_a.sample
#   b.reveal([x, y])
#   puts ""
#   b.render
# end
