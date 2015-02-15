require_relative './tokens.rb'


class ScannerException < Exception  
  def initialize line=0, index=0, str='', msg=''
    super "Unexpected character '#{str[index]}' on #{line}:#{index}. #{msg}"
  end
end




class Scanner
  LOWER_ALPHA = (97..122).map{ |i| i.chr }
  UPPER_ALPHA = (65..90).map{ |i| i.chr }
  NUMERIC = (48..57).map{ |i| i.chr }
  ID_START = LOWER_ALPHA + UPPER_ALPHA + ['_']
  ID_CONTENT = ID_START + NUMERIC

  # Note that 'next' is the same as repeating the current character. 
  def self.scan string, nofail=true, quite=true, line=0
    # Turn that mofo into an array
    string = string.each_char.to_a
    index = 0
    is_integer = false
    is_real = false
    is_string = false
    is_id = false
    used_e = false
    token = nil
    tokens = []
    while index <= string.length
      begin
        char = string[index]
        next_char = string[index + 1]
  
        case token
        when nil
          case char
          when nil
            break
          when ' '
            # do nothing
          when "\n"
            # do nothing
          when "\t"
            # do nothing
          when '+'
            tokens << Operator.new(char)
          when '-'
            tokens << Operator.new(char)
          when '*'
            tokens << Operator.new(char)
          when '/'
            tokens << Operator.new(char)
          when '%'
            tokens << Operator.new(char)
          when '^'
            tokens << Operator.new(char)
          when '='
            tokens << Comparison.new(char)
          when '>'
            token = char
          when '<'
            token = char
          when ':'
            token = char
          when '('
            tokens << Paren.new(char)
          when ')'
            tokens << Paren.new(char)
          when '!'
            token = char
          when 'a'
            token = char
          when 'b'
            token = char
          when 'c'
            token = char
          when 'f'
            token = char
          when 'i'
            token = char
          when 'l'
            token = char
          when 'n'
            token = char
          when 'o'
            token = char
          when 's'
            token = char
          when 't'
            token = char
          when 'w'
            token = char
          when '"'
            token = char
            is_string = true
          #
          # Cases with ranges of characters
          #
          else
            case
            when NUMERIC.include?(char)
              token = char
              is_integer = true
            when ID_START.include?(char)
              token = char
              is_id = true
            else
              throw ScannerException.new line, index, char
            end
          end
        when '>'
          case char
          when '='
            tokens << Comparison.new(token + char)
            token = nil
          else
            tokens << Comparison.new(token)
            token = nil
            next
          end
        when '<'
          case char
          when '='
            tokens << Comparison.new(token + char)
            token = nil
          else
            tokens << Comparison.new(token)
            token = nil
            next
          end
        when ':'
          case char
          when '='
            tokens << MAssign.new(token + char)
            token = nil
          else
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when '!'
          case char
          when '='
            tokens << Comparison.new(token + char)
            token = nil
          else
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # and
        #
        when 'a'
          case char
          when 'n'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char)
              token += char
              is_id = true
              index += 1
              next
            end
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'an'
          case char
          when 'd'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Logic.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # bool
        #
        when 'b'
          case char
          when 'o'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'bo'
          case char
          when 'o'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'boo'
          case char
          when 'l'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Type.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            index -= 3
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # cos
        #
        when 'c'
          case char
          when 'o'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'co'
          case char
          when 's'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Function.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # false
        #
        when 'f'
          case char
          when 'a'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'fa'
          case char
          when 'l'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'fal'
          case char
          when 's'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 3
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'fals'
          case char
          when 'e'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << MBoolean.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 4
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # if / int
        #
        when 'i'
          case char
          when 'f'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << MIf.new(token + char)
            token = nil
          when 'n'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'in'
          case char
          when 't'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Type.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # let
        #
        when 'l'
          case char
          when 'e'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'le'
          case char
          when 't'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << MLet.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # not
        #
        when 'n'
          case char
          when 'o'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'no'
          case char
          when 't'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Logic.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # or
        #
        when 'o'
          case char
          when 'r'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Logic.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
          #
          # real
          #
          when 'r'
            case char
            when 'e'
              token += char
            when ' '
              tokens << Id.new(token)
              token = nil
              is_id = false
            else
              if ID_CONTENT.include?(char) 
                token += char
                is_id = true
                index += 1
                next
              end
  
              index -= 1
              token = nil
              throw ScannerException.new line, index, string
            end
          when 're'
            case char
            when 'a'
              token += char
            when ' '
              tokens << Id.new(token)
              token = nil
              is_id = false
            else
              if ID_CONTENT.include?(char) 
                token += char
                is_id = true
                index += 1
                next
              end
  
              index -= 2
              token = nil
              throw ScannerException.new line, index, string
            end
          when 'rea'
            case char
            when 'l'
              if ID_CONTENT.include?(next_char) 
                token += char
                is_id = true
                index += 1
                next
              end
              tokens << Type.new(token + char)
              token = nil
            when ' '
              tokens << Id.new(token)
              token = nil
              is_id = false
            else
              if ID_CONTENT.include?(char) 
                token += char
                is_id = true
                index += 1
                next
              end
  
              index -= 3
              token = nil
              throw ScannerException.new line, index, string
            end
        #
        # sin / stdout / string
        #
        when 's'
          case char
          when 'i'
            token += char
          when 't'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # sin
        #
        when 'si'
          case char
          when 'n'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Function.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'st'
          case char
          when 'r'
            token += char
          when 'd'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # stdout
        #
        when 'std'
          case char
          when 'o'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 3
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'stdo'
          case char
          when 'u'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 4
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'stdou'
          case char
          when 't'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Function.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 5
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # string
        #
        when 'str'
          case char
          when 'i'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 3
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'stri'
          case char
          when 'n'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 4
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'strin'
          case char
          when 'g'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Type.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 5
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # tan / true
        #
        when 't'
          case char
          when 'a'
            token += char
          when 'r'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # tan
        #
        when 'ta'
          case char
          when 'n'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << Function.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # true
        #
        when 'tr'
          case char
          when 'u'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'tru'
          case char
          when 'e'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << MBoolean.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 3
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # while
        #
        when 'w'
          case char
          when 'h'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 1
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'wh'
          case char
          when 'i'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 2
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'whi'
          case char
          when 'l'
            token += char
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 3
            token = nil
            throw ScannerException.new line, index, string
          end
        when 'whil'
          case char
          when 'e'
            if ID_CONTENT.include?(next_char) 
              token += char
              is_id = true
              index += 1
              next
            end
            tokens << MWhile.new(token + char)
            token = nil
          when ' '
            tokens << Id.new(token)
            token = nil
            is_id = false
          else
            if ID_CONTENT.include?(char) 
              token += char
              is_id = true
              index += 1
              next
            end
            
            index -= 4
            token = nil
            throw ScannerException.new line, index, string
          end
        #
        # Non-keywords
        #
        else
          #
          # String
          #
          case
          when is_string
            case char
            when '"'
              tokens << MString.new(token + char)
              token = nil
              is_string = false
            else
              token += char
            end
          #
          # Integer
          #
          when is_integer
            case
            when NUMERIC.include?(char)
              token += char
            when char == '.' && NUMERIC.include?(next_char)
              is_integer = false
              is_real = true
              token += char
            when (char == 'e' || char == 'E') && !used_e
              if NUMERIC.include?(next_char) 
                is_integer = false
                is_real = true
                used_e = true
                token += char
              elsif (next_char == '+' || next_char == '-') && NUMERIC.include?(string[index + 2]) 
                is_integer = false
                is_real = true
                used_e = true
                token += char
                token += next_char
                index += 2
                next
              else
                tokens << MInteger.new(token)
                index -= 1
                token = nil
                is_integer = false
              end
            else
              tokens << MInteger.new(token)
              index -= 1
              token = nil
              is_integer = false
            end
          #
          # Real
          #
          when is_real
            case
            when NUMERIC.include?(char)
              token += char
            when (char == 'e' || char == 'E') && !used_e
              if NUMERIC.include?(next_char) 
                used_e = true
                token += char
              elsif (next_char == '+' || next_char == '-') && NUMERIC.include?(string[index + 2]) 
                used_e = true
                token += char
                token += next_char
                index += 2
                next
              else
                tokens << MReal.new(token)
                index -= 1
                token = nil
                used_e = false
                is_real = false
              end
            else
              tokens << MReal.new(token)
              index -= 1
              token = nil
              used_e = false
              is_real = false
            end
          #
          # Id
          #
          when is_id
            case
            when ID_CONTENT.include?(char)
              token += char
            else
              tokens << Id.new(token)
              index -= 1
              token = nil
              is_id = false
            end
          end  
          
        end
      # Rescue scan errors or let them DIE
      rescue Exception => e
        if nofail
          is_integer = false
          is_real = false
          is_string = false
          is_id = false
          puts e unless quite
        else
          raise e
        end
      end
  
      index += 1
    end  
  
    return tokens
  end
  
  
  def self.scan_file file
    tokens = []
    line_no = 0
    f = File.open(file)
    
    f.each_line do |line|
      tokens += self.scan(line, false, false, line_no)
      line_no += 1
    end
    
    f.close
    tokens
  end


  def self.scan_and_print_file file
    puts self.scan_file.map {|t| "#{t.class} #{t.val}"}.join(", ") 
  end

end