# This little 'rake-toolio' called lessick 
# let my girl, Regina, doing her less compile jobs
# super easily.
# 
# To execute you need
#   * Ruby 1.9+
#   * gem install therubyracer
#   * and ad(d)/just the less files (paths)
#
# Author::    Van-Lang Pham  (mailto:vanlang@me.com)
# Copyright:: Copyright (c) 2015 pandaboyLabs
# License::   WTFPL

require 'fileutils'  # for communicate with shelly
require 'less'       # for using less withing ruby
require 'rake/clean' # for clean and clobber


###########################################################
### OS shit ###############################################
###########################################################
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

###########################################################
### Constants #############################################
###########################################################
# "." means move relatively forward from the current location
SOURCE = "."
# set the path to your lessi files
LESS = File.join( SOURCE, "lessick" )

CONFIG = {
    # less/css directory
    'less'   => File.join( LESS, "less" ),
    'css'    => File.join( LESS, "css" ),
    
    # TODO put all less files in here
    'input' => [
        "bootstrap.less"
        ],
    'output' => "bootstrap.css"
}

COMPRESS_CSS = true

STAR = "\xF0\x9F\x8C\xA0"
RAINBOW = "\xF0\x9F\x8C\x88"
PANDA = "\xF0\x9F\x90\xBC "
PANDAS = PANDA + PANDA + PANDA
THUMBS_UP = "\xF0\x9F\x91\x8D "
BEER_MUG = "\xF0\x9F\x8D\xBA "
BEER_MUGS = BEER_MUG + BEER_MUG + BEER_MUG

DIR_CSS = File.join( CONFIG['css'], "*" )
CLEAN.include(FileList[DIR_CSS].include('*.css'))

###########################################################
### Less Tasks ############################################
###########################################################

namespace 'lessick' do
    
    desc "Let Regina zaubers all her magic less files into css."
    task :zauber do
        CONFIG['input'].each {|i| Rake::Task['lessick:zauber_one'].invoke(i) }
        if OS.mac?
            puts
            puts BEER_MUGS + BEER_MUGS + BEER_MUGS + BEER_MUGS + BEER_MUGS
            puts PANDAS + " Zauberei, done " + THUMBS_UP + PANDAS
            puts BEER_MUGS + BEER_MUGS + BEER_MUGS + BEER_MUGS + BEER_MUGS
            puts
        else
            puts
            puts "###########################################################"
            puts "### Zauberei, done ########################################"
            puts "###########################################################"
            puts
        end 
    end
    
    desc "Let Regina zaubers only one special picked less file into css (lessFileName incl. path to the file)"
    task :zauber_one, :lessFileName do |t, args|
        less_directory = CONFIG['less']
        css_directory = CONFIG['css']
        
        # set input/output files
        input  = File.join( less_directory, args.lessFileName )
        output = File.join( css_directory, CONFIG['output'] )
        
        # create css output directory if it is not there...
        Dir.mkdir(css_directory) unless Dir.exists?(css_directory)
        
        source = File.open( input, "r" ).read

        parser = Less::Parser.new( :paths => [less_directory] )
        tree = parser.parse( source )

        File.open( output, "w+" ) do |f|
            f.puts tree.to_css( :compress => COMPRESS_CSS )
        end
    end
end 