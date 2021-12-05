def find_winning_board(boards, numbers)
  numbers.each do |number|
    boards.each_with_index do |board, board_index|
      5.times do |i|
        5.times do |j|
          if board[i][j] == number
            board[i][j] = -1
            if check_board(board, i, j)
              return [board, number]
            end
          end
        end
      end
    end
  end
  nil
end

def check_board(board, row, col)
  row_result = true
  5.times do |i|
    if board[row][i] != -1
      row_result = false
    end
  end

  col_result = true
  5.times do |i|
    if board[i][col] != -1
      col_result = false
    end
  end

  row_result || col_result
end

def calculate_score(board, num)
  sum = 0
  5.times do |i|
    5.times do |j|
      sum += board[i][j] unless board[i][j] == -1
    end
  end

  puts "*** sum = #{sum}"

  sum * num
end

def find_last_winning_board(boards, numbers)
  winners = []
  numbers.each do |number|
    boards.each_with_index do |board, board_index|
      next if winners.include?(board_index)
      5.times do |i|
        5.times do |j|
          if board[i][j] == number
            board[i][j] = -1
            if check_board(board, i, j)
              return [board, number] if boards.length - winners.length == 1
              winners << board_index
            end
          end
        end
      end
    end
  end
  nil
end


data = File.open("/Users/patrickgeorge/dev/personal/leetcode/advent_of_code_2021_day4_input.txt").read.split("\n")

numbers = data[0].split(",").map(&:to_i)
boards = []
board = []
1.upto(data.length - 1) do |i|
  if data[i] == "" && board.length > 0
    boards << board
    board = []
  elsif data[i] != ""
    board << data[i].split(" ").map(&:to_i)
  end
end

# pp boards[0]
winning_board, num = find_winning_board(boards, numbers)
pp "*** winning_board = #{winning_board}"
pp num

pp calculate_score(winning_board, num)

losing_board, num = find_last_winning_board(boards, numbers)
pp "*** losing_board = #{losing_board}"

pp calculate_score(losing_board, num)
