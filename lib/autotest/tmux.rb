require 'rubygems'
require 'autotest'

##
# Autotest::Tmux shows autotest/autospec progress on tmux status-right.
#
# == Features
# * Screenshots aren't available yet. (but, almost same as autotest_screen[http://f.hatena.ne.jp/yoshuki/autotest_screen/].)
#
# == Synopsis
# $HOME/.autotest
#   require 'autotest/tmux'
#   # Autotest::Tmux.statusright = '"#22T" %H:%M %d-%b-%y (your statusright)'
#
# * To prevent server information (like "set option: status-right -> ..."), you should start tmux server with -q option first.
#

class Autotest::Tmux
  DEFAULT_STATUSRIGHT = '"#22T" %H:%M %d-%b-%y'
  DEFAULT_TMUX_CMD = 'tmux'

  SCREEN_COLOR = {
    :black  => ['white', 'black'],
    :green  => ['white', 'green'],
    :yellow => ['black', 'yellow'],
    :red    => ['white', 'red']
  }

  def self.message(msg=statusright, color=:black)
    col = SCREEN_COLOR[color]
    msg = "#[fg=#{col[0]},bg=#{col[1]}] #{msg} #[default]" unless msg == statusright
    send_cmd(msg)
  end

  def self.clear
    send_cmd('')
  end

  def self.run_tmux_session?
    cmd = "#{tmux_cmd} has-session"
    system cmd
  end

  def self.execute?
    !($TESTING || !run_tmux_session?)
  end

  @statusright = @tmux_cmd = nil
  def self.statusright; @statusright || DEFAULT_STATUSRIGHT.dup; end
  def self.statusright=(s); @statusright = s; end
  def self.tmux_cmd; @tmux_cmd || DEFAULT_TMUX_CMD.dup; end
  def self.tmux_cmd=(tc); @tmux_cmd = tc; end

  def self.send_cmd(msg)
    cmd = "#{tmux_cmd} set status-right '#{msg.gsub("'", "\'")}'"
    system cmd
    nil
  end

  @last_message = {}

  # All blocks return false, to execute each of following blocks defined in user's own ".autotest".

  # Do nothing.
  #Autotest.add_hook :all_good do |at, *args|
  #  next false
  #end

  Autotest.add_hook :died do |at, *args|
    message "Exception occured. (#{at.class})", :red
    puts "Exception occured. (#{at.class}): #{args.first}" unless args.nil?
    next false
  end

  # Do nothing.
  #Autotest.add_hook :green do |at, *args|
  #  next false
  #end

  Autotest.add_hook :initialize do |at, *args|
    message "Run with #{at.class}" if execute?
    next false
  end

  # Do nothing.
  #Autotest.add_hook :interrupt do |at, *args|
  #  next false
  #end

  Autotest.add_hook :quit do |at, *args|
    message if execute?
    next false
  end

  Autotest.add_hook :ran_command do |at, *args|
    next false unless execute?

    output = at.results.join
    class_name = at.class.name

    case class_name
    when 'Autotest', 'Autotest::Rails'
      results = output.scan(/(\d+)\s*failures?,\s*(\d+)\s*errors?/).first
      num_failures, num_errors = results.map{|r| r.to_i}

      if num_failures > 0 || num_errors > 0
        @last_message = {:message => "Red F:#{num_failures} E:#{num_errors}", :color => :red}
      else
        @last_message = {:message => 'All Green', :color => :green}
      end
    when 'Autotest::Rspec', 'Autotest::Rspec2', 'Autotest::RailsRspec', 'Autotest::MerbRspec'
      results = output.scan(/(\d+)\s*examples?,\s*(\d+)\s*failures?(?:,\s*(\d+)\s*pendings?)?/).first
      num_examples, num_failures, num_pendings = results.map{|r| r.to_i}

      if num_failures > 0
        @last_message = {:message => "Fail F:#{num_failures} P:#{num_pendings}", :color => :red}
      elsif num_pendings > 0
        @last_message = {:message => "Pend F:#{num_failures} P:#{num_pendings}", :color => :yellow}
      else
        @last_message = {:message => 'All Green', :color => :green}
      end
    else
      @last_message = {:message => "Unknown class name. (#{class_name})", :color => :red}
    end
    next false
  end

  # Do nothing.
  #Autotest.add_hook :red do |at, *args|
  #  next false
  #end

  # Do nothing.
  #Autotest.add_hook :reset do |at, *args|
  #  next false
  #end

  Autotest.add_hook :run_command do |at, *args|
    message 'Running' if execute?
    next false
  end

  # Do nothing.
  #Autotest.add_hook :updated do |at, *args|
  #  next false
  #end

  Autotest.add_hook :waiting do |at, *args|
    sleep 0.5
    message @last_message[:message], @last_message[:color] if execute?
    next false
  end
end
