#!/usr/bin/env ruby

module CAS
  #  ___ _
  # / __(_)_ _
  # \__ \ | ' \
  # |___/_|_||_|

  ##
  # Representation for the `sin(x)` function. It is implemented
  # as a `CAS::Op`
  class Sin < CAS::Op
    # Return the derivative of the `sin(x)` function using the chain
    # rule. The input is a `CAS::Op` because it can handle derivatives
    # with respect to functions.
    #
    # ```
    #  d
    # -- sin(f(x)) = f'(x) cos(fx)
    # dx
    # ```
    #
    #  * **argument**: `CAS::Op` object of the derivative
    #  * **returns**: `CAS::Op` a derivated object, or `CAS::Zero` for constants
    def diff(v)
      if @x.depend? v
        return @x.diff(v) * CAS.cos(@x)
      else
        return CAS::Zero
      end
    end

    # Call resolves the operation tree in a `Numeric` (if `Fixnum`)
    # or `Float` (depends upon promotions).
    # As input, it requires an hash with `CAS::Variable` or `CAS::Variable#name`
    # as keys, and a `Numeric` as a value
    #
    #  * **argument**: `Hash` with feed dictionary
    #  * **returns**: `Numeric`
    def call(f)
      CAS::Help.assert(f, Hash)
      Math::sin(@x.call(f))
    end

    # Convert expression to string
    #
    #  * **returns**: `String` to print on screen
    def to_s
      "sin(#{@x})"
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      super
      return @x.x if @x.is_a? CAS::Asin
      return self.simplify_dictionary
    end
    @@simplify_dict = {
      CAS::Zero => CAS::Zero,
      CAS::Pi => CAS::Zero
    }

    # Convert expression to code (internal, for `CAS::Op#to_proc` method)
    #
    #  * **returns**: `String` that represent Ruby code to be parsed in `CAS::Op#to_proc`
    def to_code
      "Math::sin(#{@x.to_code})"
    end

    # Returns the latex representation of the current Op.
    #
    #  * **returns**: `String`
    def to_latex
      "\\sin\\left( #{@x.to_latex} \\right)"
    end
  end # Sin

  # Shortcut for `CAS::Sin#new`
  #
  #  * **argument**: `CAS::Op` argument of the function
  #  * **returns**: `CAS::Sin` operation
  def self.sin(x)
    CAS::Sin.new x
  end

  #    _       _
  #   /_\   __(_)_ _
  #  / _ \ (_-< | ' \
  # /_/ \_\/__/_|_||_|

  ##
  # Representation for the `arcsin(x)` function. It is implemented
  # as a `CAS::Op`. It is the inverse of the `sin(x)` function
  class Asin < CAS::Op
    # Return the derivative of the `arcsin(x)` function using the chain
    # rule. The input is a `CAS::Op`
    #
    #  * **argument**: `CAS::Op` object of the derivative
    #  * **returns**: `CAS::Op` a derivated object, or `CAS::Zero` for constants
    def diff(v)
      if @x.depend? v
        return @x.diff(v) / CAS.sqrt(CAS::One - CAS.pow(@x, CAS::Two))
      else
        return CAS::Zero
      end
    end

    # Call resolves the operation tree in a `Numeric` (if `Fixnum`)
    # or `Float` (depends upon promotions).
    # As input, it requires an hash with `CAS::Variable` or `CAS::Variable#name`
    # as keys, and a `Numeric` as a value
    #
    #  * **argument**: `Hash` with feed dictionary
    #  * **returns**: `Numeric`
    def call(f)
      CAS::Help.assert(f, Hash)
      Math::acos(@x.call(f))
    end

    # Convert expression to string
    #
    #  * **returns**: `String` to print on screen
    def to_s
      "asin(#{@x})"
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      super
      return @x.x if @x.is_a? CAS::Sin
      return self.simplify_dictionary
    end
    @@simplify_dict = {
      CAS::Zero => CAS::Zero,
      CAS::One => (CAS::Pi / 2)
    }

    # Convert expression to code (internal, for `CAS::Op#to_proc` method)
    #
    #  * **returns**: `String` that represent Ruby code to be parsed in `CAS::Op#to_proc`
    def to_code
      "Math::asin(#{@x.to_code})"
    end

    # Returns the latex representation of the current Op.
    #
    #  * **returns**: `String`
    def to_latex
      "\\arcsin\\left( #{@x.to_latex} \\right)"
    end
  end

  # Shortcut for `CAS::Asin#new`
  #
  #  * **argument**: `CAS::Op` argument of the function
  #  * **returns**: `CAS::Asin` operation
  def self.asin(x)
    CAS::Asin.new x
  end
  # alias :arcsin :asin

  #   ___
  #  / __|___ ___
  # | (__/ _ (_-<
  #  \___\___/__/

  ##
  # Representation for the `cos(x)` function. It is implemented
  # as a `CAS::Op`.
  class Cos < CAS::Op
    # Return the derivative of the `cos(x)` function using the chain
    # rule. The input is a `CAS::Op` because it can handle derivatives
    # with respect to functions.
    #
    # ```
    #  d
    # -- cos(f(x)) = -f'(x) sin(fx)
    # dx
    # ```
    #
    #  * **argument**: `CAS::Op` object of the derivative
    #  * **returns**: `CAS::Op` a derivated object, or `CAS::Zero` for constants
    def diff(v)
      if @x.depend? v
        return CAS.invert(@x.diff(v) * CAS.sin(@x))
      else
        return CAS::Zero
      end
    end

    # Call resolves the operation tree in a `Numeric` (if `Fixnum`)
    # or `Float` (depends upon promotions).
    # As input, it requires an hash with `CAS::Variable` or `CAS::Variable#name`
    # as keys, and a `Numeric` as a value
    #
    #  * **argument**: `Hash` with feed dictionary
    #  * **returns**: `Numeric`
    def call(f)
      CAS::Help.assert(f, Hash)
      Math::cos(@x.call(f))
    end

    # Convert expression to string
    #
    #  * **returns**: `String` to print on screen
    def to_s
      "cos(#{@x})"
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      super
      return @x.x if @x.is_a? CAS::Acos
      return self.simplify_dictionary
    end
    @simplify_dict = {
      CAS::Zero => CAS::One,
      CAS::Pi => CAS::One
    }

    # Convert expression to code (internal, for `CAS::Op#to_proc` method)
    #
    #  * **returns**: `String` that represent Ruby code to be parsed in `CAS::Op#to_proc`
    def to_code
      "Math::cos(#{@x.to_code})"
    end

    # Returns the latex representation of the current Op.
    #
    #  * **returns**: `String`
    def to_latex
      "\\cos\\left( #{@x.to_latex} \\right)"
    end
  end

  # Shortcut for `CAS::Cos#new`
  #
  #  * **argument**: `CAS::Op` argument of the function
  #  * **returns**: `CAS::Cos` operation
  def self.cos(x)
    CAS::Cos.new x
  end

  #    _
  #   /_\  __ ___ ___
  #  / _ \/ _/ _ (_-<
  # /_/ \_\__\___/__/

  ##
  # Representation for the `arccos(x)` function. It is implemented
  # as a `CAS::Op`. It is the inverse of the `cos(x)` function
  class Acos < CAS::Op
    def diff(v)
      if @x.depend? v
        return CAS.invert(@x.diff(v)/CAS.sqrt(CAS::One - CAS.pow(@x, CAS::Two)))
      else
        return CAS::Zero
      end
    end

    # Call resolves the operation tree in a `Numeric` (if `Fixnum`)
    # or `Float` (depends upon promotions).
    # As input, it requires an hash with `CAS::Variable` or `CAS::Variable#name`
    # as keys, and a `Numeric` as a value
    #
    #  * **argument**: `Hash` with feed dictionary
    #  * **returns**: `Numeric`
    def call(f)
      CAS::Help.assert(f, Hash)
      return Math::acos(@x.call(f))
    end

    # Convert expression to string
    #
    #  * **returns**: `String` to print on screen
    def to_s
      "acos(#{@x})"
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      super
      return @x.x if @x.is_a? CAS::Cos
      return self.simplify_dictionary
    end
    @@simplify_dict = {
      CAS::Zero => (CAS::Pi / 2),
      CAS::One => CAS::Zero
    }

    # Convert expression to code (internal, for `CAS::Op#to_proc` method)
    #
    #  * **returns**: `String` that represent Ruby code to be parsed in `CAS::Op#to_proc`
    def to_code
      "Math::acos(#{@x.to_code})"
    end

    # Returns the latex representation of the current Op.
    #
    #  * **returns**: `String`
    def to_latex
      "\\arccos\\left( #{@x.to_latex} \\right)"
    end
  end

  # Shortcut for `CAS::Acos#new`
  #
  #  * **argument**: `CAS::Op` argument of the function
  #  * **returns**: `CAS::Acos` operation
  def self.acos(x)
    CAS::Acos.new x
  end
  # alias :arccos :acos

  #  _____
  # |_   _|_ _ _ _
  #   | |/ _` | ' \
  #   |_|\__,_|_||_|

  ##
  # Representation for the `tan(x)` function. It is implemented
  # as a `CAS::Op`.
  class Tan < CAS::Op
    # Return the derivative of the `tan(x)` function using the chain
    # rule. The input is a `CAS::Op` because it can handle derivatives
    # with respect to functions. E.g.:
    #
    # ```
    #  d              f'(x)
    # -- sin(f(x)) = -------
    # dx             cos²(x)
    # ```
    #
    #  * **argument**: `CAS::Op` object of the derivative
    #  * **returns**: `CAS::Op` a derivated object, or `CAS::Zero` for constants
    def diff(v)
      if @x.depend? v
        return @x.diff(v) * CAS.pow(CAS::One/CAS.cos(@x), CAS::Two)
      else
        return CAS::Zero
      end
    end

    # Call resolves the operation tree in a `Numeric` (if `Fixnum`)
    # or `Float` (depends upon promotions).
    # As input, it requires an hash with `CAS::Variable` or `CAS::Variable#name`
    # as keys, and a `Numeric` as a value
    #
    #  * **argument**: `Hash` with feed dictionary
    #  * **returns**: `Numeric`
    def call(f)
      CAS::Help.assert(f, Hash)
      Math::tan(@x.call(f))
    end

    # Convert expression to string
    #
    #  * **returns**: `String` to print on screen
    def to_s
      "tan(#{@x})"
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      super
      return @x.x if @x.is_a? CAS::Atan
      return self.simplify_dictionary
    end
    @@simplify_dict = {
      CAS::Zero => CAS::Zero,
      CAS::Pi => CAS::Zero
    }

    # Convert expression to code (internal, for `CAS::Op#to_proc` method)
    #
    #  * **returns**: `String` that represent Ruby code to be parsed in `CAS::Op#to_proc`
    def to_code
      "Math::tan(#{@x.to_code})"
    end

    # Return latex representation of current Op
    def to_latex
      "\\tan\\left( #{@x.to_latex} \\right)"
    end
  end

  # Shortcut for `CAS::Tan#new`
  #
  #  * **argument**: `CAS::Op` argument of the function
  #  * **returns**: `CAS::Tan` operation
  def self.tan(x)
    CAS::Tan.new x
  end

  #    _  _
  #   /_\| |_ __ _ _ _
  #  / _ \  _/ _` | ' \
  # /_/ \_\__\__,_|_||_|

  ##
  # Representation for the `arctan(x)` function. It is implemented
  # as a `CAS::Op`. It is the inverse of the `tan(x)` function
  class Atan < CAS::Op
    # Return the derivative of the `arctan(x)` function using the chain
    # rule. The input is a `CAS::Op` because it can handle derivatives
    # with respect to functions.
    #
    #  * **argument**: `CAS::Op` object of the derivative
    #  * **returns**: `CAS::Op` a derivated object, or `CAS::Zero` for constants
    def diff(v)
      if @x.depend? v
        return (@x.diff(v) / (CAS.pow(@x, CAS::Two) + CAS::One))
      else
        return CAS::Zero
      end
    end

    # Call resolves the operation tree in a `Numeric` (if `Fixnum`)
    # or `Float` (depends upon promotions).
    # As input, it requires an hash with `CAS::Variable` or `CAS::Variable#name`
    # as keys, and a `Numeric` as a value
    #
    #  * **argument**: `Hash` with feed dictionary
    #  * **returns**: `Numeric`
    def call(f)
      CAS::Help.assert(f, Hash)
      Math::atan(@x.call(f))
    end

    # Convert expression to string
    #
    #  * **returns**: `String` to print on screen
    def to_s
      "atan(#{@x})"
    end

    # Simplification callback. It simplify the subgraph of each node
    # until all possible simplification are performed (thus the execution
    # time is not deterministic).
    #
    #  * **returns**: `CAS::Op` simplified version
    def simplify
      super
      return @x.x if @x.is_a? CAS::Tan
      return self.simplify_dictionary
    end
    @@simplify_dict = {
      CAS::Zero => CAS::Zero,
      CAS::One => (CAS::Pi/4),
      CAS::Infinity => (CAS::Pi/2)
    }

    # Convert expression to code (internal, for `CAS::Op#to_proc` method)
    #
    #  * **returns**: `String` that represent Ruby code to be parsed in `CAS::Op#to_proc`
    def to_code
      "Math::atan(#{@x.to_code})"
    end

    # Returns the latex representation of the current Op.
    #
    #  * **returns**: `String`
    def to_latex
      "\\arctan\\left( #{@x.to_latex} \\right)"
    end
  end

  # Shortcut for `CAS::Atan#new`
  #
  #  * **argument**: `CAS::Op` argument of the function
  #  * **returns**: `CAS::Atan` operation
  def self.atan(x)
    CAS::Atan.new x
  end
  # alias :arctan :atan
end
