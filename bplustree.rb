#! /usr/bin/ruby2.5
class QuickSort
	def initialize elements
		if elements.is_a? Array
			@elements = elements
		elsif elements.is_a? Range
			@elements = elements.to_a
		else
			@elements = nil
		end
		@pivotpoint = 0
	end

	def elements
		@elements
	end

	def length
		@elements.length
	end

	def exchange(a, b)
		temp = @elements[a]
		@elements[a] = @elements[b]
		@elements[b] = temp
	end

	def quickSort(low, high)
		if high > low
			partition(low, high)
			self.quickSort(low, @pivotpoint - 1)
			self.quickSort(@pivotpoint + 1, high)
		end
	end

	def partition(low, high)
		pivotitem = @elements[low]
		j = low

		i = low + 1
		while i <= high
			if @elements[i] < pivotitem
				j += 1
				self.exchange(i, j)
			end
			i += 1
		end
		@pivotpoint = j
		self.exchange(low, @pivotpoint)
	end

	def sort
		quickSort(0, length - 1)
		@elements
	end

	def inspect
		@elements.inspect
	end
end

#--------------------------------------------------------------------Leaf----------------------------------------------------------------
class Leaf
	def initialize *args #limit, value(s)
		case args.length
		when 1
			@m = args[0]
			@values = Array.new
		when 2
			@m = args[0]
			if args[1].is_a? Array
				values = QuickSort.new args[1]
				@values = values.sort
			elsif args[1].is_a? Range
				@values = args[1].to_a
			else
				@values = Array.new
				@values << args[1]
			end
		end		
		@next = nil
	end

	def values
		@values
	end

	def limit
		@m
	end

	def next
		@next
	end

	def setNext leaf
		if leaf.is_a? Leaf
			@next = leaf
		end
	end

	def is_half_full?
		length > (limit / 2)
	end

	def is_half_empty?
		length < (limit / 2)
	end

	def nil_value?
		@values == []
	end

	def length
		@values.length
	end

	private
	def setValues values
		@values = values
	end

	def addValue value
		inserted = false
		i = 0
		until inserted
			if @values[i]
				if @values[i] > value
					@values = @values[0 ... i] + [value] + @values[i .. length]
					inserted = true
				end
			else
				@values << value
				inserted = true
			end
			i += 1
		end
	end

	def split
		unless length < limit
			splits = Array.new
			splits << self
			splits << @values[limit / 2]
			splits << Leaf.new(limit, @values[limit / 2 .. limit])
			setValues @values[0 ... limit / 2]
			splits.last.setNext @next
			setNext splits.last
			splits
		else
			false
		end
	end	

	public
	def insert value
		addValue value
		split
	end

	def append value
		@values.push value
		nil
	end

	def prepend value
		@values.unshift value
		nil
	end

	def pop
		@values.pop
	end

	def shift
		@values.shift
	end

	def first
		@values.first
	end

	def last
		@values.last
	end

	def borrowRightFrom leaf
		if leaf.is_a? Leaf
			if leaf.is_half_full?
				append leaf.shift
			end
			leaf.first
		end
	end

	def borrowLeftFrom leaf
		if leaf.is_a? Leaf
			if leaf.is_half_full?
				prepend leaf.pop
			end
			first
		end
	end

	def mergeWith leaf
		if leaf.is_a? Leaf
			while leaf.length > 0
				append leaf.shift
			end

			@next = leaf.next
			true
		else
			false
		end
	end

	def delete value
		begin
			if @values.delete_at @values.find_index value
				first
			else
				false
			end
		rescue TypeError
			puts "error finding #{value}"
			false
		end
	end
				

	def search value
		if @values.include? value
			self
		elsif @next
			@next.search value
		else
			false
		end
	end

	def inspect
		"L:#{@values.inspect}"
	end

	def print
		puts @values
		if @next
			@next.print
		end
	end
end

#---------------------------------------------------Node----------------------------------------------------------------
class Node
		def initialize *args #limit, value(s)
		case args.length
		when 1
			@m = args[0]
			@values = Array.new
		when 2
			@m = args[0]
			if args[1].is_a? Array
				@values = args[1]
			elsif args[1].is_a? Range
				@values = args[1].to_a
			else
				@values = Array.new
				@values << args[1]
			end
		end		
		@pointers = []
	end

	def values
		@values
	end

	def pointers
		@pointers
	end

	def limit
		@m
	end

	def length
		@values.length
	end

	def first
		@values.first
	end

	def last
		@values.last
	end

	def children_are? class_
		@pointers[0].is_a? class_
	end

	def is_half_full?
		@pointers.length > (limit / 2)
	end

	def is_half_empty?
		@pointers.length < (limit / 2)
	end

	def addValue value
		@values << value
	end

	def nil_value?
		@values == [] and @pointers.length < 2
	end

	def setPointer node
		@pointers << node
	end

	def append value, node
		@values.push value
		if node.is_a? Node or node.is_a? Leaf
			@pointers.push node
		end
		nil
	end

	def prepend value, node
		@values.unshift value
		if node.is_a? Node or node.is_a? Leaf
			@pointers.push node
		end
		nil
	end

	def pop
		[@values.pop, @pointers.pop]
	end

	def shift
		[@values.shift,@pointers.shift]
	end

	def setAllPointers array
		@pointers = Array.new
		array.each do |node|
			if node.is_a? Node or node.is_a? Leaf
				@pointers << node
			end
		end
	end

	def split
		unless length < limit
			splits = Array.new
			splits << Node.new(limit, @values[0 ... limit / 2])
			splits << @values[limit / 2]
			splits << Node.new(limit, @values[limit / 2 + 1 .. limit])
			splits.first.setAllPointers @pointers[0 .. splits.first.length]
			splits.last.setAllPointers @pointers[splits.first.length + 1 .. @pointers.length]
			splits
		else
			nil
		end
	end

	def insert value
		i = 0
		until i == length or @values[i] > value
			i += 1
		end
		s = nil
		if @pointers[i]
			s = @pointers[i].insert value
		else
			i -= 1
			s = @pointers[i].insert value #caso especial
		end
		if s
			length.downto(i + 1).each do |j|
				@values[j] = @values[j - 1]
			end
			length.downto(i + 1).each do |j|
				@pointers[j] = @pointers[j - 1]
			end
			@values[i] = s[1]
			@pointers[i] = s.first
			@pointers [i + 1] = s.last
		end
		split
	end

	def borrowRightFrom node
		if node.is_a? Node
			if node.length < 2
				append *node.shift
			end
			node.pointers.first.first
		end
	end

	def borrowLeftFrom node
		if node.is_a? Node
			if node.length > 2
				prepend *node.pop
			end
			@pointers.first.first #
		end
	end

	def mergeWith node
		if node.is_a? Node
			node.pointers.each do |pointer|
				append pointer.first, pointer
			end
			true
		else
			false
		end
	end

	def delete value
		i = 0
		until i == length or @values[i] > value
			i += 1
		end
		d = @pointers[i].delete value
		if d != false
			if @pointers[i].is_half_empty? or @pointers[i].nil_value?
				if @pointers[i - 1] and not i == 0 and @pointers[i - 1].is_half_full? and children_are? Leaf #borrow from left
					@values[i - 1] = @pointers[i].borrowLeftFrom @pointers[i - 1]	
				elsif (@pointers[i - 1] and not i == 0) or (@pointers[i].nil_value? and not i == 0) #merge to left
					if @pointers[i - 1].mergeWith @pointers[i]
						@pointers.delete @pointers[i]
						@values.delete @values[i - 1]
					end
				elsif @pointers[i + 1] and @pointers[i + 1].is_half_full? and children_are? Leaf #borrow from right
					@values[i] = @pointers[i].borrowRightFrom @pointers[i + 1]		 
				elsif @pointers[i + 1] and @pointers[i + 1] or (@pointers[i].nil_value? and @pointers[i + 1]) #merge right to i
					if @pointers[i].mergeWith @pointers[i + 1]
						@pointers.delete @pointers[i + 1]
						@values.delete @values[i]
					end
				end
			elsif not i == 0 and @values[i - 1]
				@values[i - 1] = d		
			end
			@pointers.first.values.first
		else
			false
		end
	end

	def search value
		i = 0
		until i == length or @values[i] > value
			i += 1
		end
		if @pointers[i]
			@pointers[i].search value
		else
			false
		end

	end

	def print
		@pointers.first.print
	end

	def inspect
		"N:#{@values.inspect}->#{@pointers.inspect}"
	end
end

class BPTree
	def initialize *args
		case args.size
		when 1
			@root = Leaf.new args[0]
		when 2
			@root = Leaf.new args[0]
			args[1].each {|n| tree.insert(n)}
		end
		@m = @root.limit
	end

	def root
		@root
	end

	def limit
		@m
	end

	def insert value
		s = @root.insert value
		if s
			new_node = Node.new(limit, s[1])
			new_node.setPointer s.first
			new_node.setPointer s.last

			@root = new_node
			limit = root.limit
		end
	end

	def delete value
		if @root.delete value
			if @root.nil_value?
				temp = @root.pointers.pop
				if temp.is_a? Node
					temp.pointers.each do |pointer|
						unless pointer == temp.pointers.first
							@root.append pointer.first, pointer
						else
							@root.pointers.append pointer
						end
					end
				elsif temp.is_a? Leaf
					@root = temp
				end		
			end
		end
	end

	def search value
		@root.search value
	end

	def print
		@root.print
	end

	def inspect
		"B+ Tree: #{@root.inspect}"
	end
end

tree = BPTree.new 4
#sequence = Array.new(20) { |i|  i}
sequence = [2,4,7,10,8,15,1,12,21,25]
sequence.each {|n| tree.insert n}

#tree.insert 9
#tree.insert 11
tree.insert 26
tree.delete 8

puts tree.inspect