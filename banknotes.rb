#! /usr/bin/ruby2.5

class Array
	def * array
		_r = Array.new
		if array.is_a? Array and array.length == length
			(0 ... length).each do |i|
				_r.append(at(i) * array.at(i))
			end
			_r
		elsif array.is_a? Numeric
			_r = map {|a| array * a}
		end
	end
end

class BankNotes
	def initialize values
		if values.is_a? Array
			@values = values
			@quantities = Array.new @values.length, 0
		end
	end

	def length
		@quantities.length
	end

	def values
		@values
	end

	def quantities
		@quantities
	end

	def reset_quantities
		@quantities = Array.new @values.length, 0
	end

	def sum_all
		s = 0
		(@values * @quantities).each do |el|
			s += el
		end
		s
	end

	def quantities_fit_in d
		s = sum_all
		s <= d ? s : false
	end

	def increase_at ind
		@quantities[ind] += 1
	end

	def decrease_at ind
		@quantities[ind] -= 1
	end

	def divisible_by_notes? d
		@values.reverse_each do |value|
			if d % value == 0
				return true
			end
		end
		false
	end

	def get_quantities(k, d)
		if k == 0
			reset_quantities
		end
		if divisible_by_notes? d
			while quantities_fit_in d
				increase_at k
			end
			decrease_at k
			if sum_all == d
				@quantities
			else
				get_quantities(k + 1, d)
			end
		else
			false
		end
	end

	def solve_value value
		get_quantities(0, value)
	end
end

#notes = BankNotes.new [50,20,10,5,2,1]
notes = BankNotes.new [216,108,36,12,6,3,1]

puts (notes.solve_value 547).inspect
puts (notes.solve_value 265).inspect