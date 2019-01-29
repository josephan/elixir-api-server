def main(input_file)
  checksums = []
  even_sum = 0
  odd_sum = 0

  File.readlines(input_file).each do |line|
    command = get_command(line)

    case command
    when 'A'
      new_evens_sum, new_odds_sum = get_number_totals(line)
      even_sum = even_sum + new_evens_sum
      odd_sum = odd_sum + new_odds_sum
    when 'C'
      even_sum = 0
      odd_sum = 0
    when 'CS'
      checksum = calculate_checksum(even_sum, odd_sum)
      checksums << checksum
    end
  end
  puts("Final list of checksums: [#{checksums.join(', ')}]")
end

def get_command(line)
  return 'CS' if line.start_with?('CS')
  return 'C' if line.start_with?('C')
  return 'A' if line.start_with?('A') && line[1..-1].match(/^(\d)+$/)

  nil
end

def get_number_totals(line)
  evens = 0
  odds = 0
  line[1..-1].to_i.digits.reverse.each_with_index do |number, index|
    if index.even?
      evens = evens + number
    else
      odds = odds + number
    end
  end
  [evens, odds]
end

def calculate_checksum(even_sum, odd_sum)
  remainder = ((odd_sum * 3) + even_sum).digits.first
  if remainder == 0
    0
  else
    10 - remainder
  end
end

main(ARGV[0])
