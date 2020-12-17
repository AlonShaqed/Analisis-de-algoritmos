class Node
	def initialize value
		@value = value
		@left = nil
		@right = nil
	end

	def value
		@value
	end

	def right
		@right
	end

	def left
		@left
	end

	def setRight node 
		if node.is_a? Node
			@right = node
		else
			@right = Node.new node
		end
	end

	def setLeft node 
		if node.is_a? Node
			@left = node
		else
			@left = Node.new node
		end
	end
end

class Tree
	def initialize node
		if node.is_a? Node
			@root = node
		else
			@root = nil
		end
	end

	def root
		@root
	end

	def setRoot node
		if node.is_a? Node
			@root = node
		end
	end

	def insert *args
		case args
		when 1
			value = args[0]
			insert value, @root
		when 2
			value = args[0]
			tree = args[1]
		end
	end
end

tree = Tree.new Node.new 7

puts tree.root
node = tree.root
puts node
