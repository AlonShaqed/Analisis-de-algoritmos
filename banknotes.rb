#! /usr/bin/ruby2.5

class Array # Overload native array class
	def * array # Overload * operator over arrays
		_r = Array.new
		if array.is_a? Array and array.length == length # cross product of two vectors
			(0 ... length).each do |i|
				_r.append(at(i) * array.at(i)) # Each element is multiplied by its counterpart
			end
			_r # return new array
		elsif array.is_a? Numeric # point product of vector with coefficient
			_r = map {|a| array * a}
		end
	end
end

class BankNotes
	def initialize values # Banknote values
		if values.is_a? Array
			@values = values # Banknote bill faces values e.g. 1, 2, 10, 50...
			@quantities = Array.new @values.length, 0 # quantities array of length=faces length & value of elements = 0
		end
	end

	def length # length of arrays within class
		@quantities.length
	end

	def values # get values
		@values
	end

	def quantities # get quantities
		@quantities
	end

	def reset_quantities # reset quantities to the initial 0 values
		@quantities = Array.new @values.length, 0
	end

	def sum_all # sum of the product of values of banknotes with their quantities
		s = 0 # sum begins at 0
		(@values * @quantities).each do |el| # for the product of the face values with their quantities...
			s += el	# sum the products to s
		end
		s # return s
	end

	def quantities_fit_in d # check if d value fits in the sum of all face values
		s = sum_all # sum of product of face values with quantities
		s <= d ? s : false # if sum <= to quantity d return the sum, else return false
	end

	def increase_at ind # increase the quantity at quantity at index
		@quantities[ind] += 1
	end

	def decrease_at ind # decrease the quantity at quantity at index
		@quantities[ind] -= 1
	end

	def divisible_by_notes? d # check if d value can be divided in the bills fully
		@values.reverse_each do |value| # reverse cycle of face values as value
			if d % value == 0 # if module of d against face value is 0
				return true	# return true
			end
		end
		false # else, return false
	end

	def get_quantities(k, d) # calculate the number of bills that make up to value d at position k
		if k == 0 # if is the initial element
			reset_quantities # reset quantities to 0
		end
		if divisible_by_notes? d # if the quantity can be divided by the face values fully
			while quantities_fit_in d # while it is still divisible
				increase_at k # add a bill to k face value
			end
			decrease_at k # adjust removing one bill at the end
			if sum_all == d # if the sum of all bills is equals to the quantity
				@quantities # return the quantities
			else
				get_quantities(k + 1, d) # recursive, advance to next face value
			end
		else
			false # if the quantity is too short, return false
		end
	end

	def solve_value value # interface function of get_quantities
		get_quantities(0, value)
	end
end

#notes = BankNotes.new [50,20,10,5,2,1]
notes = BankNotes.new [216,108,36,12,6,3,1]

puts (notes.solve_value 547).inspect
puts (notes.solve_value 265).inspect
