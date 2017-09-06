module VarIntExtensions
  refine StringIO do
    def read_varint
      num = 0
      shift = 0
      loop do
        octet = self.getbyte
        raise EOFError.new('Unexpected end of data.') if octet.nil?

        num |= (octet & 0x7f) << shift
        return num if octet & 0x80 == 0
        shift += 7
      end
    end

    def write_varint(num)
      octets = []
      loop do
        octet = num & 0x7f
        if (num >>= 7) > 0
          octet |= 0x80
          octets << (octet | 0x80)
        else
          octets << octet
          self.write(octets.pack('C*'))
          return
        end
      end
    end
  end
end
