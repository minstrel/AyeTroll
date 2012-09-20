#!/usr/bin/ruby
require 'optparse'

#Use OptionParser library to allow the following arguments:
#-f: Number of fantasy words
#-n: Number of non-fantasy words
#-aF: alternate words, starting with fantasy
#-aN: alternate words, starting with non-fantasy
#-r: random sequence of fantasy/non-fantasy words
#-x: number of passwords to generate

passwords = 1
fantasytotal = 2
nonfantasytotal = 2
alternate = :nonfantasy
opts = OptionParser.new
opts.on('-f NUMBER', Integer, 'Number of fantasy words, default is 2') {|num| fantasytotal = num}
opts.on('-n NUMBER', Integer, 'Number of non-fantasy words, default is 2') {|num| nonfantasytotal = num}
opts.on('-a', 'Alternate order of fantasy/non-fantasy words, starting with fantasy') {alternate = :fantasy}
opts.on('-A', 'Alternate order of fantasy/non-fantasy words, starting with non-fantasy (default)') {alternate = :nonfantasy}
opts.on('-r', 'Random order of fantasy/non-fantasy words') {alternate = :random}
opts.on('-x NUMBER', Integer, 'Number of passwords to generate') {|num| passwords = num}
opts.parse(ARGV)


class AyeTroll
  def initialize

#Put words from fantasy lists and full dictionary lists into arrays, removing any with apostrophes

    @fantasywords = []
    @nonfantasywords = []

    File.open("fantasy", "r") do |fantasy|
      while line = fantasy.gets
        next if line =~ /\'/
        @fantasywords << line.downcase
      end
    end

    File.open("words", "r") do |words|
      while line = words.gets
        next if line =~ /\'/
        @nonfantasywords << line.downcase
      end
    end

#Remove duplicates from full dictionary list

    @fantasywords.each do |fantasy|
      @nonfantasywords.delete(fantasy)
    end

    @fantasywordslength = @fantasywords.length
    @nonfantasywordslength = @nonfantasywords.length
  end

  def pickfantasy
    @fantasywords[rand(@fantasywordslength)].chomp
  end

  def picknonfantasy
    @nonfantasywords[rand(@nonfantasywordslength)].chomp
  end

end

orig_fantasytotal = fantasytotal
orig_nonfantasytotal = nonfantasytotal

passwords.times do

fantasytotal = orig_fantasytotal
nonfantasytotal = orig_nonfantasytotal

password = AyeTroll.new

while alternate == :nonfantasy
  if nonfantasytotal <= 0 and fantasytotal <= 0
  puts ''
  break
  end
  print password.picknonfantasy + ' ' if nonfantasytotal >= 1
  nonfantasytotal -= 1
  print password.pickfantasy + ' ' if fantasytotal >= 1
  fantasytotal -= 1  
end

while alternate == :fantasy
  if nonfantasytotal <= 0 and fantasytotal <= 0
  puts ''
  break
  end
  print password.pickfantasy + ' ' if fantasytotal >= 1
  fantasytotal -= 1
  print password.picknonfantasy + ' ' if nonfantasytotal >= 1
  nonfantasytotal -= 1  
end

while alternate == :random
  if nonfantasytotal <= 0 and fantasytotal <= 0
  puts ''
  break
  end
  rn = rand(2)
  if rn == 1
    print password.pickfantasy + ' ' if fantasytotal >= 1
    fantasytotal -= 1
  else
    print password.picknonfantasy + ' ' if nonfantasytotal >= 1
    nonfantasytotal -= 1  
  end
end

end
