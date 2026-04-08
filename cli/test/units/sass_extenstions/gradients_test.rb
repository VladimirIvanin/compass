require_relative '../../test_helper'

class GradientTestClass
  extend Compass::Core::SassExtensions::Functions::GradientSupport::Assertions
  extend Compass::Core::SassExtensions::Functions::Constants
  extend Compass::Core::SassExtensions::Functions::GradientSupport::Functions
  def self.options
    {}
  end
end

class GradientsTest < Test::Unit::TestCase
  include Sass::Script::Value::Helpers

  def klass
    GradientTestClass
  end

  # Sass::Script::Value objects created outside the parser need #options for #to_s.
  def prime_sass_options(*values)
    o = Sass::Engine::DEFAULT_OPTIONS
    values.compact.each do |v|
      next unless v.is_a?(Sass::Script::Value::Base)
      v.options = o
      v.value.each { |x| prime_sass_options(x) } if v.is_a?(Sass::Script::Value::List)
    end
  end

  test "should return correct angle" do
    assert_equal number(330, 'deg'), klass.convert_angle_from_offical(number(120, 'deg'))
  end

  test "Should convert old to new" do
    [:top => ['to', 'bottom'], :bottom => ['to', 'top'], :left => ['to', 'right'], :right => ['to', 'left']].each do |test_value|
      assert_equal list(identifier(test_value.keys.first.to_s), :space), klass.convert_angle_from_offical(
        list(identifier(test_value.values[0].first), identifier(test_value.values[0].last), :space))
    end
  end

  test "color_stops parses CSS double-position stop (transparent 0 25%)" do
    transparent = Sass::Script::Value::String.new("transparent")
    triplet = list([transparent, number(0), number(25, "%")], :space)
    stops = klass.send(:color_stops, triplet)
    assert_equal 1, stops.value.size
    cs = stops.value.first
    assert_equal transparent, cs.color
    assert_equal number(0), cs.stop
    assert_equal number(25, "%"), cs.stop2
    assert_match(/transparent.*25%/, cs.to_s)
  end

  test "radial-gradient includes double-position stop in official CSS output" do
    transparent = Sass::Script::Value::String.new("transparent")
    pos = list([identifier("circle"), identifier("at"), number(70, "%"), number(20, "%")], :space)
    highlight = Sass::Script::Value::Color.new([255, 255, 255, 0.08])
    plateau = list([transparent, number(0), number(25, "%")], :space)
    prime_sass_options(pos, highlight, plateau)
    g = klass.radial_gradient(pos, nil, highlight, plateau)
    g.options = Sass::Engine::DEFAULT_OPTIONS
    out = g.to_official.to_s
    assert_match(/transparent 0% 25%/, out)
  end

  test "radial grad_position uses outer stop for double-position last color-stop" do
    transparent = Sass::Script::Value::String.new("transparent")
    c1 = Sass::Script::Value::Color.new([255, 255, 255, 1])
    plateau = list([transparent, number(0), number(30, "%")], :space)
    stops = klass.send(:color_stops, c1, plateau)
    prime_sass_options(stops)
    norm = klass.send(:normalize_stops, stops)
    edge = klass.send(:grad_position, norm, number(2), number(100), bool(false))
    assert_equal number(30, "%"), edge
  end

  test "linear-gradient includes double-position stop in output" do
    transparent = Sass::Script::Value::String.new("transparent")
    angle = number(145, "deg")
    from = Sass::Script::Value::Color.new([212, 191, 154, 0.08])
    plateau = list([transparent, number(0), number(48, "%")], :space)
    prime_sass_options(angle, from, plateau)
    g = klass.send(:_linear_gradient, angle, from, plateau)
    g.options = Sass::Engine::DEFAULT_OPTIONS
    assert_match(/transparent 0% 48%/, g.to_s)
  end

  # --- регрессия: поведение до поддержки двойных позиций ---

  test "classic stop color plus single position has no stop2" do
    red = Sass::Script::Value::Color.new([255, 0, 0])
    pair = list([red, number(50, "%")], :space)
    stops = klass.send(:color_stops, pair)
    cs = stops.value.first
    assert_nil cs.stop2
    assert_equal number(50, "%"), cs.stop
    assert_equal red, cs.color
  end

  test "classic radial two stops without plateau matches prior shape" do
    red = Sass::Script::Value::Color.new([255, 0, 0])
    blue = Sass::Script::Value::Color.new([0, 0, 255])
    end_stop = list([blue, number(100, "%")], :space)
    prime_sass_options(red, end_stop)
    g = klass.radial_gradient(nil, nil, red, end_stop)
    g.options = Sass::Engine::DEFAULT_OPTIONS
    out = g.to_official.to_s
    assert_match(/radial-gradient\(/, out)
    assert_match(/100%/, out)
    assert_equal false, g.color_stops.value.any? { |cs| cs.stop2 }
  end

  test "bare color stop without position still works" do
    violet = Sass::Script::Value::Color.new([128, 0, 255])
    stops = klass.send(:color_stops, violet)
    assert_equal 1, stops.value.size
    assert_nil stops.value.first.stop
    assert_nil stops.value.first.stop2
  end

  # --- двойная позиция: варианты синтаксиса ---

  test "double-position stop with comma-separated list" do
    transparent = Sass::Script::Value::String.new("transparent")
    triplet = list([transparent, number(0), number(25, "%")], :comma)
    stops = klass.send(:color_stops, triplet)
    cs = stops.value.first
    assert_equal number(25, "%"), cs.stop2
  end

  test "double-position with rgb color and percentage pair" do
    c = Sass::Script::Value::Color.new([100, 150, 200])
    plateau = list([c, number(10, "%"), number(40, "%")], :space)
    stops = klass.send(:color_stops, plateau)
    cs = stops.value.first
    assert_equal c, cs.color
    assert_equal number(10, "%"), cs.stop
    assert_equal number(40, "%"), cs.stop2
  end

  test "double-position second edge can be calc string" do
    transparent = Sass::Script::Value::String.new("transparent")
    calc_stop = Sass::Script::Value::String.new("calc(100% - 1px)")
    plateau = list([transparent, number(0), calc_stop], :space)
    stops = klass.send(:color_stops, plateau)
    cs = stops.value.first
    assert_equal calc_stop, cs.stop2
    assert_match(/calc\(100% - 1px\)/, cs.to_s)
  end

  test "linear-gradient three stops middle has double position" do
    red = Sass::Script::Value::Color.new([255, 0, 0])
    green = Sass::Script::Value::Color.new([0, 255, 0])
    blue = Sass::Script::Value::Color.new([0, 0, 255])
    mid = list([green, number(25, "%"), number(75, "%")], :space)
    angle = number(180, "deg")
    prime_sass_options(angle, red, mid, blue)
    g = klass.send(:_linear_gradient, angle, red, mid, blue)
    g.options = Sass::Engine::DEFAULT_OPTIONS
    out = g.to_s
    assert_match(/25%/, out)
    assert_match(/75%/, out)
    assert_operator out.index("25%"), :<, out.index("75%")
  end

  test "color_stops_in_percentages duplicates plateau into sequential pairs" do
    transparent = Sass::Script::Value::String.new("transparent")
    c1 = Sass::Script::Value::Color.new([200, 200, 200])
    plateau = list([transparent, number(0), number(25, "%")], :space)
    stops = klass.send(:color_stops, c1, plateau)
    prime_sass_options(stops)
    pairs = klass.send(:color_stops_in_percentages, stops)
    assert_equal 3, pairs.size
    assert_equal transparent, pairs[1].last
    assert_equal transparent, pairs[2].last
  end

  test "outer_stop equals stop when stop2 absent" do
    red = Sass::Script::Value::Color.new([255, 0, 0])
    pair = list([red, number(33, "%")], :space)
    cs = klass.send(:color_stops, pair).value.first
    assert_equal cs.stop, cs.outer_stop
  end

  test "three list elements that are not two positions still error" do
    a = Sass::Script::Value::Color.new([255, 255, 255])
    b = Sass::Script::Value::Color.new([0, 0, 0])
    bad = list([a, b, number(50, "%")], :space)
    assert_raises(Sass::SyntaxError) { klass.send(:color_stops, bad) }
  end

end
