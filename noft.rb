#!/usr/bin/env ruby

#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rubygems'
require 'bundler/setup'
require 'noft_plus'
require 'yaml'

INPUT_VERSION='3.3.7'
BASE_WORKING_DIRECTORY = File.expand_path('tmp/working')
WORKING_DIRECTORY = "#{BASE_WORKING_DIRECTORY}/#{INPUT_VERSION}"

Noft.icon_set(:glyphicon) do |s|
  s.display_string = 'Glyphicons Halflings'
  s.description = 'The Glyphicon Halfings subset included in Bootstrap'
  s.version = INPUT_VERSION
  s.url = 'http://getbootstrap.com/components/'
  s.license = 'The MIT License (MIT)'
  s.license_url = 'https://github.com/twbs/bootstrap/blob/v3.3.7/LICENSE'
  s.font_file = "#{WORKING_DIRECTORY}/webfont.svg"

  icon_metadata_filename = "#{WORKING_DIRECTORY}/glyphicons.less"

  # Download font assets
  NoftPlus::Util.download_file("https://raw.githubusercontent.com/twbs/bootstrap/v#{INPUT_VERSION}/less/glyphicons.less",
                               icon_metadata_filename)
  NoftPlus::Util.download_file("https://raw.githubusercontent.com/twbs/bootstrap/v#{INPUT_VERSION}/dist/fonts/glyphicons-halflings-regular.svg",
                               "#{WORKING_DIRECTORY}/original-webfont.svg")
  File.write(s.font_file,
             # We patch the downloaded svg as several of the icons are offcenter.
             # there are some that exceed the bounds of font but we are ignoring these
             # for now as we don't use any of them
             IO.read("#{WORKING_DIRECTORY}/original-webfont.svg").
               gsub('ascent="960"','ascent="1200"').
               gsub('ascent="-240"','descent="0"') )

  #scan font descriptor for required metadata
  IO.read(icon_metadata_filename).split("\n").each do |line|
    if line =~ /^.glyphicon-([^ ]+) .*content\: \"\\([0-9a-z]+)";.*$/
      name = $1
      unicode = $2
      s.icon(name) do |i|
        i.unicode = unicode
      end
    end
  end
end
