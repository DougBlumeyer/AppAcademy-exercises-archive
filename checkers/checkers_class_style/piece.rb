class Piece
  attr_reader :side
  attr_accessor :is_king, :pos, :board, :game

  def initialize(board, side, pos, is_king = false, game)
    @board = board
    @game = game
    @side = side
    @pos = pos
    @is_king = is_king
  end

  def inspect
    puts "side:    #{@side}"
    puts "pos:     #{@pos}"
    puts "is king? #{@is_king}"
  end

  def dup
    duped_piece = Piece.new(board, side, pos, is_king, game)
  end

  def slides
    "puts hi i'm slides. this is the piece i'm calling from #{self}"
    r, c = self.pos
    slides = []
    move_diffs.each do |move_diff|
      dr, dc = move_diff
      potential_slide = [r + dr, c + dc]
      next unless Board.on_board?(potential_slide)
      next unless board.unoccupied?(potential_slide)
      slides << potential_slide
    end

    slides
  end

  def jump_set
    r, c = self.pos
    jump_set = []
    move_diffs.each do |move_diff|
      dr, dc = move_diff
      potential_jumped_square = [r + dr, c + dc]
      potential_jump = [r + dr * 2, c + dc * 2]
      next unless Board.on_board?(potential_jump)
      next unless board.occupied_by?(board.other_side(side), potential_jumped_square)
      jump_set << potential_jump
    end

    jump_set
  end

  def perform_slide(end_pos, passed_board) #yeah wait, why is this END_POS?
    puts "perform slide is false unless you see true"
    puts "uhhhh how can slides not be called if this is returning false because of it......?????"
    puts "WHAT IS THE SELF? #{self}" ##okay so it's still trying to move the version of the piece on the duped board
    puts "self.slides: #{self.slides}"
    puts "and end pos, which must be included therein: #{end_pos}"
    return false unless self.slides.include?(end_pos)
    puts "\nhere's the board this perform slide is doing this to:"
    puts passed_board
    passed_board[end_pos] = self
    passed_board[pos] = nil
    self.pos = end_pos.dup
    maybe_promote
    puts "perform slide is true"
    true
  end

  def perform_jump(end_pos, passed_board)
    puts "perform jump is false unless you see true"
    return false unless self.jump_set.include?(end_pos)
    passed_board[end_pos] = self
    passed_board[pos] = nil
    kill_jumped_piece(end_pos)
    self.pos = end_pos.dup
    maybe_promote
    puts "perform jump is true"
    true
  end

  def perform_moves!(move_seq, passed_board = @board)
    puts "\nthis is the board we're doing stuff with, perform moves with a BANG"
    puts passed_board
    puts "\nand just curious, this is the instance board:"
    puts @board
    puts "finally, the move sequence here is: #{move_seq}"
    if move_seq.count == 1
      puts "move seq count is one"
      if perform_slide(move_seq.first, passed_board) == false #passed_board[passed_board.cursor]. ...???
        puts "perform slide is false"
        if perform_jump(move_seq.first, passed_board) == false
          puts "perform jump is false"
          raise InvalidMoveError.new "Invalid move!"
        end
      end
    else  #HMMMMM OKAY FOR SOME REASON THE MOVE SEQ IS NOT INSIDE AN ARRAY, so it's treating x and y as separate moves
      move_seq.each do |jump|
        puts "move seq count is more than one: #{move_seq}"
        if perform_jump(move_seq.first, passed_board) == false
          raise InvalidMoveError.new "Invalid move!"
        end
      end
    end

  end

  def perform_moves(move_seq)
    puts "perform moves without a ! actually got called"
    puts "the move_seq here is: #{move_seq}"
    puts "and at this point the self is #{self}"
    puts "and at this point game.grabbed is #{game.grabbed}"
    perform_moves!(move_seq) if valid_move_seq?(move_seq)
  end

  def valid_move_seq?(move_seq)
    puts "valid move seq called"
    puts "the move_seq here is: #{move_seq}"
    begin
      duped_board = board.dup
      puts "perform moves! called for the first time, on the duped board"
      #puts "here's the duped_board's cursor: #{duped_board.cursor}"
      #puts "and here's the thing at that location on the duped_board: "
      puts "here's game: #{game}"
      puts "here's game.grabbed: #{game.grabbed}"
      puts "and here's duped_board[game.grabbed.first]: #{duped_board[game.grabbed.first]}"
      duped_board[game.grabbed.first].perform_moves!(move_seq, duped_board)
    # rescue
    #   puts "You can't move there. Please try another move. "
    #   return false
    # else
    #   puts "valid moves returned true inside the else"
    #   return true
    end

    puts "valid moves returned true at the ending"
    true
  end

  def move_diffs
    move_diffs = []
    move_diffs += [ [bwd_dir, -1], [bwd_dir, 1] ] if is_king
    move_diffs += [ [fwd_dir, -1], [fwd_dir, 1] ]
  end

  def bwd_dir
    -fwd_dir
  end

  def fwd_dir
    fwd_dir = ( side == :top ? 1 : -1 )
  end

  def kill_jumped_piece(end_pos)
    from_r, from_c = self.pos
    to_r, to_c = end_pos
    jumped_pos = [(from_r + to_r) / 2, (from_c + to_c) / 2]
    board[jumped_pos] = nil
  end

  def maybe_promote
    if (side == :top && row == 7) || (side == :bottom && row == 0)
      self.is_king = true
    end
  end

  def row
    pos[0]
  end

  def col
    pos[1]
  end

  def symbol
    if side == :top
      if is_king
        "\u2620"
      else
        "\u2622"
      end
    else
      if is_king
        "\u2620"
      else
        "\u2623"
      end
    end
  end
end
