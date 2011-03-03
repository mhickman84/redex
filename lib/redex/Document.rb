module Redex
  class SourceFile

    extend Redex::DataHelper

    NAMESPACE = :file

    def self.get_line(file_name, number)
      db.zrangebyscore(file_name, number, number).first
    end

    def self.get_lines(file_name, range=nil)
      if range
        db.zrangebyscore(file_name, range.first, range.last)
      else
        db.zrangebyscore(file_name, "-inf", "+inf")
      end
    end

    def self.add_line(file_name, number, value)
      db.zadd file_name, number, value
    end

    def self.add_lines(file_name, lines)
      db.multi do
        lines.each_with_index do |line, index|
          add_line(file_name, index, line)
        end
      end
    end

    private
    def self.add_file(path_to_file)
      line_counter = 0
      IO.foreach path_to_file do |line|
        db.multi do
          add_line(File.basename(path_to_file, ".txt"), line_counter, line)
          line_counter += 1
        end
      end
    end
  end
end