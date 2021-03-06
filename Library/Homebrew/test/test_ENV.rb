require 'testing_env'
require 'hardware'

class EnvironmentTests < Test::Unit::TestCase
  def test_ENV_options
    ENV.gcc_4_0
    begin
      ENV.gcc_4_2
    rescue RuntimeError => e
      if `sw_vers -productVersion` =~ /10\.(\d+)/ and $1.to_i < 7
        raise e
      end
    end
    ENV.O3
    ENV.minimal_optimization
    ENV.no_optimization
    ENV.libxml2
    ENV.enable_warnings
    assert !ENV.cc.empty?
    assert !ENV.cxx.empty?
  end

  def test_switching_compilers
    ENV.llvm
    ENV.clang
    assert_nil ENV['LD']
    assert_equal ENV['OBJC'], ENV['CC']
  end

  def test_with_build_environment
    before = ENV.to_hash
    ENV.with_build_environment do
      ENV['foo'] = 'bar'
    end
    assert_nil ENV['foo']
    assert_equal before, ENV.to_hash
  end
end
