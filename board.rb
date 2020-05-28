require_relative "tile"
require "byebug"

class Board
  attr_reader :size

  def initialize(size = 9)
    @size = size
    @grid = Array.new(@size) { Array.new(@size) { Tile.random_tile } }
    @lose = false
    @num_tiles_revealed = @grid.map do |row|
      row.count { |tile| !tile.revealed && !tile.is_bomb }
    end.sum
  end

  def render
    puts "  #{(0...@size).to_a.join(" ")}".colorize(:blue)
    @grid.each_with_index do |row, i|
      puts "#{i}".colorize(:blue) + " #{row.join(" ")}"
    end
  end

  def gameover?
    self.all_revealed? || @lose
  end

  def valid_pos?(pos)
    x, y = pos
    x_valid = x >= 0 && x < @size
    y_valid = y >= 0 && y < @size
    x_valid && y_valid
  end

  def all_revealed?
    @num_tiles_revealed.zero?
  end

  def reveal(pos, visited = Array.new(@size) { Array.new(@size, false) }, first = true)
    x, y = pos
    return if !valid_pos?(pos)
    return if @grid[x][y].flagged || @grid[x][y].revealed
    return @lose = true if @grid[x][y].is_bomb && first
    return if @grid[x][y].is_bomb || visited[x][y]

    @grid[x][y].reveal_tile
    @num_tiles_revealed -= 1
    @grid[x][y].num_adj_bombs = self.find_num_adj_bombs(pos)

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
