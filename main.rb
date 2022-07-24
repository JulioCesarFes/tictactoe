require 'io/console'

# 40, 48, 47, 46

print "\e[8;7;37t"

ch = ''

cursor_x = 2
cursor_y = 2
board_x = 5
board_y = 5

board = [[' ', ' ', ' '],
         [' ', ' ', ' '],
         [' ', ' ', ' ']]
current_player = 'x'

win_conditions = ['012', '345', '678', '036', '147', '258', '048', '246']
winner = ''

t1 = Thread.new {
  while ch != 'f'
    ch = STDIN.getch

    if ch == ' ' && cursor_x == 4 && cursor_y == 0
      ch = 'f'
      break
    end

    if ch == ' ' && winner == ''
      if cursor_x > 0 && cursor_x < board_x - 1 && cursor_y > 0 && cursor_y < board_y - 1 && board[cursor_y - 1][cursor_x - 1] == ' '
        board[cursor_y - 1][cursor_x - 1] = current_player

	win_conditions.each do |win_condition|

          found = ''
	  win_condition.split('').map(&:to_i).each do |n|
            y = (n / 3).floor
            x = n % 3
            found += board[y][x]
          end

          if found == 'xxx' || found == 'ooo'
            winner = found == 'xxx' ? 'x' : 'o'
            break
          end
        end

        current_player = current_player == 'x' ? 'o' : 'x' if winner == ''
      end
    end
    
    cursor_x -= 1 if ch == 'a' #left
    cursor_x += 1 if ch == 'd' #right
    cursor_y -= 1 if ch == 'w' #up
    cursor_y += 1 if ch == 's' #down

    cursor_x = 0 if cursor_x < 0
    cursor_y = 0 if cursor_y < 0
    cursor_x = board_x - 1 if cursor_x >= board_x
    cursor_y = board_y - 1 if cursor_y >= board_y
  end

  print "\e[8;24;80t"
}

t2 = Thread.new {
  while ch != 'f'
    system "clear"
    board_y.times do |y|

      print "\e[0m"
      print " " * 16

      board_x.times do |x|

        if x == cursor_x && y == cursor_y
          print "\e[42m"
        elsif x != 0 && y != 0 && x != board_x - 1 && y != board_y - 1
          print "\e[40m"
        elsif x == 1 && y == 0 && winner == 'x'
          print "\e[43m"
        elsif x == 3 && y == 0 && winner == 'o'
          print "\e[43m"
        elsif x == 1 && y == 0 && current_player == 'x'
          print "\e[48m"
        elsif x == 3 && y == 0 && current_player == 'o'
          print "\e[48m"
        elsif x == 4 && y == 0
          print "\e[41m"
        else
          print "\e[47m"
        end

        if y-1 >= 0 && x - 1 >= 0 && !board[y-1].nil? && !board[y-1][x-1].nil?
          print board[y-1][x-1]
        elsif x == 1 && y == 0
          print "x"
        elsif x == 3 && y == 0
          print "o"
        elsif x == 0 && y == 4
          print "\e[30m✥"
        elsif x == 2 && y == 4
          print "\e[30m▄"
        elsif x == 4 && y == 4
          print "\e[30mp"
        elsif x == 4 && y == 0
          print "f"
        else
          print " "
        end

        print "\e[0m"
      end

      print "\n\r"
    end

    sleep(0.1)
  end
}


t1.join
t2.join
