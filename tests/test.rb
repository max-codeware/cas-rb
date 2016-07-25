#!/usr/bin/env ruby

require 'ragni-cas'


x = CAS::Variable.new("x")
two = CAS::Two

f = CAS::sqrt(CAS.pow(x, two) +  CAS::sin(x) * 2.0 + CAS::exp(x) * 3.0)

f_diff = f.diff(x)
f_diff_value = f_diff.call({
    x => 1.0
  })

puts "#{f_diff} = #{f_diff_value}"

puts CAS::export_dot("/tmp/dot_file0.dot", f_diff)

f_diff.simplify
puts "#{f_diff} = #{f_diff.call({x => 1.0})}"

puts (f.args.map { |v| v.to_s }).join(" ")
pr = f_diff.as_proc(binding())
puts pr.inspect
puts pr.call({"x" => 1.0})
puts CAS::Variable.list

class Alpha
  def initialize(op, var)
    @f = op
    @df = op.diff(var).simplify
    self.create_method(:f, @f.as_proc(binding()))
    self.create_method(:df, @df.as_proc(binding()))
  end

  def create_method(name, block)
    self.class.send(:define_method, name, block)
  end
end

t = Alpha.new f, x
puts t.f({"x" => 1.0}), t.df({"x" => 1.0})

puts f.args.inspect

begin
  y = CAS::Variable.new "x"
rescue CAS::CASError => e
  puts "Rescued reassignment of a variable: #{e}"
end

puts CAS::export_dot("/tmp/dot_file1.dot", f_diff)
puts CAS::max(f, f_diff)
puts CAS::min(f, f_diff)