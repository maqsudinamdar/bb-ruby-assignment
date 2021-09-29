require 'open-uri'

class UkSoccer

    attr_reader :url, :group_array
    attr_accessor :file, :team, :group

    def initialize(url = 'https://gist.githubusercontent.com/neerajdotname/32f984f7f270876e5431185c4ebab1df/raw/b8fac78e118e7699f309e37d8a826d08eca4a702/uk-soccer-team.txt')
        @url = url
        @team = []
        @group_array = ["Group A", "Group B", "Group C", "Group D", "Group E"]
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
        puts self.group_array
    end

    def analyze
        prepare_data
        sort_team_by_points
        group_by_team
    end

end



data = UkSoccer.new()
data.analyze