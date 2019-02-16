# Copyright 2019 Eugene Berta
# Licensed under the MIT license

require 'sketchup.rb'
require 'fileutils'

module CommunityExtensions
  module Podan
    class PodanC

      @@podan = nil
         
      def forceCancel()
        @max_t = -1
      end

      attr_reader :done
      
      def initialize(pod_dir)
        @mod = Sketchup.active_model # Open model
        
        @pages = @mod.pages
        @cur_fnum = nil
        @pod_filename = nil

        @pod_dir = pod_dir

        @max_t = @pages.slideshow_time
        @cur_t = nil
        @prev_t = nil

        @spf = 1.0/24.0

        @forceCancel = 0
        @zeroHandled = false

        @done = false
        
      end

      def update_view()
        if @cur_fnum.nil?
          @cur_fnum = 0
          @cur_t = 0
        else
          @cur_fnum += 1
          @prev_t = @cur_t
          @cur_t += @spf
        end
        
        if @cur_t > @max_t
          print("EZB DONE\n")
          @@podan = nil
          if not @done
            @done = true
            UI.messagebox('Podan: Finished', MB_OK)
          end
          return
        end

        _ignore, ratio = @pages.show_frame_at(@cur_t)
        print("EZB @cur_t: #{@cur_t} @cur_fnum: #{@cur_fnum} ratio: #{ratio} zero: #{@zeroHandled}\n")
        Sketchup.active_model.active_view.refresh
        GC.start

        if not @zeroHandled and (ratio == 0.0)
          @zeroHandled = true
          if @max_t == -1
            print("EZB force DONE\n")
            @@podan = nil
            @done = true
            return
          end

          UI.start_timer(3, false) {
            self.call_render_try()
          }
          return
        end

        #print("EZB dbg ratio: #{ratio} podf: #{@pod_filename}\n")
        if ratio == 0.0 and not @pod_filename.nil?
          UI.start_timer(0, false) {
            self.copy_view()
          }
          return
        else
          @zeroHandled = false
          if @max_t == -1
            print("EZB force DONE\n")
            @@podan = nil
            @done = true
            return
          end
          
          UI.start_timer(3, false) {
            self.call_render_try()
          }
          return
        end
      end

      def call_render_try()
        
        if not self.stillWorking(@pod_filename)
          @pod_filename = self.pod_fnum_to_filename(@cur_fnum)
          print("EZB call_render_try: #{@pod_filename}\n")
          UI.start_timer(0, false) {
            name = 'podan_' + @cur_fnum.to_s.rjust(5,'0')
            Podium::render(:filename => name)
          }
          if @max_t == -1
            print("EZB force DONE\n")
            @@podan = nil
            @done = true
            return
          end    
          UI.start_timer(10, false) {
            if @max_t == -1
              print("EZB force DONE\n")
              @@podan = nil
              @done = true
              return
            end    
            self.update_view()
          }
          return
        else
          if @max_t == -1
            print("EZB force DONE\n")
            @@podan = nil
            @done = true
            return
          end
          print("EZB call_render_try 3 sec later\n")
          UI.start_timer(3, false) {
            self.call_render_try()
          }
          return
        end
      end

      
      def copy_view()
        if not self.stillWorking(@pod_filename)
          cpFileName = self.pod_fnum_to_filename(@cur_fnum)
          print("EZB cp #{@pod_filename} #{cpFileName}\n")
          FileUtils.cp(@pod_filename, cpFileName)
          
          if @max_t == -1
            print("EZB force DONE\n")
            @@podan = nil
            @done = true
            return
          end
          UI.start_timer(1, false) {
            self.update_view()
          }
          return
        else
          if @max_t == -1
            print("EZB force DONE\n")
            @@podan = nil
            @done = true
            return
          end
          UI.start_timer(3, false) {
            self.copy_view()
          }
          return
        end
      end
      
      def pod_fnum_to_filename(fnum)
        rj = @pod_dir + '/podan_' + fnum.to_s.rjust(5,'0') + '00000.png'
        return rj
      end
      
      def stillWorking(filename)
        if filename.nil?
          return false
        end
        
        begin
          fo = File.open(filename, 'rb')
          fo.close
          fw = File.open(filename, 'ab')
          fw.close
        rescue
          #print "EZB failed to read #{filename}\n"
          return true
        end
        return false
      end
    end

    @@warningGiven = false

    @@defaults = ['C:\Users\eugeneb\Desktop\podan_renderings']

    def self.run_podan
      if not @@warningGiven
        UI.messagebox("Podan is VERY RISKY to run; USE AT YOUR OWN RISK; see https://github.com/ezberta/podium-anim-sketchup", MB_MULTILINE, "Podan WARNING")
        @@warningGiven = true
      end

      @@podan ||= nil
      
      if not @@podan.nil? and not @@podan.done
        result = UI.messagebox('Cancel Podan Run?', MB_YESNO)
        if result == IDYES
          @@podan.forceCancel()
          UI.messagebox('Podan: You must cancel podium jobs, wait 2 min, and delete podan_*.png files before rerunning', MB_OK)
        end
        return
      end
      
      prompts = ["Podium Write Directory"]
      input = UI.inputbox(prompts, @@defaults, "Specify Podan Parameters")
      @@defaults = input.dup
      print(input)
      print(input[0])
      @@podan = PodanC.new(input[0])
      print(@@podan)
      @@podan.update_view()
      
    end
    
    unless file_loaded?(__FILE__)
      menu = UI.menu('Plugins')
      menu.add_item('Run/Cancel Podan') {
        self.run_podan
      }
      file_loaded(__FILE__)
    end
    
  end
end
