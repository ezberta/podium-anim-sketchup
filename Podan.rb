# coding: utf-8
# Copyright 2019 Eugene Berta
# Licensed under the MIT license
#

require 'sketchup.rb'
require 'extensions.rb'

module CommunityExtensions
  module Lsystem

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Podan', 'Podan/main')
      ex.description = 'Podium Animations Helper ' <<
                       'See https://github.com/ezberta/podium-anim-sketchup' <<
                       ' for WARNINGS and usage instructions.'
      ex.version     = '0.0.1'
      ex.copyright   = '2019 Eugene Berta, ' <<
                       'released under the MIT License'
      ex.creator     = 'Eugene Berta'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end # module Lsystem
end # module CommunityExtensions

