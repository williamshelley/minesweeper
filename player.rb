class Player
  def self.get_cmd_and_pos
    input = []
    while input.length != 2
      print "Enter a cmd and a pos (reveal/flag x,y): "
      input = gets.chomp.split(" ")
    end
    cmd, pos = input
    pos = pos.split(",").map(&:to_i)
    [cmd, pos]
  end
end
