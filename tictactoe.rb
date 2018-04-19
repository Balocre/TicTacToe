###
# todo :
# make players beinga able to choose color
# @players = list of players
# @score ? après

class Game
  attr_reader :board, :player1, :player2

  def initialize

    available_colors = ['X', '0']

    puts "name of player 1 : "
    name = gets
    name.chomp!
    color = available_colors.shift
    @player1 = Player.new(name, color)

    #redundant, use anonymous function?
    puts "name of player2 : "
    name = gets
    name.chomp!
    color = color = available_colors.shift
    @player2 = Player.new(name, color)

    @players = [@player1, @player2]

    @board = Board.new
  end

  # this methods modifiy game's board state for player x
  def make_move(player)
    puts "#{player.name} plays !"
    # todo : add an exception for non integer values
    puts "cell row : "
    row = gets.to_i
    puts "cell col : "
    col = gets.to_i

    # check if board's matrix cell is void, otherwise tells the player to play somewhere else
    if @board.matrix[row][col].state != nil then
      puts "This cell is already occupied, play somewhere else!"
      make_move(player)
    else
      @board.modify_board_cell_state(row, col, player.color)
    end
  end

  def has_won?(player)
    # check rows
    for row in (0..@board.matrix.length-1)
      inspected_col = Array.new
      for col in (0..@board.matrix[0].length-1)
        inspected_col << @board.matrix[row][col].state
      end

      if inspected_col.all? {|cell| cell == player.color} then
        return true
      end
    end

    # check collumns
    for col in (0..@board.matrix.length-1)
      inspected_row = Array.new
      for row in (0..@board.matrix[0].length-1)
        inspected_row << @board.matrix[row][col].state
      end

      if inspected_row.all? {|cell| cell == player.color} then
        return true
      end
    end

    # check digonals
    puts [@board.matrix[0][0].state, @board.matrix[1][1].state, @board.matrix[2][2].state]
    if [@board.matrix[0][0].state, @board.matrix[1][1].state, @board.matrix[2][2].state].all? {|cell| cell == player.color} then
      return true
    end

    if [@board.matrix[2][0].state, @board.matrix[1][1].state, @board.matrix[0][2].state].all? {|cell| cell == player.color} then
      return true
    end

    return false

  end

  def play
    playing_player = @players.sample
    # use flip-flop to change player
    # iterates over the number of available cells in the board
    for i in (1..(@board.matrix.length)*(@board.matrix[0].length))
      case playing_player
      when @player1
        # take the playing part out of the switch
        make_move(playing_player)
        if has_won?(playing_player) then
          puts "#{playing_player.name} has won !"
          return true
        end
        playing_player = @player2
      when @player2
        make_move(playing_player)
        if has_won?(playing_player) then
          puts "#{playing_player.name} has won !"
          return true
        end
        playing_player = @player1
      end

      @board.display_state
    end
  end

end

class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name # String
    @color = color # 'X' or 'O'
  end
end

###
# @grid = matrix of cells

class Board
  attr_reader :matrix

  def initialize
    #array is initialized this way to prevent elements from array of being "linked"
    @matrix = Array.new(3) {|row| row = Array.new(3) {|col| col = Cell.new}}
  end

  # matrix writer method
  def modify_board_cell_state(row, col, new_state)
    @matrix[row][col].state = new_state
  end

  # method to display the current state of the board
  def display_state
    @matrix.each do |row|
      row.each do |cell|
        # print space so elements position is right
        cell.state == nil ? print(" ") : print(cell.state)
      end
      print "\n"
    end
  end

end

class Cell
  attr_accessor :state

  def initialize
    @state = nil
  end
end

partie1 = Game.new
partie1.play
