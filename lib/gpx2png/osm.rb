require 'rubygems'
require 'gpx2png/osm_base'

$:.unshift(File.dirname(__FILE__))

module Gpx2png
  class Osm < OsmBase

    DEFAULT_RENDERER = :rmagick
    attr_accessor :renderer

    def initialize
      super
      @renderer ||= DEFAULT_RENDERER
      @r = nil
    end

    def save(filename)
      render
      @r.save(filename)
    end

    def to_png
      render
      @r.to_png
    end

    def render
      setup_renderer
      initial_calculations
      download_and_join_tiles
    end

    attr_accessor :renderer_options

    # Get proper renderer class
    def setup_renderer
      case @renderer
        when :chunky_png
          require File.expand_path('../renderers/chunky_png_renderer', __FILE__)
          @r = ChunkyPngRenderer.new(@renderer_options)
        when :rmagick
          require File.expand_path('../renderers/rmagick_renderer', __FILE__)
          @r = RmagickRenderer.new(@renderer_options)
        else
          raise ArgumentError
      end
    end

  end
end