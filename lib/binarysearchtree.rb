require 'pry-byebug'
module Comparable
  def greater?(node1, node2)
    node1.value > node2.value
  end
end

class Node
  attr_accessor :value, :right, :left

  def initialize(value = nil)
    @left = nil
    @right = nil
    @value = value
  end

  def children?
    return false if @left.nil? && @right.nil?

    true
  end

  def child?
    return true if @left.nil? == false || @right.nil? == false

    false
  end
end

class Tree
  include Comparable
  attr_accessor :root

  def initialize
    @root = nil
  end

  def build_tree(array, start = 0, final = array.length - 1)
    return nil if start > final

    mid = (start + final) / 2
    node = Node.new(array[mid])

    node.left = Tree.new.build_tree(array, start, mid - 1)
    node.right = Tree.new.build_tree(array, mid + 1, final)

    @root = node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def find(value, current_node = @root)
    return current_node if current_node.nil? || current_node.value == value

    current_node = if value > current_node.value
                     current_node.right
                   else
                     current_node.left
                   end
    find(value, current_node)
  end

  def insert(value, current_node = @root)
    if value > current_node.value
      return current_node.right = Node.new(value) if current_node.right.nil?

      current_node = current_node.right
    elsif value < current_node.value
      return current_node.left = Node.new(value) if current_node.left.nil?

      current_node = current_node.left
    end
    insert(value, current_node)
  end

  def delete(value, current_node = @root)
    return current_node if current_node.nil?

    if value > current_node.value
      current_node.right = delete(value, current_node.right)
    elsif value < current_node.value
      current_node.left = delete(value, current_node.left)
    else
      return current_node.right if current_node.left.nil?
      return current_node.left if current_node.right.nil?

      succ = get_succesor(current_node)
      current_node.value = succ.value
      current_node.right = delete(current_node.value, current_node.right)
    end
    current_node
  end

  def get_succesor(node)
    current_node = node.right
    current_node = current_node.left until current_node.left.nil? || current_node.nil?
    current_node
  end

  def level_order
    queue = [@root]
    visited = []
    until queue.empty?
      current_node = queue.shift
      next if current_node.nil?

      yield(current_node) if block_given?
      visited.unshift(current_node)
      queue.push(current_node.left, current_node.right)

    end
    visited unless block_given?
  end

  def inorder(node = @root, &block)
    return [] if node.nil?

    result = []

    if block_given?
      inorder(node.left, &block)
      block.call(node)
      inorder(node.right, &block)
    else
      result += inorder(node.left, &block)
      result << node.value
      result += inorder(node.right, &block)
    end
    result unless block_given?
  end

  def postorder(node = @root, &block)
    return [] if node.nil?

    result = []

    if block_given?
      postorder(node.left, &block)
      postorder(node.right, &block)
      block.call(node)
    else
      result += postorder(node.left, &block)
      result += postorder(node.right, &block)
      result << node.value
    end
  end

  def preorder(node = @root, &block)
    return [] if node.nil?

    result = []

    if block_given?
      block.call(node)
      preorder(node.left, &block)
      preorder(node.right, &block)
    else
      result << node.value
      result += preorder(node.left, &block)
      result += preorder(node.right, &block)
    end
    result unless block_given?
  end

  def height(node)
    return -1 if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    [left_height, right_height].max + 1
  end

  def depth(node, current_node = @root)
    return 0 if current_node == node
    return -1 if current_node.nil?

    1 + depth(node, current_node.left) if node.value < current_node.value

    1 + depth(node, current_node.right)
  end

  def balanced?
    n = height(@root.left) - height(@root.right)
    n <= 1 && n >= 0
  end

  def rebalance
    build_tree(inorder)
  end
end
