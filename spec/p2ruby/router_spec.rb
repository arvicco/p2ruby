## encoding: utf-8
#require 'spec_helper'
#require 'fileutils'
#
#QUIK_DIR = BASE_PATH + 'tmp/Info/'
#QUIK_PATH = QUIK_DIR + 'info.exe'
#QUIK_CLASS_MAIN = 'InfoClass'
#QUIK_CLASS_ERROR = 'MsgDialogClass'
#QUIK_CLASS_QUOTES = 'InfoMDITable'
##  QUIK_CLASS_DIALOG = '#32770'
#QUIK_TITLE_MAIN = 'Информационная система QUIK (версия 5.13.0.75)'.encode('cp1251', :undef => :replace)
#QUIK_TITLE_ERROR = 'QUIK: окно сообщений'.encode('cp1251', :undef => :replace)
#QUIK_TITLE_QUOTES = 'Test Quotes'
##  QUIK_TITLE_DIALOG = 'Идентификация пользователя'.encode('cp1251', :undef => :replace)
#
#
## Closes any open Quik application
#def close_quik
#  app = WinGui::App.find(class: QUIK_CLASS_MAIN)
#  app.exit(timeout=10) if app
#end
#
## Prepares test stand by copying Quik files to /tmp
#def prepare_quik_dir
#  FileUtils.rm_rf QUIK_DIR
#  FileUtils.cp_r BASE_PATH + 'misc/Info/', BASE_PATH + 'tmp/'
#end
#
#
#  close_quik
#  prepare_quik_dir
#
#  describe FinDrivers::QuikDriver do
#    let(:logger) { TestLogger.new }
#
#    it "raises error on invalid quik path" do
#      expect { described_class.new(BASE_PATH + 'tmp/', logger) }.
#              to raise_error WinGui::Errors::InitError, /Unable to launch .*info.exe/
#      logger.should_not log_entry /Quik launched/
#      logger.should log_entry /Unable to launch .*info.exe/, :error
#    end
#
#    it "raises error on invalid directory" do
#      expect { described_class.new(QUIK_DIR+'wrong/', logger) }.
#              to raise_error WinGui::Errors::InitError, /Unable to change to .*wrong/
#      logger.should_not log_entry /Quik launched/
#      logger.should log_entry /Unable to change to .*wrong/, :error
#    end
#
#    [QUIK_PATH, QUIK_PATH.to_s, QUIK_DIR, QUIK_DIR.to_s[0..-2]].each do |path|
#      context "initializing with args (#{path.inspect})" do
#
#        before(:all){ @quik_driver = FinDrivers::QuikDriver.new(path, logger) }
#        after(:all) { close_quik } # Reliably closes launched Quik
#
#        it 'launches Quik application' do
#          app = App.find(class: QUIK_CLASS_MAIN, timeout: 10)
#          app.should be_an App
#        end
#
#        it 'causes no Quik errors' do
#          Window.find(class: QUIK_CLASS_ERROR).should == nil
#        end
#
#        specify { logger.should log_entry /Quik launched in .*tmp.Info/, :info }
#      end
#    end
#
