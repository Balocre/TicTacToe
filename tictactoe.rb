###
# this ruby script was coded by SuperTotoGo as part of the THP formation
# it is a (very) simple tic tac toe game played by 2 (or 1 if you have no friends)
# players in the terminal

###
# this class represents the game, it contains the board, the players (1 and 2) and the
# methods to modify the board state

class Game
  attr_reader :board, :player1, :player2

  # we initialize the board and the 2 players
  def initialize
    # this is a local array used only during initialization, hence no "@"
    available_colors = ['X', '0']

    print "name of player 1 : "
    name = gets.chomp!
    color = available_colors.shift
    @player1 = Player.new(name, color)

    #redundant, use anonymous function?
    print "name of player2 : "
    name = gets.chomp!
    color = color = available_colors.shift
    @player2 = Player.new(name, color)

    @players = [@player1, @player2]

    @board = Board.new
  end

  # this methods modifiy game's board state using the argument player's color
  def make_move(player)
    puts "it's #{player.name} turn !"
    puts "#{player.name} color is #{player.color}"
    puts "choose the row and the column where you want to play"
    puts
    # todo : add an exception for non integer values
    print "row : "
    row = gets.to_i
    print "column : "
    col = gets.to_i
    puts

    begin
      # check if board's matrix cell is void, otherwise tells the player to play somewhere else
      if @board.matrix[row][col].state != nil then
        puts "this cell is already occupied, play somewhere else!"
        puts
        #recursive, so it calls itself until the player makes a valid move
        make_move(player)
      else
        @board.modify_board_cell_state(row, col, player.color)
        puts
      end
    # handles the NoMethodError resulting from players trying to play outside the board boundaries
    rescue NoMethodError
      puts "you tried to play out of the board, please stay within the board's bounds!"
      puts "rows and colums are numbered from 0 to 2"
      puts
      make_move(player)
    end
  end

  # this method checks wether player passed as argument has a winning combination, it's
  # kinda bruteforce, but he it's a tictactoe, so operations complexity stays quite low
  def has_won?(player)
    # check rows for winning combinations
    for row in (0..@board.matrix.length-1)
      inspected_col = Array.new
      for col in (0..@board.matrix[0].length-1)
        inspected_col << @board.matrix[row][col].state
      end

      if inspected_col.all? {|cell| cell == player.color} then
        return true
      end
    end

    # check columns for winning combinations
    for col in (0..@board.matrix.length-1)
      inspected_row = Array.new
      for row in (0..@board.matrix[0].length-1)
        inspected_row << @board.matrix[row][col].state
      end

      if inspected_row.all? {|cell| cell == player.color} then
        return true
      end
    end

    # check digonals for winning combinations
    # note that is only works for a 3x3 board
    if [@board.matrix[0][0].state, @board.matrix[1][1].state, @board.matrix[2][2].state].all? {|cell| cell == player.color} then
      return true
    end

    if [@board.matrix[2][0].state, @board.matrix[1][1].state, @board.matrix[0][2].state].all? {|cell| cell == player.color} then
      return true
    end

    # if every test fails, returns false
    return false
  end

  # this method is the core of the game, it loops at most over the number of cells available in the gameboard and ends when a player has a winning combination
  def play
    playing_player = @players.sample
    # iterates over the number of available cells in the board
    for i in (1..(@board.matrix.length)*(@board.matrix[0].length))
      make_move(playing_player)
      @board.display_state

      if has_won?(playing_player) then
        puts "#{playing_player.name} has won !"
        return playing_player.name
      end

      #this switch change sets the player playing next move
      case playing_player
      when @player1
        playing_player = @player2
      when @player2
        playing_player = @player1
      end
    end

    puts "what a shame! it seems none of you were good enough... maybe next time?"
    return "none"
  end
end


###
# this class represents the player, it contains the players infos : his name and color

class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color # 'X' or 'O'
  end
end

###
# this class represents the board, it contains the board state in matrix and had methods
# to display and interact with the board ie. play on the board

class Board
  attr_reader :matrix

  def initialize
    # the matrix is just an array of array of cells
    # the matrix is initialized this way to prevent elements from array of being "linked"
    @matrix = Array.new(3) {|row| row = Array.new(3) {|col| col = Cell.new}}
  end

  # matrix writer method, check if move is valid is made in the game's make_move method
  def modify_board_cell_state(row, col, new_state)
    @matrix[row][col].state = new_state
  end

  # method to display the current state of the board
  def display_state
    @matrix.each do |row|
      row.each do |cell|
        # print space if cell is void so elements position is right
        cell.state == nil ? print(" ") : print(cell.state)
      end
      print "\n"
    end
  end

end

###
# this class represents a single cell, a cell is defined by it's state no need for more
# infos

class Cell
  attr_accessor :state

  def initialize
    @state = nil
  end
end

# initialize the game
partie1 = Game.new
# lauch the game
partie1.play
