class BinaryTree
    attr_reader :adjacency_list
    attr_accessor :visited, :distance, :parent, :queue, :left_side

    def initialize(adjacency_list)
        @adjacency_list = adjacency_list
        @n = adjacency_list.length
        @visited = Array.new(@n, false)
        @distance = Array.new(@n, 0)
        @parent = Array.new(@n)
        @queue = Queue.new
        @left_side = []
    end

    def bfs(source = 1)

        self.queue.enq(source)
        visited[source] = true
        self.left_side.push(source)
        level = self.distance[source]

        while( ! queue.empty? )
            visit = queue.deq
            
            self.adjacency_list[visit].each do |node|
                if !visited[node]
                    visited[node] = true
                    self.queue.enq(node)
                    self.distance[node] = self.distance[visit] + 1;

                    if (level < self.distance[visit] + 1) 
                        self.left_side.push(node)
                        level = self.distance[visit] + 1
                    end

                    self.parent[node] = visit;
                end
            end
        end
    end

    def print_left_side_node
        bfs
        puts self.left_side
    end
end


adjacency_list = []

# Third Example
adjacency_list[1] = [2, 3]
adjacency_list[2] = [1, 4, 5]
adjacency_list[3] = [1, 6]
adjacency_list[4] = [2]
adjacency_list[5] = [2, 7]
adjacency_list[6] = [3, 8]
adjacency_list[7] = [5]
adjacency_list[8] = [6]


# Second Example
# adjacency_list[1] = [2, 3]
# adjacency_list[2] = [1, 4]
# adjacency_list[3] = [1]
# adjacency_list[4] = [2, 5]
# adjacency_list[5] = [4, 6]
# adjacency_list[6] = [5]

bTree = BinaryTree.new(adjacency_list)
bTree.print_left_side_node