require 'open-uri'

class UkSoccer

    attr_reader :url, :group_array
    attr_accessor :file, :team, :groups

    def initialize(url = 'https://gist.githubusercontent.com/neerajdotname/32f984f7f270876e5431185c4ebab1df/raw/b8fac78e118e7699f309e37d8a826d08eca4a702/uk-soccer-team.txt')
        @url = url
        @team = []
        @group_array = ["Group A", "Group B", "Group C", "Group D", "Group E"]
        @groups = {}
    end

    def open_file
        @file = open(self.url)
    end

    def parse_data_each_line
        self.file.read.split("\n")
    end

    def extract_team(line)
        line.split(' ')[1]
    end

    def extract_team_goals(line)
        line.split(' ')[6].to_i
    end

    def extract_team_against_goals(line)
        line.split(' ')[8].to_i
    end

    def calculate_team_score(goals)
        goals.to_i * 3
    end

    def calculate_team_penalty(against_goals)
        against_goals.to_i * 4
    end

    def calculate_team_points(score, penalty)
        score - penalty
    end

    def is_line_contain_word_team(line)
        line.split(' ')[0] == "Team"       
    end

    def prepare_data
        open_file
        lines = parse_data_each_line()
        lines.each do |line|
            unless is_line_contain_word_team(line)

                team_name =  extract_team(line)

                goals = extract_team_goals(line)
                against_goals = extract_team_against_goals(line)

                score = calculate_team_score(goals)
                penalty = calculate_team_penalty(against_goals)
                points = calculate_team_points(score, penalty)

                self.team << {
                    team_name.to_sym => {
                        :goals => goals,
                        :against_goals => against_goals,
                        :score => score,
                        :penalty => penalty,
                        :points => points
                    }                    
                }                
            end
        end
    end

    def sort_team_by_points
        self.team.sort_by!{ |team| 
            keys = team.keys
            team[keys[0]][:points] 
        }.reverse!
    end

    def group_by_team
        i = 0
        self.team.each do |team|

            if self.groups.length > 0
                if( self.groups.has_key?(self.group_array[i].to_sym) )
                    self.groups[self.group_array[i].to_sym].push(team.keys.join(''))  
                else              
                    self.groups[self.group_array[i].to_sym]= [team.keys.join('')]              
                end
            else
                self.groups[self.group_array[i].to_sym]= [team.keys.join('')]
            end

            i = i != self.group_array.length-1 ? i+1 : 0
        end
    end

    def log_analysis
        self.groups.each do |key, value|
            puts key
            puts "==========="
            value.each do |team|
                puts team
            end
            puts
        end
    end

    def analyze
        prepare_data
        sort_team_by_points
        group_by_team
        log_analysis
    end

end



data = UkSoccer.new()
data.analyze