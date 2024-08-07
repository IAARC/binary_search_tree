require 'pry-byebug'
class Node
  attr_accessor :value, :right, :left

  def initialize(value = nil)
    @left = nil
    @right = nil
    @value = value
  end
end

class Tree
  attr_accessor :root

  def initialize(array = nil)
    @array = array.sort
    @length = @array.length
    @root = nil
  end

  def build_tree(start = 0, final = @length - 1)
    return nil if start > final

    mid = (start + final) / 2
    node = Node.new(@array[mid])

    node.left = Tree.new(@array).build_tree(start, mid - 1)
    node.right = Tree.new(@array).build_tree(mid + 1, final)

    @root = node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    current_node = find_parent(value)
    current_node.right = Node.new(value) if value > current_node.value
    current_node.left = Node.new(value) if value < current_node.value
  end

  def delete(value)
    current_node = find_parent(value)
    current_node.right = nil if value > current_node.value
    current_node.left = nil if value < current_node.value
  end

  def find_parent(value)
    current_node = @root
    until current_node.right.nil? || current_node.left.nil?
      if value > current_node.value
        current_node = current_node.right
      elsif value < current_node.value
        current_node = current_node.left
      end
    end
    current_node
  end

  def find(value)
    node = find_parent(value)
    return node.right if node.right.nil? == false && node.right.value == value

    node.left if node.left.nil? == false && node.left.value == value
  end
end

tree = Tree.new(Array.new(15) { rand(0...100) })
tree.build_tree
tree.insert(13)

tree.pretty_print

p tree.find(13)
