#!/usr/bin/env ruby

# Copyright (c) 2016 Matteo Ragni
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without
# restriction, including without limitation the rights to use,
# copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following
# conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

module CAS
  #   ___             _            _
  #  / __|___ _ _  __| |_ __ _ _ _| |_
  # | (__/ _ \ ' \(_-<  _/ _` | ' \  _|
  #  \___\___/_||_/__/\__\__,_|_||_\__|

  ##
  # Constant is a `CAS::Op` container for a `Numeric` value, that is
  # not a `CAS::Variable`, thus its derivative it is always zero
  class Constant < CAS::Op
    def initialize(x)
      @x = x
    end

    # Evaluates the derivative of a constant. The derivative is
    # always a `CAS::Zero`
    #
    # ```
    #  d
    # -- c = 0
    # dx
    # ```
    def diff(_v)
      CAS::Zero
    end

    # Calling a constant will return the value of the constant
    # itself.
    #
    #  * **argument**: Unused argument
    #  * **returns**: `Numeric` value of the constant
    def call(_f)
      @x
    end

    # There is no dependency in a constant, thus this method will
    # always return false
    #
    #  * **argument**: Unused argument
    #  * **returns**: `FalseClass`
    def depend?(_v)
      false
    end

    # The string representation of a constant is the value
    # of the constant
    #
    #  * **returns**: `String`
    def to_s
      "#{@x}"
    end

    # Subs for a constant is a dummy method that returns always `self`
    #
    #  * **argument**: Unused argument
    #  * **returns**: `CAS::Constant` that represent `self`
    def subs(_dt)
      return self
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      return self
    end
    @@simplify_dict = { }

    # Args of a constant is an empty `Array`
    #
    #  * **returns**: `Array` empty
    def args
      []
    end

    # Check if a constant is equal to another `CAS::Op` object
    #
    #  * **argument**: `CAs::Op`
    #  * **returns**: `TrueClass` or `FalseClass`
    def ==(op)
      if op.is_a? CAS::Constant
        return @x == op.x
      else
        return false
      end
    end

    # Inspection for `CAS::Constant` class
    #
    #  * **returns**: `String`
    def inspect
      "Const(#{self})"
    end
  end

  # Allows to define a series of new constants.
  #
  # ``` ruby
  # a, b = CAS::const 1.0, 100
  # ```
  #
  #  * **argument**: `Array` of Numeric
  #  * **returns**: `Array` of `CAS::Contant`
  def self.const(*val)
    #(val = [val]) if val.size == 1
    ret = []
    val.each do |n|
      ret << (NumericToConst[n] ? NumericToConst[n] : CAS::Constant.new(n))
    end
    return (ret.size == 1 ? ret[0] : ret)
  end

  #  _______ ___  ___
  # |_  / __| _ \/ _ \
  #  / /| _||   / (_) |
  # /___|___|_|_\\___/

  ##
  # Class that represents the constant Zero (0)
  class ZERO_CONSTANT < CAS::Constant
    # Initializer for the zero constant
    #
    #  * **returns**: `CAS::ZERO_CONSTANT` new instance
    def initialize
      @x = 0.0
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "0"
    end
  end # Zero

  # Zero (0) constant representation
  Zero = CAS::ZERO_CONSTANT.new

  #   ___
  #  / _ \ _ _  ___
  # | (_) | ' \/ -_)
  #  \___/|_||_\___|

  ##
  # Class that represents the constant One (1)
  class ONE_CONSTANT < CAS::Constant
    # Initializer for the one constant
    #
    #  * **returns**: `CAS::ONE_CONSTANT` new instance
    def initialize
      @x = 1.0
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "1"
    end
  end # Zero

  # One (1) constant representation
  One = CAS::ONE_CONSTANT.new

  #  _____
  # |_   _|_ __ _____
  #   | | \ V  V / _ \
  #   |_|  \_/\_/\___/

  ##
  # Class that represents the constant Two (2)
  class TWO_CONSTANT < CAS::Constant
    # Initializer for the two constant
    #
    #  * **returns**: `CAS::TWO_CONSTANT` new instance
    def initialize
      @x = 2.0
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "2"
    end
  end # Zero

  # Two (2) constant representation
  Two = CAS::TWO_CONSTANT.new

  #  ___ ___
  # | _ \_ _|
  # |  _/| |
  # |_| |___|

  ##
  # Class that represents the constant Pi (π)
  class PI_CONSTANT < CAS::Constant
    # Initializer for the pi constant
    #
    #  * **returns**: `CAS::PI_CONSTANT` new instance
    def initialize
      @x = Math::PI
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "π"
    end
  end

  # Pi (3.14...) constant representation
  Pi = CAS::PI_CONSTANT.new

  #  ___
  # | __|
  # | _|
  # |___|

  ##
  # Class that represents the constant E (e)
  class E_CONSTANT < CAS::Constant
    # Initializer for the E constant
    #
    #  * **returns**: `CAS::E_CONSTANT` new instance
    def initialize
      @x = Math::E
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "e"
    end
  end

  # E (2.57...) constant representation
  E = CAS::E_CONSTANT.new

  #  ___       __ _      _ _
  # |_ _|_ _  / _(_)_ _ (_) |_ _  _
  #  | || ' \|  _| | ' \| |  _| || |
  # |___|_||_|_| |_|_||_|_|\__|\_, |
  #                            |__/

  ##
  # Class that represents the constant Infinity (∞)
  class INFINITY_CONSTANT < CAS::Constant
    # Initializer for the infinity constant
    #
    #  * **returns**: `CAS::INFINITY_CONSTANT` new instance
    def initialize
      @x = (1.0/0.0)
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "∞"
    end
  end

  # Infinity constant representation
  Infinity = CAS::INFINITY_CONSTANT.new

  #  _  _          ___       __ _      _ _
  # | \| |___ __ _|_ _|_ _  / _(_)_ _ (_) |_ _  _
  # | .` / -_) _` || || ' \|  _| | ' \| |  _| || |
  # |_|\_\___\__, |___|_||_|_| |_|_||_|_|\__|\_, |
  #          |___/                           |__/

  ##
  # Class that represents the constant Negative Infinity (-∞)
  class NEG_INFINITY_CONSTANT < CAS::Constant
    # Initializer for the negative infinity constant
    #
    #  * **returns**: `CAS::NEG_INFINITY_CONSTANT` new instance
    def initialize
      @x = -(1.0/0.0)
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "-∞"
    end
  end

  # Negative Infinity constant representation
  NegInfinity = CAS::NEG_INFINITY_CONSTANT.new

  #      _
  #  ___/ |
  # |___| |
  #     |_|

  ##
  # Class that represents the constant Minus One (-1)
  class MINUS_ONE_CONSTANT < CAS::Constant
    # Initializer for the minus one constant
    #
    #  * **returns**: `CAS::MINUS_ONE_CONSTANT` new instance
    def initialize
      @x = -1.0
    end

    # String representation for the constant
    #
    #  * **returns**: `String`
    def to_s
      "-1"
    end
  end

  # Minus One (-1) constant representation
  MinusOne = CAS::MINUS_ONE_CONSTANT.new

  # Series of useful numeric constant, Based upon
  # `Numeric` keys, with `CAs::Constant` value
  NumericToConst = {
    0 => CAS::Zero,
    0.0 => CAS::Zero,
    1 => CAS::One,
    1.0 => CAS::One,
    2 => CAS::Two,
    2.0 => CAS::Two,
    Math::PI => CAS::Pi,
    Math::E => CAS::E,
    (1.0/0.0) => CAS::Infinity,
  }

  class Constant
    @@simplify_dict = {
      0 => CAS::Zero,
      1 => CAS::One,
      Math::PI => CAS::Pi,
      Math::E => CAS::E,
      (1.0/0.0) => CAS::Infinity
    }
  end
end
