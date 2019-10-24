#! /usr/bin/ruby2.5

class Tree
	def initialize *args
		case args.length
		when 0
			@value = nil
		when 1
			@value = args[0]
		end
		@left = nil
		@right = nil
		@balance = 0
		@height = 1
	end

	def setLeft value
		@left = Tree.new value
	end

	def setRight value
		@right = Tree.new value
	end

	def setValue value
		@value = value
	end

	def delRight
		@right = nil
	end

	def delLeft
		@left = nil
	end

	def left
		@left
	end

	def right
		@right
	end

	def value
		@value
	end

	def balance
		@balance
	end

	def height
		@height
	end

	def exchangeWith node
		if node.is_a? Tree
			@value = node.value
			@left = node.left
			@right = node.right
			@height = node.height
			@balance = node.balance
			true
			unless node
				makeNil
			end
		end
		false
	end

	def pointer
		self
	end

	def makeNil
		exchangeWith Tree.new
	end

	def is_nil?
		not @value and not @left and not @right
	end

	def rightChild?
		if @right
			(@right.is_nil? ? false : true)
		else
			false
		end
	end

	def leftChild?
		if @left
			(@left.is_nil? ? false : true)
		else
			false
		end
	end

	def children
		if not rightChild? and not leftChild?
			0
		elsif rightChild? or leftChild?
			if rightChild? and leftChild?
				2
			else
				1
			end
		end
	end

	def calculateHeight
		if children == 0
			'''if is_nil?
				@height = 0
			else'''
				@height = 1
			#end
		else
			rightH = (rightChild? ? @right.calculateHeight : 0)
			leftH = (leftChild? ? @left.calculateHeight : 0)
			@height = 1 + (rightH > leftH ? rightH : leftH)
		end
	end

	def calculateBalance
		@balance = (rightChild? ? @right.calculateHeight : 0) - (leftChild? ? @left.calculateHeight : 0)
		if leftChild?
			@left.calculateBalance
		end
		if rightChild?
			@right.calculateBalance
		end
	end

				
	def insert value
		if is_nil?
			setValue value
		elsif value >= @value
			if not rightChild?
				setRight value
			else
				@right.insert value
			end
		elsif value < @value
			if not leftChild?
				setLeft value
			else
				@left.insert value
			end
		end
		calculateBalance

		if @balance < -1
			if @left.balance > 0
				@left.rotateLeft
			end
			rotateRight
		elsif @balance > 1
			if @right.balance < 0
				@right.rotateRight
			end
			rotateLeft
		end
	end

	def locate node
		if node.is_a? Tree
			if is_nil?
				exchangeWith node
			elsif node.value >= @value
				if not rightChild?
					@right = node
				else
					@right.locate node
				end
			elsif node.value < @value
				if not leftChild?
					@left = node
				else
					@left.locate node
				end
			end
		end
	end

	def erase value
		if @value == value
			case children
			when 0
				makeNil
				true
			when 1
				if not leftChild?
					exchangeWith @right
					true
				elsif not rightChild?
					exchangeWith @left
					true	
				end
			when 2
				@right.locate @left
				exchangeWith @right
			end
		elsif @value < value and rightChild?
			@right.erase value
		elsif @value > value and leftChild?
			@left.erase value
		else
			false
		end
		calculateBalance
	end

	def rotateLeft
		temp = Tree.new
		temp.exchangeWith self
		exchangeWith @right

		begin
			temp.right.exchangeWith @left
			temp.delRight
			temp.locate @left
			@left = temp

			calculateBalance
		rescue NoMethodError => e
			exchangeWith temp
			puts "cannot exchange nil to a value"
		end
	end

	def rotateRight
		temp = Tree.new
		temp.exchangeWith self
		exchangeWith @left

		begin
			temp.left.exchangeWith @right
			temp.delLeft
			temp.locate @right
			@right = temp

			calculateBalance
		rescue NoMethodError => e
			exchangeWith temp
			puts "cannot exchange nil to a value"
		end
	end

	def preOrderSearch value
		if not is_nil?
			found = false
			if @value == value; found = self end
			if not found and leftChild?; found = @left.preOrderSearch value; end
			if not found and rightChild?; found = @right.preOrderSearch value; end
			found
		else
			false
		end
	end

	def inOrderSearch value
		if not is_nil?
			found = false
			if not found and leftChild?; found = @left.inOrderSearch value; end
			if @value == value; found = self end
			if not found and rightChild?; found = @right.inOrderSearch value; end
			found
		else
			false
		end
	end

	def postOrderSearch value
		if not is_nil?
			found = false
			if not found and leftChild?; found = @left.postOrderSearch value; end
			if not found and rightChild?; found = @right.postOrderSearch value; end
			if @value == value; found = self end
			found
		else
			false
		end
	end

	def min
		if not leftChild?
			@value
		else
			@left.min
		end
	end

	def minimum
		min
	end

	def max
		if not rightChild?
			@value
		else
			@right.max
		end
	end

	def maximus
		self.max
	end

	def inspect
		"<Tree: [#{@value}] h: #{calculateHeight}>"
	end

	def to_s
		"(" + (leftChild? ? "#{@left.to_s}<-": "") + "[#{@value}]" + (rightChild? ? "->#{@right.to_s}": "") + ")"
	end
end

tree = Tree.new

#[1,2,3,5,4,3].each {|n| tree.insert(n)}
Array.new(20) { |i| i + 1}.each {|n| tree.insert(n)}
puts tree
