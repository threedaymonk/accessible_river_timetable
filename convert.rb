require "builder"
require "detabulator"
require "haml"

sections = []

$stdin.each_line do |line|
  line.chomp!
  case line
  when /^(EAST|WEST)BOUND/
    sections << [line.split(/\s{4,}/).first, []]
  when /^\s/
    # skip
  when /(?:C|\d{4})\s+(?:C|\d{4})/
    sections.last[1] << line
  end
end

timetables = sections.map{ |section, table|
  buffer = ""
  x = Builder::XmlMarkup.new(:target => buffer, :indent => 2)
  rows = Detabulator.new.detabulate(table.join("\n"))
  x.table do
    x.tbody do
      rows.each do |row|
        x.tr do
          x.th row[0, 2].compact.join(" ") # The O2 sits far enough out to get its own column
          row[3..-1].each_with_index do |cell, i|
            format =
              case cell
              when "C"
                ["C", {:class => "change"}]
              when "...."
                ["—", {:class => "skipped"}]
              when ""
                ["", {:class => "none"}]
              when /\d{4}/
                star = (i == (row.length - 4)) ? "*" : ""
                case row[2]
                when /Arrive/
                  [cell + "a" + star, {:class => "arrive"}]
                when /Depart/
                  [cell + "d" + star, {:class => "depart"}]
                else
                  [cell + star]
                end
              else
                [""]
              end
            x.td *format
          end
        end
      end
    end
  end
  [section, buffer]
}

template = File.read("template.haml")
engine = Haml::Engine.new(template, :format => :html5, :escape_html => true)
puts engine.to_html(Object.new, {:timetables => timetables})
