require_relative 'lib/binarysearchtree'

tree = Tree.new
tree.build_tree(Array.new(15) { rand(1..100) })
puts tree.balanced?

p tree.preorder
p tree.inorder
p tree.postorder

new_elements = Array.new(5) { rand(100..200) }
new_elements.each { |element| tree.insert(element) }

puts tree.balanced?
tree.rebalance
tree.pretty_print
puts tree.balanced?

p tree.preorder
p tree.inorder
p tree.postorder
