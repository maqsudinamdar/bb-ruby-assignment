require 'date'

class DataAnalyzer

    attr_reader :filename
    attr_accessor :file, :machine_logs

    def initialize(filename)
      @filename = filename
      @machine_logs = []
    end

    def open_file
        self.file = File.open(filename)
    end

    def parse_data_each_line
        file.read.split("\n")
    end

    def in_second(time)
        (time * 24 * 60 * 60).to_i
    end

    def extract_date(line)
        date = line.split(' ').slice(0..2).join(' ')
        DateTime.parse(date)
    end

    def extract_device_id(line)
        pattern = /\[\d{15}\]/
        line.match(pattern).to_s.gsub!(/[\[\]]/, '')
    end

    def extract_instrument_code(line)
        pattern = /[a-z]{3}/
        line.match(pattern).to_s
    end

    def extract_status(line)
        pattern = /[(ON|OFF|ERR)]{2,3}/
        line.match(pattern).to_s
    end

    def remodeling_data(line)

        device_id = extract_device_id(line)
        status = extract_status(line)


        if self.machine_logs.length != 0
            
            machine_log_index = self.machine_logs.index {|x| 
                x[:device_id] == device_id
            }
            
            if machine_log_index

                case status
                    
                    when "OFF"
                        
                        end_time = extract_date(line)
                        start_time = self.machine_logs[machine_log_index][:status][:ON]
                        eta = in_second(end_time - start_time)

                        self.machine_logs[machine_log_index][:status][:OFF] = end_time
                        self.machine_logs[machine_log_index][:status][:ETA] = eta
                    
                    else

                        if self.machine_logs[machine_log_index][:status].has_key? :ERR
                            
                            self.machine_logs[machine_log_index][:status][:ERR].push( extract_date(line) )
                        else
                            
                            self.machine_logs[machine_log_index][:status][:ERR] = [extract_date(line)]
                        end

                end     
                
            else
                
                date = extract_date(line)
                self.machine_logs.push(
                    :date => date,
                    :device_id => device_id,
                    :instrument_code => extract_instrument_code(line),
                    :status => { status.to_sym => date }
                )
                
            end

        else

            date = extract_date(line)
            self.machine_logs.push({
                :date => date,
                :device_id => device_id,
                :instrument_code => extract_instrument_code(line),
                :status => { status.to_sym => date }                
            })
        end

    end

    def prepare_data
        open_file
        lines = parse_data_each_line()
        lines.each do |line|
            remodel_line = remodeling_data(line)
        end
    end

    def print_log(data)
        if data[:status].has_key?(:ETA)

            puts "Device #{data[:device_id]} was on for #{data[:status][:ETA]} seconds."

            if data[:status].has_key?(:ERR)
                puts "Device #{data[:device_id]} had following error events:"
                data[:status][:ERR].each do |x|
                    puts "  " + x.strftime("%b %d %H:%M:%S:%L")
                end
            else
                puts "Device #{data[:device_id]} had no error events."
            end
        end
    end

    def analyze
        prepare_data
        self.machine_logs.each do |machine_log|
            print_log(machine_log)
        end
    end

end



filenames = ARGV

filenames.each do |filename|
    data = DataAnalyzer.new(filename)
    data.analyze
end