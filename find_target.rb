class FindTarget

    attr_reader :array, :target
    attr_accessor :dp, :result, :index
    
    def initialize(array, target)
        @array = array
        @target = target
        @dp = []
        @result = []
        @index = []
    end

    def print_log        
        print self.result
        puts
    end

    def update_index(i)
        self.index[self.array[i]] = i if self.index[self.array[i]].nil?
    end

    def solve
        for i in 0...self.array.length do

            update_index(i)

            if self.array[i] < self.target
                if !self.dp[self.array[i]].nil?
                    self.result = [index[self.dp[self.array[i]]], index[self.array[i]]]
                    break
                end
                self.dp[target-self.array[i]] = self.array[i]
            else
                self.dp[i] = -1
            end
        end
    end

    def calculate
        solve
        print_log
    end

end

numbers = [1,2,3,5,2]
target = 4

calc = FindTarget.new(numbers, target)
calc.calculate