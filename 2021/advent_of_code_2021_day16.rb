def hex_to_binary(hex)
  "".tap do |binary|
    hex.each_char do |char|
      binary <<  "%04d" % char.hex.to_s(2)
    end
  end
end

def decode_hex(hex)
  binary = hex_to_binary(hex)
  decode_binary(binary)[0]
end

def decode_binary(binary)
  version, type_id, subpackets = binary[0..2], binary[3..5], binary[6..-1]

  # puts "*** version = #{version}"
  # puts "*** type_id = #{type_id}"
  # puts "*** subpackets = #{subpackets}"

  if type_id == "100" # Literal
    packet, subpackets = decode_binary_literal(subpackets)
  else # Operator
    packet, subpackets = decode_binary_operator(subpackets)
  end

  return [ version, type_id, packet ], subpackets
end

def decode_binary_literal(subpackets)
  # puts "*** Literal"
  binary = ""

  while true
    byte = subpackets[0..4]
    subpackets = subpackets[5..-1]

    binary << byte[1..-1]

    if byte[0] == "0" # last byte
      break
    end
  end

  return binary.to_i(2), subpackets
end

def decode_binary_operator(bytes)
  length_type_id = bytes[0..0]
  output = []
  if length_type_id == "0"
    # puts "*** Fixed length operator"
    length = bytes[1..15].to_i(2)
    string = bytes[16..(15+length)]
    remainder = bytes[(16+length)..-1]
    while !string.empty?
      packet, string = decode_binary(string)
      output << packet
    end
  else
    # puts "*** Num packets operator"
    num_sub_packets = bytes[1..11].to_i(2)
    remainder = bytes[12..-1]
    num_sub_packets.times do |i|
      packet, remainder = decode_binary(remainder)
      output << packet
    end
  end

  return output, remainder
end

def sum_version_numbers(hex)
  output = decode_hex(hex)
  sum_versions(output)
end

def sum_versions(packet)
  num = packet[0].to_i(2)

  if packet[2].is_a?(Array)
    sum = num
    packet[2].each do |packet_item|
      sum += sum_versions(packet_item)
    end
    sum
  else
    num
  end
end

def packet_value(hex)
  output = decode_hex(hex)

  _packet_value(output)
end

def _packet_value(packet)
  if packet[2].is_a?(Array)
    nums = []
    packet[2].each do |packet_item|
      nums << _packet_value(packet_item)
    end

    case packet[1].to_i(2)
    when 0
      nums.sum
    when 1
      nums.inject(:*)
    when 2
      nums.min
    when 3
      nums.max
    when 5
      nums[0] > nums[1] ? 1 : 0
    when 6
      nums[0] < nums[1] ? 1 : 0
    when 7
      nums[0] == nums[1] ? 1 : 0
    end
  else
    packet[2]
  end
end

data = File.open("/Users/patrickgeorge/dev/personal/advent_of_code/2021/advent_of_code_2021_day16_input.txt").read
pp sum_version_numbers(data)

pp packet_value(data)

# ------- TESTS --------

def test_hex_to_binary
  pp hex_to_binary("D2FE28") == "110100101111111000101000"
  pp hex_to_binary("38006F45291200") == "00111000000000000110111101000101001010010001001000000000"
  pp hex_to_binary("EE00D40C823060") == "11101110000000001101010000001100100000100011000001100000"
end

def test_decode_binary_literal
  binary = "110100101111111000101000"

  pp decode_binary(binary)[0][2] == 2021
end

def test_decode_binary_operator_length_type_zero
  binary = "00111000000000000110111101000101001010010001001000000000"


  output = decode_binary(binary)
  pp output[0]
  pp output.length == 2
  pp output[0][2][0][2] == 10
  pp output[0][2][1][2] == 20
end

def test_decode_binary_operator_length_type_one
  binary = "11101110000000001101010000001100100000100011000001100000"

  output = decode_binary(binary)
  pp output[0]
  pp output.length == 2
  pp output[0][2][0][2] == 1
  pp output[0][2][1][2] == 2
  pp output[0][2][2][2] == 3
end

def test_sum_version_numbers
  hex = "8A004A801A8002F478"
  pp sum_version_numbers(hex) == 16

  hex = "620080001611562C8802118E34"
  pp sum_version_numbers(hex) == 12

  hex = "C0015000016115A2E0802F182340"
  pp sum_version_numbers(hex) == 23

  hex = "A0016C880162017C3686B18A3D4780"
  pp sum_version_numbers(hex) == 31
end

# puts "****** test_hex_to_binary"
# test_hex_to_binary
# puts "****** test_decode_binary_literal"
# test_decode_binary_literal
# puts "****** test_decode_binary_operator_length_type_zero"
# test_decode_binary_operator_length_type_zero
# puts "****** test_decode_binary_operator_length_type_one"
# test_decode_binary_operator_length_type_one
# puts "****** test_sum_version_numbers"
# test_sum_version_numbers

def test_packet_value
  hex = "C200B40A82"
  pp packet_value(hex) == 3

  hex = "04005AC33890"
  pp packet_value(hex) == 54

  hex = "880086C3E88112"
  pp packet_value(hex) == 7

  hex = "CE00C43D881120"
  pp packet_value(hex) == 9

  hex = "D8005AC2A8F0"
  pp packet_value(hex) == 1

  hex = "F600BC2D8F"
  pp packet_value(hex) == 0

  hex = "9C005AC2F8F0"
  pp packet_value(hex) == 0

  hex = "9C0141080250320F1802104A08"
  pp packet_value(hex) == 1
end

test_packet_value
