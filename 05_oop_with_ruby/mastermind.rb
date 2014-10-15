class Mastermind

	###### PATH ######
	# Set up variables
	# Display intro (intro)
	# Get input if user or computer is master

	# IF COMPUTER IS MASTER:
		# Display (intro_computer_is_master)
		# Set @master to computer
		# Computer generates random secret code
		# Let user guess code (guess_again)
			# If there are still turns left
				# If it's not the first turn, show the board of guesses (show_board)
				# Get guess from user
				# Make sure their code is formatted correctly (sanitize_input)
					# If code was entered correctly, check if guess was correct (check_guess)
						# If correct guess, display winning message, 
						# If incorrect guess, increase number of turns and evaluate how close guess was (evaluate_guess)
							# Add how close it was to answer to @evaluate, run (guess_again)
					# If code was NOT entered correctly, run (error)	
						# error will display message and send user back to (guess_again_)
			# If no turns left, display losing message (user lost)

	# IF USER IS MASTER:
		# Display (intro_user_is_master)
		# Set @master to user
		# Get secret code from user
		# Make sure their code is formatted correctly (sanitize_input)
			# If correctly inputted, go back to intro_user_is_master, confirm secret code and let computer make a guess (computer_guess)
				# If there are turns left
					# Increase number of turns
					# Generate computer's guess
					# Check if guess was correct (check_guess)
						# If guess was correct 
							# Show losing message (computer won)
							# Break out of guessing loop
						# If guess was incorrect, 
							# Evaluate how close guess was (evaluate_guess)
							# Store how close guess was in @evaluate
							# Have computer modify what numbers it can use
							# Show the board
							# Continue loop of letting computer guess (computer_guess)
					# If it's not the first turn, show the board (show_board)
				# If no turns left, show the board and display winning message (user won)
			# If incorrectly inputted, keep asking for secret code until correct

	# Set up variables
	def initialize
		# The "answer" is the secret code
		@answer = []
		# The "board" is the list of guesses
		@board = []
		# "Evaluate" is the list of responses to the user's guesses
		@evaluate = []
		# potential_numbers is the list of all numbers that are valid for each index in the answer
		# This is for when the computer is guessing
		# Initially set up so that each index (0-4) has all potential numbers (1-6) in it
		@potential_numbers = Hash.new
		4.times do |x|
			@potential_numbers[x] = [1,2,3,4,5,6]
		end
		# The current turn
		@turn = 0
		# Display intro message
		intro
	end

	protected

	# Introduction
	def intro
		puts
		puts "Welcome to Mastermind!"
		puts "This is a fun game where you (or the computer)"
		puts "gets to make up a secret code"
		puts "that looks something like this: 6543"
		puts "The other player has to guess the code!"
		puts
		puts "Do you want to make up the code and be mastermind?"
		puts "Type y if YOU want to be the mastermind, "
		puts "or n if you want the COMPUTER to be the mastermind..."
		# Figure out if user or computer is mastermind
		loop do
			mastermind = gets.chomp
			if mastermind.downcase == "y"
				intro_user_is_master
				break
			elsif mastermind.downcase == "n"
				intro_computer_is_master
				break
			else
				puts "Oops, please enter y or n"
			end
		end
	end

	# Instructions if computer is mastermind
	def intro_computer_is_master
		puts 
		puts "---------------------------------------"
		puts "The computer has made a secret code using the numbers 1-6"
		puts "in four spots like this: \"5136\""
		puts "Your task is to guess the order!"
		puts "You have 12 tries to get it right."
		puts 
		puts "You will be told how many numbers are in the right spot"
		puts "Like this: \"2 right\""
		puts "And how many numbers are in the secret code, but need to be moved"
		puts "Like this: \"1 close\""
		puts
		puts "So if the secret code is 1231 and you enter 2136, the output will be"
		puts "\"1 right, 2 close\" since the 3 is right and the 2 and 1 need to be moved" 
		puts "---------------------------------------"
		# Set computer to mastermind
		@master = "comp"
		# Set up secret code generated by computer with 4 random numbers b/w 1 and 6
		4.times { @answer << rand(6) + 1 }
		# Let user guess
		guess_again
	end

	# Instructions if user is mastermind
	def intro_user_is_master
		puts
		puts "---------------------------------------"
		puts "You must come up with a secret code"
		puts "of 4 numbers using the numbers 1 through 6"
		puts "like this: 6335"
		puts "The computer has 12 chances to guess it!"
		puts 
		puts "After every guess the computer will be told how many numbers are in the right spot"
		puts "Like this: \"2 right\""
		puts "And how many numbers are in the secret code, but need to be moved"
		puts "Like this: \"1 close\""
		puts
		puts "So if the secret code is 1231 and the computer guesses 2136, the output will be"
		puts "\"1 right, 2 close\" since the 3 is right and the 2 and 1 need to be moved" 
		puts "---------------------------------------"
		# Set user to mastermind
		@master = "user"
		# Get secret code from user
		loop do
			puts
			puts "Type your secret code and hit enter"
			answer = gets.chomp
			# Put each digit into an array
			arr = []
			answer.split("").each { |num| arr << num.to_i }
			# Make sure guess was correctly inputted
			if sanitize_input(arr)
				@answer = arr
				puts "Great! Your secret code is #{@answer.join}."
				puts "Now the computer will try to guess your number..."
				computer_guess
				break
			else
				puts
				puts "Whoops, you must enter a 4 digit number with the digits 1-6"
				puts "like this: 6543"
			end
		end
	end

	# If user is guessing get their guess
	def guess_again(message = nil)
		# As long as user hasn't run out of turns...
		if @turn < 12
			# If there was no error message and it isn't the first turn, show the board
			if message == nil && @turn > 0 
				show_board
			end
			puts 
			puts "Enter your guess. You've used #{@turn} of 12 turns."
			# Get user's guess
			guess = gets.chomp
			# Put each digit into an array
			arr = []
			guess.split("").each { |num| arr << num.to_i }
			# Make sure guess was correctly inputted
			sanitize_input(arr)
		# User ran out of turns, show answer
		else
			puts 
			puts "Whoops! You ran out of turns"
			puts "The correct answer was #{@answer.join}"
		end
	end

	# How to display the board of guesses
	def show_board
		puts 
		puts "-------------------"
		puts "Board so far: "
		# Go through each guess and answers and display them
		@board.each_with_index do |guess, i| 
			puts "#{guess.join} #{@evaluate[i]}"
		end
		puts "-------------------"
	end

	# Make sure user entered exactly four digits and they were the right range of numbers
	# If user is mastermind, make sure their secret code is correctly inputted
	def sanitize_input(arr)
		# Checking variable checks to make sure each digit is correct
		checking = 0
		# Set error message to nil
		message = nil
		# Check each digit in the array to make sure it's a digit
		# If not, increase checking variable
		arr.each do |n|
			unless (1..6).include?(n)
				checking += 1
			end
		end
		# If all entries were digits and there were 4 of them...
		if checking == 0 && arr.length == 4
			if @master == "comp"
				# Add guess to the board, increase the turn and check if guess was correct
				@board << arr
				@turn += 1
				check_guess(arr)
			else
				return true
			end
		# Guess was all digits, but there weren't four
		# Send error message to error method
		elsif checking == 0 && arr.length != 4
			if @master == "comp"
				message = "Whoops! You must enter exactly FOUR numbers like this: 3241"
				error(message)
			else 
				return false
			end
		# Guess was not all digits, but there were four
		# Send error message to error method
		elsif checking > 0 && arr.length == 4
			if @master == "comp"
				message = "Whoops! You must enter numbers 1-6 like this: 4256"
				error(message)
			else
				return false
			end
		# Guess wasn't all digits, and there weren't four
		# Send error message to error method
		else
			if @master == "comp"
				message = "Whoops! You must enter FOUR numbers and they have to be 1-6 \nlike this: 1234"
				error(message)
			else 
				return false
			end
		end
	end

	# Display computer's guess
	def computer_guess
		loop do
			if @turn < 12
				@turn += 1
				puts 
				puts "Press enter to see computer's try \##{@turn}"
				see_next = gets.chomp
				#Generate computer's guess from available numbers
				comp_guess = []
				4.times do |i|
					comp_guess << @potential_numbers[i].sample
				end
				@board << comp_guess
				# If guess was correct, stop loop
				if check_guess(comp_guess)
					break
				# Otherwise, evaluate guess and keep going
				else
					evaluate_guess
					# If not the first turn, display the computer's guesses
					if @turn != 0
						show_board
					end
				end
			# Computer couldn't guess! Show winning message
			else
				show_board
				puts
				puts "You won! Computer didn't guess code in 12 turns"
				break
			end
		end
	end

	# Checks if guessing person got the correct code
	def check_guess(arr)
		# If guess equals the answer, show win message
		if arr == @answer && @master == "comp"
			puts "Congrats, you won!"
			puts "You guessed the code of #{@answer.join} in #{@turn} turns!"
		elsif arr != @answer && @master == "comp"
			# Guess wasn't correct, so send through evaluate_guess method to see how close it was
			evaluate_guess
		elsif arr == @answer && @master == "user"
			@evaluate << "4 right, 0 close"
			show_board
			puts
			puts "The computer won!"
			puts "Computer guessed the code of #{@answer.join} in #{@turn} turns!"
			return true
		elsif arr != @answer && @master == "user"
			return false
		end
	end

	# User didn't enter their guess correctly. Display error message and have them guess again
	def error(message)
		# Display error message, guess again, noting that there was an error so don't show board
		puts
		puts message
		guess_again("err")
	end

	# Evaluate how close the last guess was
	def evaluate_guess
		# How many were right
		right_guesses = 0
		# How many were close
		almost_guesses = 0
		# Put answer and guess in a temporary array for modifying
		temp_answer = []
		temp_guess = []
		@answer.each { |n| temp_answer << n }
		@board[-1].each { |n| temp_guess << n }
		# Go through each digit in answer to see how many were correct
		temp_answer.each_with_index do |num, i|
			# If corresponding digit in guess is correct...
			if temp_guess[i] == num
				# Increase right variable
				right_guesses += 1
				# And change both numbers in temporary array to invalid numbers so they don't get counted in the next step
				temp_guess[i] = 9
				temp_answer[i] = 8
			end
		end
		# Go through each digit in answer to see how many were close
		# The arrays now have correct digits taken out so they don't get counted again
		temp_answer.each_with_index do |num, i|
			next_num = 0
			# Step through each digit in guess
			4.times do |x|
				# If guess is the same
				if temp_guess[x] == num && next_num == 0
					# Increase almost variable and take out digits
					almost_guesses += 1
					temp_guess[x] = 9
					temp_answer[i] = 8
					# Move on to next number in answer array so it doesn't get counted again
					next_num = 1
				end
			end
		end
		# Add how many were right and close to the evaluate array
		@evaluate << "#{right_guesses} right, #{almost_guesses} close"
		# Let user guess again
		if @master == "comp"
			guess_again
		# If computer is guessing, use feedback to narrow down its options
		elsif @master == "user"
			# Nothing was right or close, so take all numbers in last guess out of options
			if almost_guesses == 0 && right_guesses == 0
				@board[-1].each do |num_to_delete|
					4.times do |pot_ans_index|
						arr = @potential_numbers[pot_ans_index]
						arr.delete(num_to_delete)
						@potential_numbers[pot_ans_index] = arr
					end
				end
			# None were right but some were close, so take each number out of its options for JUST that index
			elsif right_guesses == 0 && almost_guesses > 0
				@board[-1].each_with_index do |num_to_delete, i|
					arr = @potential_numbers[i]
					arr.delete(num_to_delete)
					@potential_numbers[i] = arr
				end
			end
		end
	end

end

game = Mastermind.new