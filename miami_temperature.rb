require 'open-uri'

class MiamiTemperature

    attr_reader :url
    attr_accessor :file, :result

    def initialize(url = 'https://gist.githubusercontent.com/neerajdotname/b2630e289e580327b8ea/raw/c0266922b9fdec4656fb99280ced2d34a3b2ba8b/miami-temperature')
        @url = url
        @result = {
            :day => [],
            :min => 0,
            :max => 0
        }
    end

    def open_file
        @file = open(self.url)
    end

    def parse_data_each_line
        self.file.read.split("\n")
    end

    def is_number(string)
        true if Integer(string) rescue false
    end

    def extract_day(line)
        line.split(' ')[0]
    end

    def extract_min_temp(line)
        string = line.split(' ')[2]
        clean_string(string).to_i
    end

    def extract_max_temp(line)
        string = line.split(' ')[1]
        clean_string(string).to_i
    end

    def clean_string(string)
        pattern = /^[*]/
        string.sub(pattern, '')
    end

    def update_min_result(diff, day)
        if( self.result[:min].to_i > diff) 
            self.result[:min] = diff
            self.result[:min_day] = day
        end
    end

    def update_max_result(diff, day)
        if( self.result[:max].to_i < diff) 
            self.result[:max] = diff
            self.result[:max_day] = day
        end
    end

    def update_result(day, min, max)
        diff = max - min
        self.result[:day].push({
            day.to_sym => diff
        })

        if self.result[:min] == 0
            self.result[:min] = self.result[:max] = diff
            self.result[:min_day] = self.result[:max_day] = day
        else
            update_min_result(diff, day)
            update_max_result(diff, day)
        end
    end

    def is_correct_data(line)
        true if is_number(line[2,2]) rescue false
    end

    def prepare_data
        open_file
        lines = parse_data_each_line()
        lines.each do |line|

            if is_correct_data(line)
                day = extract_day(line)
                min = extract_min_temp(line)
                max = extract_max_temp(line)
                update_result(day, min, max)
            end
        end
    end

    def log_analysis

        puts "Day #{self.result[:max_day]} is the day in the month when the difference between the maximum temperate and the minimum temperature was the highest."
        puts "Day #{self.result[:min_day]}  is the day in the month when the difference between the maximum temperate and the minimum temperature was the least."
    end


    def analyze
        prepare_data
        log_analysis
        # print self.result
    end

end



data = MiamiTemperature.new()
data.analyze